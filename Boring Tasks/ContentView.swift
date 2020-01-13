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
    @Environment(\.managedObjectContext)
    var viewContext
 
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return ContentView().environment(\.managedObjectContext, context)
    }
}
