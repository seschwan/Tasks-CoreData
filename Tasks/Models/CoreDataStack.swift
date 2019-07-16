//
//  CoreDataStack.swift
//  Tasks
//
//  Created by Seschwan on 7/9/19.
//  Copyright © 2019 Seschwan. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Tasks") // This has to be the name of the Core Data name in Core Data Stack (Entity)
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        })
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        return self.container.viewContext
    }
    
}
