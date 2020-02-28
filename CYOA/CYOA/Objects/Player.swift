//
//  Player.swift
//  CYOA
//
//  Created by Luigi Anonymus on 2020-01-29.
//  Copyright © 2020 Michael De Stefano. All rights reserved.
//

import Foundation
import Firebase

class Player {
    public var name : String?
    public var choices: [Option] = []
    private var attributes: [Attribute] = []
    var db: Firestore!
    
    init() {
        self.name = "Unknown"
    }

    init(name: String) {
        self.name = name
        self.setName(name: name)
        self.setAttribute(attributeName: "Fear", attributeValue: 0)
        self.setAttribute(attributeName: "Reason", attributeValue: 0)
        self.setAttribute(attributeName: "Evil", attributeValue: 0)
        self.readFromDB(collectionPath: "attributes", playerArray: "attributes", type: "Attribute")
        self.readFromDB(collectionPath: "choices", playerArray: "choices", type: "Option")
    }
    
    func madeChoice(choice: Option){
        let db = Firestore.firestore()
        if let user = Auth.auth().currentUser {
        let attributeRef =  db.collection("users").document(user.uid).collection("choices")
        do {
            try attributeRef.document().setData(from: choice)
               } catch let error {
                   print("Error writing: \(error)")
            }
        }
    }
    
    // See what vital choices the player has made
    func checkForChoice(checkingForChoice: String) -> Bool{
        for choice in choices {
            if checkingForChoice == choice.vitalChoice {
                return true
            }
        }
    return false
    }
    
//* Attribute getters and setters *//
    func updateAttribute(attributeToUpdate: String, value: Int){
        for attribute in attributes {
            if attribute.name == attributeToUpdate{
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
    
    func checkIfReasonIsStrongerThanFear() -> Bool{
        let fear = self.checkAttribute(attributeToCheck: "Fear")
        let reason = self.checkAttribute(attributeToCheck: "Reason")
        if reason >= fear {
            return true
        }
        return false
    }
    
    func setName(name: String) {
        let name = name
        let db = Firestore.firestore()
        if let user = Auth.auth().currentUser {
            let nameeRef =  db.collection("users").document(user.uid).collection("name")
            nameeRef.addDocument(data: ["name" : name])
        }
    }
    
    // Add the players attributes with custom ID's to the users database
    func setAttribute(attributeName: String, attributeValue: Int) {
        let attribute = Attribute(name: attributeName, value: attributeValue)
        let db = Firestore.firestore()
        if let user = Auth.auth().currentUser {
        let attributeRef =  db.collection("users").document(user.uid).collection("attributes")
        do {
            try attributeRef.document(attributeName).setData(from: attribute)
               } catch let error {
                   print("Error writing: \(error)")
            }
        }
    }

//* Database readers *//
    func loadPlayerFromDB() {
        self.readFromDB(collectionPath: "attributes", playerArray: "Attributes", type: "Attribute")
        self.readFromDB(collectionPath: "choices", playerArray: "choices", type: "Option")
        self.readNameFromDB()
    }
    
    func readFromDB(collectionPath: String, playerArray: String, type: String) {
        let db = Firebase.Firestore.firestore()
        if let user = Auth.auth().currentUser {
            let dataRef = db.collection("users").document(user.uid).collection(collectionPath)
                
            dataRef.addSnapshotListener() {
                (snapshot, error) in
                guard let documents = snapshot?.documents else {return}
                // If the type is Option read the players options.
                if type == "Option" {
                    self.choices.removeAll()
                    for document in documents {

                        let result = Result {
                            try document.data(as: Option.self)
                        }
                
                        switch result {
                            case.success(let option):
                                if let option = option {
                                    self.choices.append(option)
                                }
                            case.failure(let error):
                                print("Error decoding: \(error)")
                        }
                    }
                }
                    // If the type is Attribute read the players attributes.
                else if type == "Attribute" {
                    self.attributes.removeAll()
                    for document in documents {
                        let result = Result {
                            try document.data(as: Attribute.self)
                        }
                    
                        switch result {
                            case.success(let attribute):
                                if let attribute = attribute {
                                self.attributes.append(attribute)
                                }
                            case.failure(let error):
                                print("Error decoding: \(error)")
                        }
                    }
                }
            }
        }
    }
    
    func readNameFromDB() {
        let db = Firestore.firestore()
        if let user = Auth.auth().currentUser {
            let nameRef =  db.collection("users").document(user.uid).collection("name")
            nameRef.getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        // Convert the contents of documents to data and then to String
                        let data = document.data()
                        let name = data["name"] as? String ?? ""
                        
                        //Set the players name
                        self.name = name
                    }
                }
            }
        }
    }
}
