//
//  TaskRepresentation.swift
//  Tasks
//
//  Created by Seschwan on 7/15/19.
//  Copyright © 2019 Seschwan. All rights reserved.
//

import Foundation

struct TaskRepresentation: Codable {
    var name: String
    var notes: String?
    var priority: String
    var identifier: String
    
}
