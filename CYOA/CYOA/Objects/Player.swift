//
//  Player.swift
//  CYOA
//
//  Created by Luigi Anonymus on 2020-01-29.
//  Copyright © 2020 Michael De Stefano. All rights reserved.
//

import Foundation
import CoreData

class Player {
    public let name : String?
    public var choices = [String]()
    private var attributes: [Attribute] = []

    init(name: String) {
        self.name = name
        setAttribute(attributeName: "Heroic", attributeValue: 0)
        setAttribute(attributeName: "Agressive", attributeValue: 0)
        setAttribute(attributeName: "Charismatic", attributeValue: 0)
        setAttribute(attributeName: "Lucky", attributeValue: 5)
//        let heroic = Attribute(name: "Heroic", value: 0)
//        let agressive = Attribute(name: "Agressive", value: 0)
//        let charismatic = Attribute(name: "Charismatic", value: 0)
//        let lucky = Attribute(name: "Lucky", value: 5)
//        self.attributes.append(heroic)
//        self.attributes.append(agressive)
//        self.attributes.append(charismatic)
//        self.attributes.append(lucky)
    }
    
    func madeChoice(choice: String){
        self.choices.append(choice)
    }
    
    // See what vital choices the player has made
    func checkForChoice(checkingForChoice: String) -> Bool{
        for choice in choices {
            if checkingForChoice == choice {
                return true
            }
        }
    return false
    }
    
//* Attribute getters and setters *//
    func updateAttribute(attributeToUpdate: String, value: Int){
        for attribute in attributes{
            if attributeToUpdate == attribute.name {
                attribute.updateValue(value: value)
            }
        }
    }

    func checkAttribute(attributeToCheck: String) -> Int{
        for attribute in attributes{
            if attributeToCheck == attribute.name {
                return attribute.checkValue()
            }
        }
        return 0
    }
    
    func setAttribute(attributeName: String, attributeValue: Int) {
        let attribute = Attribute(name: attributeName, value: attributeValue)
        self.attributes.append(attribute)
        
    }
}
