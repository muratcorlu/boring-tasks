//
//  DetailView.swift
//  Boring Tasks
//
//  Created by Murat Corlu on 13/01/2020.
//  Copyright © 2020 Murat Corlu. All rights reserved.
//

import SwiftUI

private let dateFormatter: RelativeDateTimeFormatter = {
    let formatter = RelativeDateTimeFormatter()
    formatter.dateTimeStyle = .named
    formatter.unitsStyle = .full
    return formatter
}()

struct DetailView: View {
    @Environment(\.managedObjectContext)
    var viewContext

    var fetchRequest: FetchRequest<TaskItem>
    
    var items: FetchedResults<TaskItem>{
        fetchRequest.wrappedValue
    }
    
    @State private var showPopover: Bool = false

    @State var isModal: Bool = false
    let strAddTask: LocalizedStringKey = "ADD_TASK"
    let strTaskDone: LocalizedStringKey = "ACTION_DONE"
    let strTaskSkip: LocalizedStringKey = "ACTION_SKIP"
    var taskList: TaskList

    init(taskList: TaskList) {
        self.taskList = taskList
        
        fetchRequest = FetchRequest<TaskItem>(
            entity: TaskItem.entity(),
            sortDescriptors: [NSSortDescriptor(key: "due", ascending: true)],
            predicate: NSPredicate(format: "list == %@", taskList)
        )
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(items, id: \.self) { item in
                    VStack {
                        HStack {
                            Text(item.title!)
                            Text("\(item.due!, formatter: dateFormatter)")
                                .foregroundColor(item.due! < Date() ? .red : .blue)
                            Spacer()
                        }
                        HStack {
                            ForEach(item.history.reversed(), id: \.self) { activity in
                                RoundedRectangle(cornerRadius: 10)
                                    .frame(width: 10, height: 10, alignment: .leading)
                                    .foregroundColor(activity.type == "done" ? .blue : .gray)
                            }
                            Spacer()
                        }
                    }.contextMenu {
                        Button(action: { self.doAction(type: "done", item: item) }) {
                            HStack {
                                Text(self.strTaskDone)
                                Image(systemName: "checkmark.circle")
                            }
                        }
                        Button(action:  { self.doAction(type: "skip", item: item) }) {
                            HStack {
                                Text(self.strTaskSkip)
                                Image(systemName: "chevron.right.2")
                            }
                        }
                    }
                }.onDelete(perform: { indices in
                    indices.forEach { self.viewContext.delete(self.items[$0]) }
                    
                    do {
                       try self.viewContext.save()
                    } catch {
                        print("error")
                    }
                })
            }
            HStack {
                Spacer()
                Button(
                    action: {
                        self.isModal = true
                    }
                ) {
                    Text(strAddTask)
                }.sheet(isPresented: $isModal, content: {
                    ItemEditView(closeAction: {
                        self.isModal = false
                    }, doneAction: { title, period, periodType in
                        let newList = TaskItem(context: self.viewContext)
                        newList.title = title
                        newList.list = self.taskList
                        newList.period = "\(period)\(periodType)"

                        newList.due = self.extendDue(period: newList.period!)
                        
                        do {
                            try self.viewContext.save()
                        } catch {
                            print("errorrrrrrrr")
                        }
                        
                        self.isModal = false
                    })
                })
            }.padding()
        }

        .listStyle(GroupedListStyle())

        .navigationBarTitle(Text(taskList.title!))
    }
    
    private func extendDue(period: String) -> Date {
        var periodStr = period
        let periodType = periodStr.remove(at: periodStr.index(before: periodStr.endIndex))
        var periodValue = Int(periodStr) ?? 1
        
        var periodTypeObject: Calendar.Component

        switch periodType {
            case "D":
                periodTypeObject = .day
            case "W":
                periodTypeObject = .day
                periodValue = periodValue * 7
            case "M":
                periodTypeObject = .month
            case "Y":
                periodTypeObject = .year
            default:
                periodTypeObject = .day
        }
        
        return Calendar.current.date(byAdding: periodTypeObject, value: periodValue, to: Date())!
    }
    private func doAction(type: String, item: TaskItem) {
        let newActivity = TaskActivity(context: self.viewContext)
        newActivity.date = Date()
        newActivity.item = item
        newActivity.type = type
        newActivity.score = item.score
        
        item.due = self.extendDue(period: item.period!)
        
        do {
            try self.viewContext.save()
        } catch {
            print("error when set done")
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(taskList: TaskList())
    }
}
