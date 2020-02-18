////
////  Option+CoreDataClass.swift
////
////
////  Created by Luigi Anonymus on 2020-02-15.
////
////
//
//import Foundation
//import CoreData
//import Firebase
//import FirebaseFirestoreSwift
//extension CodingUserInfoKey {
//    static let context = CodingUserInfoKey(rawValue: "context")!
//}
//extension JSONDecoder {
//    convenience init(context: NSManagedObjectContext) {
//        self.init()
//        self.userInfo[.context] = context
//    }
//}
//
//@objc(Option)
//public class Option: NSManagedObject, Codable {
//    
////    enum CodingKeys: String, CodingKey {
////            case name = "name"
////            case outcome = "outcome"
////            case changedAttribute = "attribute"
////            case changedAttributeValue = "attributeValue"
////            case requiredAttribute = "required_attribute"
////            case requiredAttributeValue = "requiredAttributeValue"
////            case compatibleChapter = "compatibleChapter"
////            case vitalChoice = "vitalChoice "
////    }
//
//    private enum CodingKeys: String, CodingKey { case name, outcome, changedAttribute, changedAttributeValue, requiredAttribute, compatibleChapter, vitalChoice }
//
//    required convenience public init(from decoder: Decoder) throws {
//        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else { fatalError("NSManagedObjectContext is missing") }
//        let entity = NSEntityDescription.entity(forEntityName: "Option", in: context)!
//        self.init(entity: entity, insertInto: context)
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        name = try values.decode(String.self, forKey: .name)
//        outcome = try values.decode(String.self.self, forKey: .outcome)
//        changedAttribute = try values.decode(Int64.self.self, forKey: .changedAttribute)
//        name = try values.decode(String.self, forKey: .name)
//        outcome = try values.decode(String.self.self, forKey: .outcome)
//        changedAttribute = try values.decode(Bool.self.self, forKey: .changedAttribute)

    
    
//    required convenience public init(from decoder: Decoder) throws {
//        guard let context = decoder.userInfo[CodingUserInfoKey.context!] as? NSManagedObjectContext else { fatalError() }
//        guard let entity = NSEntityDescription.entity(forEntityName: "Option", in: context) else { fatalError() }
//
//            self.init(entity: entity, insertInto: context)
//
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.name = try container.decodeIfPresent(String.self, forKey: .name)
//        self.outcome = try container.decodeIfPresent(String.self, forKey: .outcome)
//        self.changedAttribute = try container.decodeIfPresent(String.self, forKey: .changedAttribute)
//        self.changedAttributeValue = try (container.decodeIfPresent(Int64.self, forKey: .changedAttributeValue) ?? 0)
//        self.requiredAttribute = try container.decodeIfPresent(String.self, forKey: .requiredAttribute)
//        self.requiredAttributeValue = try (container.decodeIfPresent(Int64.self, forKey: .requiredAttributeValue) ?? 0)
//        self.compatibleChapter = try (container.decodeIfPresent(Int64.self, forKey: .compatibleChapter) ?? 0)
//        self.vitalChoice = try container.decodeIfPresent(String.self, forKey: .vitalChoice )
//    }
//}

