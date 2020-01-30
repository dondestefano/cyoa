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
    var path = [Scenario]()
    var currentScenario = Scenario(act: 0, chapter: 0)
    
    init(playerName: String){
        player = Player(name: playerName)
    }
    
    func chapterOne(){
        var name = ""
        if let player = player{
            name = player.name
        }
        let chapterOne = Scenario(act: 1, chapter: 1, paragraphOne: "Welcome \(name). This is the first chapter.", paragraphTwo: "\nThings will go down shortly, but in the meantime make a decision. ", paragraphThree: "Yes or no?", optionOne: "Yes", optionTwo: "No")
        path.append(chapterOne)
        currentScenario = chapterOne
    }
    
    func chapterTwo(decision: Int){
        var paragraphOne = ""
        var choice = ""
        
        if decision == 1 {
            paragraphOne = "Yes? That's interesting."
            choice = "yes"
        } else {
            paragraphOne = "No, you say? That's not very optimistic"
            choice = "no"
            player?.madeImportantChoice(choice: "Said no")
        }
        let chapterTwo = Scenario(act: 1, chapter: 2, paragraphOne: paragraphOne, paragraphTwo: "Why do you think you made this choice?", paragraphThree: "\nAre you used to saying \(choice) when asked a question?", optionOne: "Yes", optionTwo: "No")
        path.append(chapterTwo)
        currentScenario = chapterTwo
        
    }
    
    func chapterThree(decision: Int){
        var paragraphOne = ""
        var choice = ""
        var name = ""
        if let player = player{
            name = player.name
        }
            
        let saidNo = player?.checkForChoice(checkingForChoice: "Said no") ?? false
        
        if decision == 1 && saidNo {
            choice = "yes"
            paragraphOne = "Gotcha! turns out you can say \(choice) after all."
            
        } else if decision == 1 {
            choice = "yes"
            paragraphOne = "Another \(choice). How very predictable"
        } else if decision == 2 && saidNo {
            choice = "no"
            paragraphOne = "Another \(choice). How very predictable"
            
        } else {
            choice = "yes"
            paragraphOne = "Not just going by habit? I respect that."
        }
        let chapterThree = Scenario(act: 1, chapter: 3, paragraphOne: paragraphOne, paragraphTwo: "\nBut you're not here to answer yes or no questions.", paragraphThree: "\nYou want to hear a story don't you \(name)?", optionOne: "Yes!", optionTwo: "Another yes or no question?")
        path.append(chapterThree)
        currentScenario = chapterThree
        
    }
    
    func nextChapter(currentChapter: Int, decision: Int){
        if currentChapter == 1 {
            chapterTwo(decision: decision)
        } else if currentChapter == 2{
            chapterThree(decision: decision)
        }
    }
}
