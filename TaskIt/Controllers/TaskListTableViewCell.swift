//
//  TaskListTableViewCell.swift
//  TaskIt
//
//  Created by Jorge Sirias on 11/19/25.
//

import UIKit

class TaskListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var taskTitleLabel: UILabel!
    @IBOutlet weak var taskDetailLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func Update(with task: Task){
        taskTitleLabel.text = task.taskLabel
        taskDetailLabel.text = task.taskDetail
    }
}
