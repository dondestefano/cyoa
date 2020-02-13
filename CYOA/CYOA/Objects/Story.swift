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
    
    func formatText(){
        var formatedText = self.currentChapter.chapterText?.replacingOccurrences(of: "_b", with: "\n")
        formatedText = formatedText?.replacingOccurrences(of: ":player:", with: "\(self.player?.name ?? "Unknown")")
        self.currentChapter.chapterText = formatedText
    }
    
//* Progression functions *//
    func pathChosen(choice: Option, completion: @escaping () -> ()) {
        currentOption = choice
        
        // If the option came with a vital choice append it.
        if let vitalChoice = choice.vitalChoice{
            player?.madeChoice(choice: vitalChoice)
        }
        
        // Update the players attributes according to the chosen option.
        let attributeValue = choice.changedAttributeValue
        player?.updateAttribute(attributeToUpdate: choice.changedAttribute ?? "", value: attributeValue ?? 0)
        
        // With the attributes and choice in place - generate the next chapter.
        nextChapter(completion: completion)
    }
    
    func nextChapter(completion: @escaping () -> ()){
        self.readChapterFromDB(chapterNumber: currentChapter.chapterNumber, completion: completion)
    }
    
//* Database readers *//
    func readChapterFromDB(chapterNumber : Int, completion: @escaping () -> () ){
        let db = Firestore.firestore()
        let chapterRef = db.collection("chapters")
        chapterRef.whereField("previousChapter", in: [currentChapter.chapterNumber])
        .getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let result = Result {
                            try document.data(as: Chapter.self)
                        }

                        switch result {
                            case.success(let chapter):
                                if let chapter = chapter {
                                    // Check if the chapter is available.
                                    if self.checkAvailableChapter(chapter: chapter){
                                        // If there are more than one compatible chapters
                                        // determine which chapter to choose.
                                        if self.currentChapter.requiredChoice != nil && self.currentChapter.chapterNumber != chapterNumber {
                                            break
                                        }
                                        else {self.currentChapter = chapter}
                                    }
                                }
                            case.failure(let error):
                                print("Error decoding chapter: \(error)")
                            }
                        }
                self.currentChapter.chapterText = "\(self.currentOption?.outcome ?? "")\(self.currentChapter.chapterText ?? "Failed to load text.")"
                self.formatText()
                self.path.append(self.currentChapter)                
                //When the chapter is set - Remove previous options and get new ones.
                self.availableOptions.removeAll()
                self.readOptionsFromDB (completion: completion)
            }
        }
    }
    
    func readOptionsFromDB(completion: @escaping () -> () ){
        print("started")
        let db = Firestore.firestore()
        let optionsRef = db.collection("Options")
        // Get options that are compatible with the current chapter or has the value 0 (always compatible).
        optionsRef.whereField("compatibleChapter", in: [currentChapter.chapterNumber, 0])
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
                                    if self.checkAvailableOption(option: option) {
                                        self.availableOptions.append(option)
                                        print(option)
                                    }
                                }
                            case.failure(let err):
                                print("Error decoding option: \(err)")
                        }
                    }
                    completion()
                }
        }
    }
    
//* Availability checks *//
    func checkAvailableChapter(chapter: Chapter) -> Bool {
        let chapter = chapter
        // Check if the chapter has a required choice.
        if let requiredChoice = chapter.requiredChoice {
            // Check if the player has made the required choice.
            if self.player?.checkForChoice(checkingForChoice: requiredChoice) ?? false{
                return true
            } else {return false}
        }
        // If the chapter doesn't have a required choice return true.
        else {return true}
    }
    
    func checkAvailableOption(option: Option) -> Bool {
        let option = option
        // Check if the player has the required attribute value
        guard let requiredAttribute = option.requiredAttribute else {return false}
        guard let currentAttributeValue = self.player?.checkAttribute(attributeToCheck: requiredAttribute) else {return false}
        if option.requiredAttributeValue ?? 99 <= currentAttributeValue {
            // Check if the player has allready made this choice
            if self.player?.checkForChoice(checkingForChoice: option.vitalChoice ?? "") == false {
                // If the player has the required value and hasn't made this
                // choice before return true
                return true
            }
        }
        return false
    }
}
