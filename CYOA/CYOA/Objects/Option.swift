//
//  Option.swift
//  CYOA
//
//  Created by Luigi Anonymus on 2020-01-30.
//  Copyright © 2020 Michael De Stefano. All rights reserved.
//

import Foundation
import Firebase

class Option : Codable {
    public var name : String
    public var outcome : String
    public var changedAttribute : String?
    public var changedAttributeValue : Int?
    
    
    init (name: String, outcome: String) {
        self.name = name
        self.outcome = outcome
    }
    
    init (name: String, outcome: String, attribute: String, attributeValue: Int){
        self.name = name
        self.outcome = outcome
        self.changedAttribute = attribute
        self.changedAttributeValue = attributeValue
    }
}
