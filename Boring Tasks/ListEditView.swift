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
    let strAddList: LocalizedStringKey = "ADD_LIST"
    let strDone: LocalizedStringKey = "DONE"
    let strCancel: LocalizedStringKey = "CANCEL"
    let strListTitle: LocalizedStringKey = "TASK_LIST_TITLE"

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField(strListTitle,
                        text: $title)
                }
            }
            .navigationBarTitle(strAddList, displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                print("Updated profile")
                self.closeAction()
            }, label: {
                Text(strCancel)
            }), trailing: Button(action: {
                self.doneAction(self.title)
            }, label: {
                Text(strDone)
            }))
        }.navigationViewStyle(StackNavigationViewStyle())

    }
    
}

struct ListEditView_Previews: PreviewProvider {
    static var previews: some View {
        ListEditView()
    }
}
