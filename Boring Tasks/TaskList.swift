//
//  TaskItem.swift
//
//
//  Created by Murat Çorlu on 16/11/2023.
//
//

import Foundation
import SwiftData


@Model public class TaskList {
    var title: String?
    var items: [TaskList]?

    public init(title: String) {
        self.title = title
    }
    
}
