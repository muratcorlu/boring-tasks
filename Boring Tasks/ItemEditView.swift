//
//  ItemEditView.swift
//  Boring Tasks
//
//  Created by Murat Corlu on 03/01/2020.
//  Copyright © 2020 Murat Corlu. All rights reserved.
//

import SwiftUI
import Combine

struct ItemEditView: View {
    @State var title: String = ""
    @State var period = "1"
    @State var periodType = "D"

    var closeAction: (() -> Void) = {}
    var doneAction: ((String, String, String) -> Void) = { a, b, c in }

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Title",
                        text: $title)
                    HStack {
                        Text("Will do it once per")
                        TextField("Count", text: $period)
                            .frame(width: 40)
                            .keyboardType(.numberPad)
                            .onReceive(Just(period)) { newValue in
                                let filtered = newValue.filter { "0123456789".contains($0) }
                                if filtered != newValue {
                                    self.period = filtered
                                }
                            }
                        Picker(selection: $periodType, label: Text("Period")) {
                            Text("days").tag("D")
                            Text("weeks").tag("W")
                            Text("months").tag("M")
                            Text("years").tag("Y")
                        }
                        Spacer()
                    }.labelsHidden()
                }
            }
            .navigationBarTitle("Add Task", displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                self.closeAction()
            }, label: {
                Text("Cancel")
            }), trailing: Button(action: {
                if !self.title.isEmpty {
                    self.doneAction(self.title, self.period, self.periodType)
                }
            }, label: {
                Text("Done")
            }))
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ItemEditView_Previews: PreviewProvider {
    static var previews: some View {
        ItemEditView()
    }
}
