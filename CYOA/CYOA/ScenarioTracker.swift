//
//  ScenarioTracker.swift
//  CYOA
//
//  Created by Luigi Anonymus on 2020-01-26.
//  Copyright © 2020 Michael De Stefano. All rights reserved.
//

import Foundation

class ScenarioTracker {
    private var story = [Scenario]()
    private var possibleStory = PossibleScenarios()
    
    func calculateNextScenario(currentScenario: Int, choosenPath: Int) {
        let nextScenario = (currentScenario + choosenPath)
        if let newScenario = possibleStory.getScenario(scenarioNumber : nextScenario) {
        story.append(newScenario)
        }
        
    }
}
