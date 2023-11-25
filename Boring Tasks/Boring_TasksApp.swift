//
//  Home_InventoryApp.swift
//  Home Inventory
//
//  Created by Murat Çorlu on 16/11/2023.
//

import SwiftUI
import SwiftData

@main
struct Boring_TasksApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [TaskItem.self,
                              TaskList.self,
                              TaskActivity.self])
    }
}
