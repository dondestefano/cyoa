//
//  Player.swift
//  CYOA
//
//  Created by Luigi Anonymus on 2020-01-29.
//  Copyright © 2020 Michael De Stefano. All rights reserved.
//

import Foundation

class Player {
    public let name : String
    public var choices = [String]()
    
    init(name: String) {
        self.name = name
    }
    
    func madeImportantChoice(choice: String){
        self.choices.append(choice)
    }
    
    func checkForChoice(checkingForChoice: String) -> Bool{
        for choice in choices {
            if checkingForChoice == choice {
                return true
            }
        }
    return false
    }
}
