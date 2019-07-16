//
//  TaskController.swift
//  Tasks
//
//  Created by Seschwan on 7/15/19.
//  Copyright © 2019 Seschwan. All rights reserved.
//

import Foundation
import CoreData

let baseURL = URL(string: "https://tasks-3f211.firebaseio.com/")!

class TaskController {
    
    typealias CompletionHandler = (Error?) -> Void
    
    init() {
        fetchTasksFromServer()
    }
    
    // Fetch the tasks from the server
    func fetchTasksFromServer(completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = baseURL.appendingPathExtension("json")
        URLSession.shared.dataTask(with: requestURL) { (data, _, error ) in
            if let error = error {
                NSLog("Error fetching tasks: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned by the data task")
                completion(error)
                return
            }
            
            do {
                let taskRepresentation = Array(try JSONDecoder().decode([String : TaskRepresentation].self, from: data).values)
                
                try self.updateTasks(with: taskRepresentation)
                completion(nil)
            } catch {
                NSLog("Error decoding task rep")
                completion(error)
                return
            }
        }.resume()
    }
    
    private func updateTasks(with representations: [TaskRepresentation]) throws {
        for taskRep in representations {
            guard let uuid = UUID(uuidString: taskRep.identifier) else { continue }
            
            let task = self.task(forUUID: uuid)
            
            if let task = task {
                self.update(task: task, with: taskRep)
                
            } else {
                let _ = Task(taskRepresentation: taskRep)
            }
            
        }
    }
    
    // Get task from UUID
    
    private func task(forUUID uuid: UUID) -> Task? {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", uuid as NSUUID)
        do {
            let moc = CoreDataStack.shared.mainContext
            return try moc.fetch(fetchRequest).first
        } catch {
            NSLog("Error fetching task with uuid \(uuid): \(error)")
            return nil
        }
    }
    
    // Update task with task rep from server
    private func update(task: Task, with representation: TaskRepresentation) {
        task.name = representation.name
        task.notes = representation.notes
        task.priority = representation.priority
    }
    
    // PUT Request
    
    func put(task: Task, completion: @escaping CompletionHandler = { _ in }) {
        let uuid = task.identifier ?? UUID()
        let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            guard var representation = task.tasRepresentation else {
                completion(NSError())
                return
            }
            
            representation.identifier = uuid.uuidString
            task.identifier = uuid
            try saveToPersistentStore()
            request.httpBody = try JSONEncoder().encode(representation)
            
        } catch {
            NSLog("Error encoding task: \(task): \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error putting task to server: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
        }.resume()
    }
    
    func saveToPersistentStore () throws {
        let moc = CoreDataStack.shared.mainContext
        try moc.save()
    }
    
    
    func deleteTaskFromServer(_ task: Task, completion: @escaping CompletionHandler = { _ in }) {
        guard let uuid = task.identifier else {
            completion(NSError())
            return
        }
        let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: requestURL) { (_, response, error) in
            print(response!)
            completion(error)
            
        }.resume()
    }
}
