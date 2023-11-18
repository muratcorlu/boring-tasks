//
//  TaskActivity.swift
//  
//
//  Created by Murat Çorlu on 16/11/2023.
//
//

import Foundation
import SwiftData


@Model public class TaskActivity {
    var date: Date?
    var score: Int16? = 0
    var type: String? = "done"
    var item: TaskItem?
    

    public init() { }
    
}
