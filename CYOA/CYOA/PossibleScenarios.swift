//
//  PossibleScenarios.swift
//  CYOA
//
//  Created by Luigi Anonymus on 2020-01-26.
//  Copyright © 2020 Michael De Stefano. All rights reserved.
//

import Foundation

class PossibleScenarios {
    
    private var everyScenario = [Scenario]()
    
    func getScenario(scenarioNumber: Int) -> Scenario? {
        var currentIndex = 0
        for Scenario in everyScenario {
            if Scenario.scenarioNumber == scenarioNumber {
                return everyScenario[currentIndex]
            }
        currentIndex += 1
        }
        return nil
    }
    
}
