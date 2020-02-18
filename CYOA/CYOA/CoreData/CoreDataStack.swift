//
//  CoreDataStack.swift
//  CYOA
//
//  Created by Luigi Anonymus on 2020-02-15.
//  Copyright © 2020 Michael De Stefano. All rights reserved.
//

import Foundation
import CoreData

class CoreDataHandler {
  
  static let persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "CYOA")
    container.loadPersistentStores { (_, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    }
    return container
  }()
  
  static var context: NSManagedObjectContext { return persistentContainer.viewContext }
  
  class func saveContext () {
    let context = persistentContainer.viewContext
    
    guard context.hasChanges else {
      return
    }
    
    do {
      try context.save()
    } catch {
      let nserror = error as NSError
      fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
    }
  }
}
