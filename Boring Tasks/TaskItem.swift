//
//  TaskItem.swift
//  
//
//  Created by Murat Çorlu on 16/11/2023.
//
//

import Foundation
import SwiftData


@Model public class TaskItem {
    var due: Date?
    var period: String?
    var score: Int16? = 0
    var title: String?
    var activities: [TaskActivity]?
    var list: TaskList?
    

    public init() { }
    
}
