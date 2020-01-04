//
//  ListEditView.swift
//  Boring Tasks
//
//  Created by Murat Corlu on 04/01/2020.
//  Copyright © 2020 Murat Corlu. All rights reserved.
//

import SwiftUI

struct ListEditView: View {
    @State private var title = ""
    var closeAction: (() -> Void) = {}
    var doneAction: ((String) -> Void) = { a in }
    
    var body: some View {
        Form {
            Text("Add List")
            
            Section {
                TextField("List Title",
                          text: $title)
            }
            
            Section {
                Button(action: {
                    self.doneAction(self.title)
                }, label: {
                    Text("Done")
                })
                Button(action: {
                    print("Updated profile")
                    self.closeAction()
                }, label: {
                    Text("Cancel")
                })
            }
        }
    }
    
}

struct ListEditView_Previews: PreviewProvider {
    static var previews: some View {
        ListEditView()
    }
}
