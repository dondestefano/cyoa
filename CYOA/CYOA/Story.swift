//
//  Story.swift
//  CYOA
//
//  Created by Luigi Anonymus on 2020-01-29.
//  Copyright © 2020 Michael De Stefano. All rights reserved.
//

import Foundation

class Story {
    var player : Player?
    var path = [Chapter]()
    var currentChapter : Chapter
    
    init(playerName: String){
        player = Player(name: playerName)
        let chapter = Chapter(number: 1, text: "Let's get this first chapter started shall we!")
        let yes = Option(name: "Yes", outcome: "SaidYes", attribute: "heroic", attributeValue: 1)
        let no = Option(name: "No", outcome: "SaidNo", attribute: "heroic", attributeValue: -1)
        let what = Option(name: "What is this?", outcome: "confused")
        let what2 = Option(name: "What is this?", outcome: "confused")
        let what3 = Option(name: "What is this?", outcome: "confused")

        chapter.chapterOptions.append(yes)
        chapter.chapterOptions.append(no)
        chapter.chapterOptions.append(what)
        chapter.chapterOptions.append(what2)
                chapter.chapterOptions.append(what3)
        path.append(chapter)
        
        currentChapter = chapter
    }
}

