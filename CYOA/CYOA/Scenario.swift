//
//  Scenario.swift
//  CYOA
//
//  Created by Luigi Anonymus on 2020-01-25.
//  Copyright © 2020 Michael De Stefano. All rights reserved.
//

import Foundation
class Scenario {
    
    var act : Int?
    var chapter: Int?
    var paragraphOne : String?
    var paragraphTwo : String?
    var paragraphThree : String?
    var optionOne : String?
    var optionTwo : String?
    var scenarioNumber : String?
    
    //var possibleOptions[options]()
    
    init (act: Int, chapter: Int) {
        self.act = act
        self.chapter = chapter
    }

//  Old primitive Scenario changer
    
    init (act: Int, chapter: Int, paragraphOne: String?, paragraphTwo: String?, paragraphThree: String?, optionOne: String?, optionTwo: String?, scenarioNumber: String?) {
        self.act = act
        self.chapter = chapter
        self.paragraphOne = paragraphOne
        self.paragraphTwo = paragraphTwo
        self.paragraphThree = paragraphThree
        self.optionOne = optionOne
        self.optionTwo = optionTwo
        self.scenarioNumber = scenarioNumber
    }

    func getParagraph() -> String {
        var paragraph = ""
        //Convert all paragraphs to one string even if the scenario doesn't contain all three.
        if let paragraphOne = paragraphOne, let paragraphTwo = paragraphTwo, let paragraphThree = paragraphThree {
            paragraph = "\(paragraphOne) \(paragraphTwo) \(paragraphThree)"
        } else if let paragraphOne = paragraphOne, let paragraphThree = paragraphThree {
            paragraph = "\(paragraphOne) \(paragraphThree)"
        } else if let paragraphOne = paragraphOne, let paragraphTwo = paragraphTwo {
            paragraph = "\(paragraphOne) \(paragraphTwo)"
        }
        return paragraph
    }
    
    
}
