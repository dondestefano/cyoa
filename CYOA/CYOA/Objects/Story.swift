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
    var currentOption : Option?
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
        currentOption = choice
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
                self.nextChapter(chapterID: "ch1", completion: completion)
             }
             else if currentHeroicStat == 1 {
                self.nextChapter(chapterID: "ch2+1", completion: completion)
             }
             else if currentHeroicStat == -1 {
                self.nextChapter(chapterID: "ch2-1", completion: completion)
             }
    }
    
    //Retrieve a chapter and options from Firebase
    func nextChapter(chapterID: String, completion: @escaping () -> ()) {
            self.readChapterFromDB(chapterID: chapterID, completion: completion)
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
                            self.currentChapter.chapterText = "\(self.currentOption?.outcome ?? "")\(self.currentChapter.chapterText ?? "Failed to load text.") "
                            completion()
                            self.path.append(self.currentChapter)
                            self.readOptionsFromDB (completion: completion)
                        }
                    case.failure(let error):
                        print("Error decoding: \(error)")
                }
            }
        }
    }
    
    func readOptionsFromDB(completion: @escaping () -> () ){
        let db = Firestore.firestore()
        let ref = db.collection("Options")
        //Get chapters that are compatible with the current chapter or has the value 0 (always compatible)
        ref.whereField("compatibleChapter", in: [currentChapter.chapterNumber ?? 99, 0])
            .getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let result = Result {
                            try document.data(as: Option.self)
                        }
                        switch result {
                        case.success(let option):
                            if let option = option {
                                guard let requiredAttribute = option.requiredAttribute else {return}
                                guard let currentAttributeValue = self.player?.checkAttribute(attributeToCheck: requiredAttribute) else {return}
                                
                                //Check if the player has the required attribute value
                                if option.requiredAttributeValue ?? 99 <= currentAttributeValue {
                                    //Check if the player has allready made this choice
                                    if self.player?.checkForChoice(checkingForChoice: option.outcome) == false {
                                            //If the player has the required value and hasnn't amde this
                                            //choice before. Add the option to the scenario
                                            self.availableOptions.append(option)
                                            completion()
                                        
                                    }
                                }
                        }
                        
                        case.failure(let err):
                            print("Error decoding: \(err)")
                        }
                    }
                }
        }
    }
}
