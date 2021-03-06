//
//  Attribute.swift
//  CYOA
//
//  Created by Michael De Stefano on 2020-02-18.
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
        let db = Firestore.firestore()
        if let user = Auth.auth().currentUser {
        let attributeRef =  db.collection("users").document(user.uid).collection("attributes")
            attributeRef.document(self.name).updateData([
                "value": self.value
            ])
        }
    }
    
    func checkValue() -> Int {
        return self.value
    }
}
