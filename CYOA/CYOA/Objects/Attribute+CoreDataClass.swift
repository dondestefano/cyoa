//
//  Attribute+CoreDataClass.swift
//  
//
//  Created by Luigi Anonymus on 2020-02-15.
//
//

import Foundation
import CoreData

@objc(Attribute)
public class Attribute: NSManagedObject {
    
    func updateValue(value: Int64){
        self.value += value
    }
    
    func checkValue() -> Int64 {
        return self.value
    }

}
