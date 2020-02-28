//
//  Story.swift
//  CYOA
//
//  Created by Michael De Stefano on 2020-01-29.
//  Copyright © 2020 Michael De Stefano. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class Story {
    var player : Player?
    var path : [Chapter] = []
    var availableOptions : [Option] = []
    var currentChapter : Chapter
    var currentOption : Option?
    var db : Firestore!

    init(){
        currentChapter = Chapter(number: 0, text: "")
        player = Player()
    }

    init(playerName: String){
        print(playerName)
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

        // Add choice to the players choices.
        player?.madeChoice(choice: choice)

        // Update the players attributes according to the chosen option.
        let attributeValue = choice.changedAttributeValue
        player?.updateAttribute(attributeToUpdate: choice.changedAttribute ?? "", value: attributeValue ?? 0)

        // With the attributes and choice in place - generate the next chapter.
        nextChapter(completion: completion)
    }

    func nextChapter(completion: @escaping () -> ()){
        // Check if the player made a story ending choice
        if currentOption?.vitalChoice == "YouMonster"{
            self.readLastChapterFromDB(chapterName: "Horrible", completion: completion)
        }
        else if currentOption?.vitalChoice == "FreeHer"{
            if ((self.player?.checkIfReasonIsStrongerThanFear) != nil) {
                self.readLastChapterFromDB(chapterName: "TrueEnding", completion: completion)
            } else {
                self.readLastChapterFromDB(chapterName: "SoClose", completion: completion)
            }
        }
        else if currentOption?.vitalChoice == "BurnHer"{
            if ((self.player?.checkIfReasonIsStrongerThanFear) != nil) {
                self.readLastChapterFromDB(chapterName: "BurnWithReason", completion: completion)
            } else {
                self.readLastChapterFromDB(chapterName: "BurnWithFear", completion: completion)
            }
        }
        else {
            // If no story ending choice was made, load the next chapter in order.
            self.readChapterFromDB(chapterNumber: currentChapter.chapterNumber, completion: completion)
        }
    }

//* Database savers *//
    func saveChapterToDB(chapter: Chapter) {
        let db = Firestore.firestore()
        if let user = Auth.auth().currentUser {
        let attributeRef =  db.collection("users").document(user.uid).collection("path")
        do {
            try attributeRef.document().setData(from: chapter)
               } catch let error {
                   print("Error writing: \(error)")
            }
        }
    }
    
    func saveCurrentChapterToDB() {
        let db = Firestore.firestore()
        if let user = Auth.auth().currentUser {
        let attributeRef =  db.collection("users").document(user.uid).collection("currentChapter")
        do {
            try attributeRef.document("chapter").setData(from: self.currentChapter)
               } catch let error {
                   print("Error writing: \(error)")
            }
        }
    }

//* Database readers *//
    func readChapterFromDB(chapterNumber : Int, completion: @escaping () -> () ){
        let db = Firestore.firestore()
        let chapterRef = db.collection("chapters")
        // Get all chapters with the correct previous chapter.
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
                                    // If there are more than one compatible chapters - determine which chapter to choose depedning on vital choices.
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
                self.saveChapterToDB(chapter: self.currentChapter)
                
                // Save the currentChapter in the database.
                self.saveCurrentChapterToDB()
                
                //When the chapter is set - Remove previous options and get new ones.
                self.availableOptions.removeAll()
                self.readOptionsFromDB (completion: completion)
            }
        }
    }

    func readOptionsFromDB(completion: @escaping () -> () ){
        let db = Firestore.firestore()
        let optionsRef = db.collection("Options")
        // Get options that are compatible with the current chapter or has the value 0 (always compatible).
        optionsRef.whereField("compatibleChapter", in: [currentChapter.chapterNumber, 0])
        .getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                } else {
                self.availableOptions.removeAll()
                    for document in querySnapshot!.documents {
                        let result = Result {
                            try document.data(as: Option.self)
                        }
                        switch result {
                            case.success(let option):
                                if let option = option {
                                    if self.checkAvailableOption(option: option) {
                                        self.availableOptions.append(option)
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
    
    func readLastChapterFromDB(chapterName: String, completion: @escaping () -> () ){
        let db = Firestore.firestore()
        let textRef = db.collection("chapters")
        // Get the last chapter with the correct ID.
        textRef.document(chapterName).getDocument(){ (document , error) in
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
                        print("Error decoding chapter: \(error)")
                }
                self.currentChapter.chapterText = "\(self.currentOption?.outcome ?? "")\(self.currentChapter.chapterText ?? "Failed to load text.")"
                self.formatText()
                self.saveChapterToDB(chapter: self.currentChapter)
                
                // Save the currentChapter in the database.
                self.saveCurrentChapterToDB()
                self.availableOptions.removeAll()
                completion()
            }
        }
    }
    
    func readPathFromDB() {
        let db = Firestore.firestore()
        if let user = Auth.auth().currentUser {
        let nameRef =  db.collection("users").document(user.uid).collection("path").order(by: "chapterNumber")
            nameRef.addSnapshotListener() {
                (snapshot, error) in
                guard let documents = snapshot?.documents else {return}
                
                self.path.removeAll()
                for document in documents {
                    let result = Result {
                        try document.data(as: Chapter.self)
                    }
                    
                    switch result {
                    case.success(let chapter):
                        if let chapter = chapter {
                            self.path.append(chapter)
                        }
                    case.failure(let error):
                        print("Error decoding: \(error)")
                    }

                }
            }
        }
    }
    
    
    
    func loadCurrentChapterfromDB(completion: @escaping () -> () ) {
        let db = Firestore.firestore()
        if let user = Auth.auth().currentUser {
            let chapterRef =  db.collection("users").document(user.uid).collection("currentChapter")
            chapterRef.getDocuments() { (querySnapshot, err) in
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
                                self.currentChapter = chapter
                                completion()
                        }
                        case.failure(let error):
                            print("Error decoding chapter: \(error)")
                        }
                    }
                }
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
                print("\(requiredChoice)")
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
