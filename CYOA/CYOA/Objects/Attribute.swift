//
//  Attribute.swift
//  CYOA
//
//  Created by Luigi Anonymus on 2020-02-18.
//  Copyright © 2020 Michael De Stefano. All rights reserved.
//

import Foundation
import Firebase

class Attribute: Codable {
    
    public var name: String
    public var value: Int
    
    init (name: String, value: Int) {
        self.name = name
        self.value = value
    }
    
    func updateValue(value: Int){
        self.value += value
    }
    
    func checkValue() -> Int {
        return self.value
    }
    
}
