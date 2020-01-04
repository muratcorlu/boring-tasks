//
//  ItemEditView.swift
//  Boring Tasks
//
//  Created by Murat Corlu on 03/01/2020.
//  Copyright © 2020 Murat Corlu. All rights reserved.
//

import SwiftUI

struct ItemEditView: View {
    @State var title: String = ""
    @State var period: Int = 1
    
    var closeAction: (() -> Void) = {}
    var doneAction: ((String, Int) -> Void) = { a, b in }

    var body: some View {
        Form {
            Section {
                TextField("Title",
                          text: $title)
                Stepper(value: $period,
                        in: 1...365,
                        label: {
                    Text("Will do it once per \(self.period) days")
                })
            }
            
            Section {
                Button(action: {
                    if !self.title.isEmpty {
                        self.doneAction(self.title, self.period)
                    }
                }, label: {
                    Text("Done")
                })
                Button(action: {
                    self.closeAction()
                }, label: {
                    Text("Cancel")
                })
            }
        }
    }
}

struct ItemEditView_Previews: PreviewProvider {
    static var previews: some View {
        ItemEditView()
    }
}
