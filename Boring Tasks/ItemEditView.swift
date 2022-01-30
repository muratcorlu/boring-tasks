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

    let strDone: LocalizedStringKey = "DONE"
    let strCancel: LocalizedStringKey = "CANCEL"
    
    let strAddTask: LocalizedStringKey = "ADD_TASK"
    let strTaskTitle: LocalizedStringKey = "TASK_TITLE"
    let strTaskPeriodPrefix: LocalizedStringKey = "ADD_TASK_PERIOD_PREFIX"
    let strTaskPeriodSuffix: LocalizedStringKey = "ADD_TASK_PERIOD_SUFFIX"
    
    let strAddTaskPeriodDays: LocalizedStringKey = "ADD_TASK_PERIOD_DAYS"
    let strAddTaskPeriodWeeks: LocalizedStringKey = "ADD_TASK_PERIOD_WEEKS"
    let strAddTaskPeriodMonths: LocalizedStringKey = "ADD_TASK_PERIOD_MONTHS"
    let strAddTaskPeriodYears: LocalizedStringKey = "ADD_TASK_PERIOD_YEARS"
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField(strTaskTitle,
                        text: $title)
                    HStack {
                        Text(strTaskPeriodPrefix)
                        TextField("Count", text: $period)
                            .multilineTextAlignment(.center)
                            .frame(width: 40)
                            .keyboardType(.numberPad)
                            .onReceive(Just(period)) { newValue in
                                let filtered = newValue.filter { "0123456789".contains($0) }
                                if filtered != newValue {
                                    self.period = filtered
                                }
                            }
                        Picker(selection: $periodType, label: Text("Period")) {
                            Text(strAddTaskPeriodDays).tag("D")
                            Text(strAddTaskPeriodWeeks).tag("W")
                            Text(strAddTaskPeriodMonths).tag("M")
                            Text(strAddTaskPeriodYears).tag("Y")
                        }
                        Text(strTaskPeriodSuffix)
                        Spacer()
                    }.labelsHidden()
                }
            }
            .navigationBarTitle(strAddTask, displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                self.closeAction()
            }, label: {
                Text(strCancel)
            }), trailing: Button(action: {
                if !self.title.isEmpty {
                    self.doneAction(self.title, self.period, self.periodType)
                }
            }, label: {
                Text(strDone)
            }))
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ItemEditView_Previews: PreviewProvider {
    static var previews: some View {
        ItemEditView()
    }
}
