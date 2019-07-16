//
//  TaskDetailVC.swift
//  Tasks
//
//  Created by Seschwan on 7/9/19.
//  Copyright © 2019 Seschwan. All rights reserved.
//

import UIKit

class TaskDetailVC: UIViewController {
    
    // MARK: - Properties and Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var saveBtn:       UIBarButtonItem!
    @IBOutlet weak var prioritySegmentedControl: UISegmentedControl!
    
    var task: Task? {
        didSet {
            self.updateViews()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateBorders()
        self.updateViews()
        self.toggleSaveButton()
        self.nameTextField.addTarget(self, action: #selector(toggleSaveButton), for: .editingChanged)

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Actions and Methods
    
    @IBAction func saveTask(_ sender: UIBarButtonItem) {
        guard let taskName = self.nameTextField.text,
            !taskName.isEmpty else { return }
        
        let priorityIndex = prioritySegmentedControl.selectedSegmentIndex
        let priority = TaskPriority.allCases[priorityIndex]
        
        let notes = self.notesTextView.text
        if let task = self.task {
            task.name = taskName
            task.priority = priority.rawValue
            task.notes = notes
            
        } else {
            let _ = Task(name: taskName, notes: notes)
        }
        do {
            let moc = CoreDataStack.shared.mainContext
            try moc.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    private func updateBorders() {
        let borderWidth: CGFloat  = 1
        let borderRadius: CGFloat = 5
        let borderColor = UIColor.lightGray.cgColor
        
        notesTextView.layer.borderWidth  = borderWidth
        notesTextView.layer.cornerRadius = borderRadius
        notesTextView.layer.borderColor  = borderColor
        
        nameTextField.layer.borderWidth  = borderWidth
        nameTextField.layer.cornerRadius = borderRadius
        nameTextField.layer.borderColor  = borderColor
    }
    
    private func updateViews () {
        guard isViewLoaded else { return }
        let priority: TaskPriority
        if let taskPriority = task?.priority {
            priority = TaskPriority(rawValue: taskPriority)!
        } else {
            priority = .normal
        }
        
        prioritySegmentedControl.selectedSegmentIndex = TaskPriority.allCases.firstIndex(of: priority)! // Case Iterable
        self.navigationItem.title = self.task?.name ?? "Create Task"
        self.nameTextField.text = task?.name
        self.notesTextView.text = task?.notes
    }
    
    @objc private func toggleSaveButton() {
        self.saveBtn.isEnabled = !self.nameTextField.text!.isEmpty
    }


}
