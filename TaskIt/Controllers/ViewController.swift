//
//  ViewController.swift
//  TaskIt
//
//  Created by Jorge Sirias on 9/1/24.
//

import UIKit

class ViewController: UIViewController,  UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var taskListEditButton: UIButton!
    @IBOutlet weak var taskListTable: UITableView!
    var taskList: [Task] = []
    var editButtonTapped = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        taskListTable.delegate = self
        taskListTable.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("view will appear")
        //Call function here to retrieve task list on disk
        RetrieveArchivedTaskList()
        if(taskList.count <= 0){
            taskListEditButton.isHidden = true
        }
        taskListTable.reloadData()
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        
        if(taskList.count <= 0){
            taskListEditButton.isHidden = true
        }
        print("View is appearing")
    }
    
    @IBAction func TaskListEditButtonPressed(_ sender: Any) {
        let tableViewEditingMode = taskListTable.isEditing
        
        taskListTable.setEditing(!tableViewEditingMode, animated: true)
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
        ArchiveTaskList(taskList)
        taskListTable.reloadData()
    }
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        <#code#>
    }*/
    
    func ArchiveTaskList(_ taskList: [Task]){
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let archiveURL = documentsDirectory.appendingPathComponent("TaskIt").appendingPathExtension("plist")
        
        let propertyListEncoder = PropertyListEncoder()
        let encodedTaskItList = try? propertyListEncoder.encode(taskList)
        
        try?  encodedTaskItList?.write(to: archiveURL, options: .noFileProtection)
    }
    
    func RetrieveArchivedTaskList(){
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let archiveURL = documentsDirectory.appendingPathComponent("TaskIt").appendingPathExtension("plist")
        
        let propertyListDecoder = PropertyListDecoder()
        
        if let retrievedArchivedTaskList = try? Data(contentsOf: archiveURL),
           let decodedArchivedTaskList = try? propertyListDecoder.decode(Array<Task>.self, from: retrievedArchivedTaskList){
            taskList = decodedArchivedTaskList
            print(retrievedArchivedTaskList)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let taskCell = taskListTable.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath)
        let task = taskList[indexPath.row]
        
        taskCell.showsReorderControl = true
        taskCell.textLabel?.text = task.taskLabel
        return taskCell
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedTask = taskList.remove(at: sourceIndexPath.row)
        taskList.insert(movedTask, at: destinationIndexPath.row)
        
        ArchiveTaskList(taskList)
        taskListTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            taskList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            ArchiveTaskList(taskList)
            taskListTable.reloadData()
        }
    }
}
