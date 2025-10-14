//
//  Task.swift
//  TaskIt
//
//  Created by Jorge Sirias on 6/18/25.
//

import Foundation

struct Task: Encodable, Decodable{
    var taskLabel: String = ""
    var taskDetail: String = ""
}
