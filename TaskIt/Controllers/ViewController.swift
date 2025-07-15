//
//  ViewController.swift
//  TaskIt
//
//  Created by Jorge Sirias on 9/1/24.
//

import UIKit

class ViewController: UIViewController,  UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var taskListTable: UITableView!
    var taskList: [Task] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        taskListTable.delegate = self
        taskListTable.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        taskListTable.reloadData()
    }
    
    @IBSegueAction func AddTasks(_ coder: NSCoder) -> AddTaskController? {
        return AddTaskController(coder: coder, task: nil)
    }
    @IBSegueAction func editTasks(_ coder: NSCoder, sender: Any?) -> AddTaskController? {
        
        let taskToEdit: Task?
        if let cell = sender as? UITableViewCell,
           let indexPath = taskListTable.indexPath(for: cell){
            taskToEdit = taskList[indexPath.row]
        }else{
            taskToEdit = nil
        }
        
        return AddTaskController(coder: coder, task: taskToEdit)
    }
    
    @IBAction func UnwindToTaskListTable(_ unwindSegue: UIStoryboardSegue){
        guard
            let AddTaskViewController = unwindSegue.source as? AddTaskController,
            let task = AddTaskViewController.task
        else {
             return
        }

        if let selectedIndexPath = taskListTable.indexPathForSelectedRow {
            taskList[selectedIndexPath.row] = task
        } else {
            taskList.append(task)
        }
    }
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        <#code#>
    }*/
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let taskCell = taskListTable.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath)
        let task = taskList[indexPath.row]
        
        taskCell.textLabel?.text = task.taskLabel
        return taskCell
    }
}
