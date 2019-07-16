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
    convenience init(name: String, notes: String? = nil, priority: TaskPriority = .normal, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.name = name
        self.notes = notes
        self.priority = priority.rawValue
    }
}
