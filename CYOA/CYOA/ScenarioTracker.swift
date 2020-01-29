//
//  ScenarioTracker.swift
//  CYOA
//
//  Created by Luigi Anonymus on 2020-01-26.
//  Copyright © 2020 Michael De Stefano. All rights reserved.
//
//
//import Foundation
//
//class ScenarioTracker {
//    var story = [Scenario]()
//    var currentScenarioIndex = 0
//    //var possibleStory = PossibleScenarios()
//
//    func newStory() -> Scenario {
//        if let firstScenario = possibleStory.getScenario(scenarioNumber: "11"){
//            self.story.append(firstScenario)
//        }
//        return self.story[0]
//    }
//
//
//    func calculateNextScenario(chosenPathValue: Int) {
//        //get the next scenario and add it to the story
//        let currentScenario = story[currentScenarioIndex]
//        let act = currentScenario.act
//        let chapter = currentScenario.chapter
//
//        if var currentChapter = chapter, var currentAct = act {
//            if currentChapter < 5 {
//                currentChapter += 1
//            } else {
//                currentAct += 1
//                currentChapter = 1
//            }
//            let nextChapter = String(currentAct) + String(currentChapter)
//            let chosenPath = String(chosenPathValue)
//            let nextScenario = nextChapter + chosenPath
//            if let newScenario = possibleStory.getScenario(scenarioNumber: nextScenario) {
//                self.story.append(newScenario)
//                //update index to keep track of which line in the array the story is at
//                self.currentScenarioIndex += 1
//            }
//        }
//
//    }
//}
