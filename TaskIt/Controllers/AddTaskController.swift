//
//  AddTaskController.swift
//  TaskIt
//
//  Created by Jorge Sirias on 6/18/25.
//

import UIKit

class AddTaskController: UIViewController {

    var task: Task?
    
    @IBOutlet weak var TextViewTaskDetail: UITextView!
    @IBOutlet weak var LabelTaskDetail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UpdateView()
        // Do any additional setup after loading the view.
    }
    
    init?(coder: NSCoder, task: Task?) {
        self.task = task
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func SaveTaskDetail(_ sender: UIBarButtonItem) {
        let labelText: String
        let textViewText: String
        
        if LabelTaskDetail.text == ""{
            return
        }else{
            labelText = LabelTaskDetail.text!
        }
        
        if TextViewTaskDetail.text.isEmpty{
            return
        }else{
            textViewText = TextViewTaskDetail.text!
        }
        
        task = Task(taskLabel: labelText, taskDetail: textViewText)
        
        performSegue(withIdentifier: "UnwindToTaskListViewController", sender: self)
    }
    
    private func UpdateView()
    {
        guard let task = task else{return}
        LabelTaskDetail.text = task.taskLabel
        TextViewTaskDetail.text = task.taskDetail
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
