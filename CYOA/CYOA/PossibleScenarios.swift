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
    
    func getScenario(scenarioNumber: String) -> Scenario? {
        var currentIndex = 0
        for Scenario in everyScenario {
            if let scenario = Scenario.scenarioNumber {
                print(scenarioNumber)
                if scenario == scenarioNumber {
                        return everyScenario[currentIndex]
                }
            currentIndex += 1
                }
        }
        return nil
    }
    
    func createScenarios() {
        let oneOne = Scenario(act: 1, chapter: 1, paragraphOne: "Typ en hel del text osv.", paragraphTwo: "Välj något här nere.", paragraphThree: "Det blir kul", optionOne: "K", optionTwo: "Bry", scenarioNumber: "11")
        self.everyScenario.append(oneOne)
        
        let oneTwoOne = Scenario(act: 1, chapter: 2, paragraphOne: "Originellt", paragraphTwo: nil, paragraphThree: "Verkligen", optionOne: "Vad vill du att jag ska göra då?", optionTwo: "Drygt!?", scenarioNumber: "121")
        self.everyScenario.append(oneTwoOne)
        
        let oneTwoTwo = Scenario(act: 1, chapter: 2, paragraphOne: "Hoppa bre", paragraphTwo: "Ska ge te dig", paragraphThree: nil, optionOne: "Kom då!", optionTwo: "Nej", scenarioNumber: "122")
        self.everyScenario.append(oneTwoTwo)
        
        let oneThreeOneOne = Scenario(act: 1, chapter: 3, paragraphOne: "1", paragraphTwo: "2", paragraphThree: nil, optionOne: "Kom då!", optionTwo: "Nej", scenarioNumber: "1311")
        self.everyScenario.append(oneThreeOneOne)
        
        let oneThreeTwoOne = Scenario(act: 1, chapter: 3, paragraphOne: "13", paragraphTwo: "21", paragraphThree: nil, optionOne: "Kom då!", optionTwo: "Nej", scenarioNumber: "1321")
        self.everyScenario.append(oneThreeTwoOne)
    }
    
}
