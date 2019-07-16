//
//  Task+Convenience.swift
//  Tasks
//
//  Created by Seschwan on 7/9/19.
//  Copyright © 2019 Seschwan. All rights reserved.
//

import Foundation
import CoreData

enum TaskPriority: String, CaseIterable {
    case low
    case normal
    case high
    case critical
    
//    static var allPriorities: [TaskPriority] {
//        return [.low, .normal, .high, .critical]
//    }
}

extension Task {
    
    var tasRepresentation: TaskRepresentation? { // Computed property for database
        guard let name = self.name,
        let priority = self.priority else { return nil }
        return TaskRepresentation(name: name, notes: notes, priority: priority, identifier: identifier?.uuidString ?? " ")
    }
    convenience init(name: String, notes: String? = nil, priority: TaskPriority = .normal, identifier: UUID = UUID(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.name = name
        self.notes = notes
        self.priority = priority.rawValue
        self.identifier = identifier
    }
    
    convenience init?(taskRepresentation: TaskRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard let priority = TaskPriority(rawValue: taskRepresentation.priority),
            let identifier = UUID(uuidString: taskRepresentation.identifier) else { return nil }
        
        self.init(name: taskRepresentation.name,
                  notes: taskRepresentation.notes,
                  priority: priority,
                  identifier: identifier,
                  context: context)
    }
}
