//
//  Attribute+CoreDataProperties.swift
//  
//
//  Created by Luigi Anonymus on 2020-02-15.
//
//

import Foundation
import CoreData


extension Attribute {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Attribute> {
        return NSFetchRequest<Attribute>(entityName: "Attribute")
    }

    @NSManaged public var name: String?
    @NSManaged public var value: Int64

}
