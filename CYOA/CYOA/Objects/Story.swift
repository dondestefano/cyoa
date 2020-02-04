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
    var newOptions = [Option]()
    var availableOptions = [Option]()
    var currentChapter : Chapter
    var db : Firestore!
    
    init(playerName: String){
        player = Player(name: playerName)
        currentChapter = Chapter(number: 0, text: "")
    }
    
    func pathChosen(choice: Option) {
        player?.madeChoice(choice: choice.outcome)
        let attributeValue = choice.changedAttributeValue
        player?.updateAttribute(attributeToUpdate: choice.changedAttribute ?? "", value: attributeValue ?? 0)
        makePath()
    }
    
    
    func makePath(){
        let currentHeroicStat = self.player?.checkAttribute(attributeToCheck: "Heroic")
        let group = DispatchGroup()
         group.enter()

         DispatchQueue.main.async {
            self.availableOptions.removeAll()
              if currentHeroicStat == 0 {
                self.nextChapter(chapterID: "ch1", firstOptionID: "op1", secondOptionID: "op11", thirdOptionID: "op1")
             }
             else if currentHeroicStat == 1 {
                self.nextChapter(chapterID: "ch2+1", firstOptionID: "op1", secondOptionID: nil, thirdOptionID: nil)
             }
             else if currentHeroicStat == -1 {
                self.nextChapter(chapterID: "ch2-1", firstOptionID: "op11", secondOptionID: nil, thirdOptionID: nil)
             }
             group.leave()
         }
        self.path.append(currentChapter)
    }
    
    func nextChapter(chapterID: String, firstOptionID: String, secondOptionID: String?, thirdOptionID: String?) {
            self.readChapterFromDB(chapterID: chapterID)
            self.readOptionsFromDB(optionID: firstOptionID)
        
            guard let secondOption = secondOptionID else {return}
            self.readOptionsFromDB(optionID: secondOption)
        
            guard let thirdOption = thirdOptionID else {return}
            self.readOptionsFromDB(optionID: thirdOption)
    }
    
    func readChapterFromDB(chapterID : String) {
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
                        }
                    case.failure(let error):
                        print("Error decoding: \(error)")
                }
            }
        }
    }
    
    func readOptionsFromDB(optionID : String){
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
                        }
                    case.failure(let error):
                        print("Error decoding: \(error)")
                }
            }
        }
    }
}


