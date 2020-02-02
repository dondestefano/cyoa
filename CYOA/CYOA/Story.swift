//
//  Story.swift
//  CYOA
//
//  Created by Luigi Anonymus on 2020-01-29.
//  Copyright © 2020 Michael De Stefano. All rights reserved.
//

import Foundation
import Firebase

class Story {
    var player : Player?
    var path = [Chapter]()
    var currentChapter : Chapter
    let db = Firestore.firestore()
    
    init(playerName: String){
        player = Player(name: playerName)
        let chapter = Chapter(number: 1, text: "Let's get this first chapter started shall we!")
        let yes = Option(name: "Yes", outcome: "SaidYes", attribute: "Heroic", attributeValue: 1)
        let no = Option(name: "No", outcome: "SaidNo", attribute: "Heroic", attributeValue: -1)
        let what = Option(name: "What is this?", outcome: "confused")
        let what2 = Option(name: "What is this? I am super not ok with what is currently happening and would like to see how my tableview handles a longer text", outcome: "confused")
        let what3 = Option(name: "What is this?", outcome: "confused")

        chapter.chapterOptions.append(yes)
        chapter.chapterOptions.append(no)
        chapter.chapterOptions.append(what)
        chapter.chapterOptions.append(what2)
                chapter.chapterOptions.append(what3)
        path.append(chapter)
        
        currentChapter = chapter
    }
    
    func pathChosen(choice: Option) {
        player?.madeChoice(choice: choice.outcome)
        player?.updateAttribute(attributeToUpdate: choice.changedAttribute ?? "", value: choice.changeAttributeValue ?? 0)
    }
    
    
//    func getText() {
//        let textRef = db.collection("chapters")
//        textRef.document("chapterID").getDocument(){ (document , error) in
//            if let document = document, document.exists {
//                if let text: String = document.data() as? String {
//                    self.currentChapter.chapterText = text
//                }
//            }
//        }
//    }
}
