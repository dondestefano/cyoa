//
//  Story.swift
//  CYOA
//
//  Created by Luigi Anonymus on 2020-01-29.
//  Copyright © 2020 Michael De Stefano. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class Story {
    var player : Player?
    var path = [Chapter]()
    var availableOptions = [Option]()
    var currentChapter : Chapter
    var db : Firestore!
    
    init(){
        currentChapter = Chapter(number: 0, text: "")
    }
    
    init(playerName: String){
        player = Player(name: playerName)
        currentChapter = Chapter(number: 0, text: "")
    }
    
    // Progression functions //
    func pathChosen(choice: Option, completion: @escaping () -> ()) {
        player?.madeChoice(choice: choice.outcome)
        let attributeValue = choice.changedAttributeValue
        player?.updateAttribute(attributeToUpdate: choice.changedAttribute ?? "", value: attributeValue ?? 0)
        makePath(completion: completion)
    }
    
    //Check the player and choose the next chapter depending on its stats
    func makePath(completion: @escaping () -> ()){
        let currentHeroicStat = self.player?.checkAttribute(attributeToCheck: "Heroic")

            self.availableOptions.removeAll()
              if currentHeroicStat == 0 {
                self.nextChapter(chapterID: "ch1", firstOptionID: "op1", secondOptionID: "op11", thirdOptionID: nil, completion: completion)
             }
             else if currentHeroicStat == 1 {
                self.nextChapter(chapterID: "ch2+1", firstOptionID: "op1", secondOptionID: nil, thirdOptionID: nil, completion: completion)
             }
             else if currentHeroicStat == -1 {
                self.nextChapter(chapterID: "ch2-1", firstOptionID: "op11", secondOptionID: nil, thirdOptionID: nil, completion: completion)
             }
    }
    
    //Retrieve a chapter and options from Firebase
    func nextChapter(chapterID: String, firstOptionID: String, secondOptionID: String?, thirdOptionID: String?, completion: @escaping () -> ()) {
            self.readChapterFromDB(chapterID: chapterID, completion: completion)
            self.readOptionsFromDB(optionID: firstOptionID, completion: completion)
        
            guard let secondOption = secondOptionID else {return}
            self.readOptionsFromDB(optionID: secondOption, completion: completion)
        
            guard let thirdOption = thirdOptionID else {return}
            self.readOptionsFromDB(optionID: thirdOption, completion: completion)
    }
    
    // Database readers //
    func readChapterFromDB(chapterID : String, completion: @escaping () -> () ){
        let db = Firestore.firestore()
        let textRef = db.collection("chapters")
        textRef.document(chapterID).getDocument(){ (document , error) in
            if let document = document, document.exists {
                let result = Result {
                    try document.data(as: Chapter.self)
                }

                switch result {
                    case.success(let chapter):
                        if let chapter = chapter {
                            self.currentChapter = chapter
                            self.path.append(self.currentChapter)
                            completion()
                        }
                    case.failure(let error):
                        print("Error decoding: \(error)")
                }
            }
        }
    }
    
    
    func readOptionsFromDB(optionID : String, completion: @escaping () -> () ){
        let db = Firestore.firestore()
        let textRef = db.collection("Options")
        textRef.document(optionID).getDocument(){ (document , error) in
            if let document = document, document.exists {
                let result = Result {
                    try document.data(as: Option.self)
                }
                    
                switch result {
                    case.success(let option):
                        if let option = option {
                            self.availableOptions.append(option)
                            completion()
                        }
                    case.failure(let error):
                        print("Error decoding: \(error)")
                }
            }
        }
    }
}


