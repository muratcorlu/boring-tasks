//
//  ContentView.swift
//  Boring Tasks
//
//  Created by Murat Corlu on 02/01/2020.
//  Copyright © 2020 Murat Corlu. All rights reserved.
//

import SwiftUI
import UIKit

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

    @State var addListModal:Bool = false
    
    let appName: LocalizedStringKey = "APP_NAME"
    var body: some View {
        NavigationView {
            MasterView()
                .navigationBarTitle(Text(appName))
                .navigationBarItems(
                    leading: EditButton()
                )
            Text("Please select/create a list to start")
        }.navigationViewStyle(DoubleColumnNavigationViewStyle())
    }
}

#Preview {
   ContentView()
}
