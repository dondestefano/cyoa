//
//  Scenario.swift
//  CYOA
//
//  Created by Luigi Anonymus on 2020-01-25.
//  Copyright © 2020 Michael De Stefano. All rights reserved.
//

import Foundation

class Chapter : Codable {
    
    var chapterNumber: Int?
    var chapterText : String?
    
    init (number: Int, text: String) {
        self.chapterNumber = number
        self.chapterText = text
    }
}
