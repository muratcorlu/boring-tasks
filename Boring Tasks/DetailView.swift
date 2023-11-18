//
//  DetailView.swift
//  Boring Tasks
//
//  Created by Murat Corlu on 13/01/2020.
//  Copyright © 2020 Murat Corlu. All rights reserved.
//

import SwiftUI
import SwiftData

private let dateFormatter: RelativeDateTimeFormatter = {
    let formatter = RelativeDateTimeFormatter()
    formatter.dateTimeStyle = .named
    formatter.unitsStyle = .full
    return formatter
}()

struct DetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [TaskItem]
    
    @State private var showPopover: Bool = false

    @State var isModal: Bool = false
    @State var taskListMenu: Bool = false
    let strAddTask: LocalizedStringKey = "ADD_TASK"
    let strTaskDone: LocalizedStringKey = "ACTION_DONE"
    let strTaskSkip: LocalizedStringKey = "ACTION_SKIP"
    let strTaskDelete: LocalizedStringKey = "ACTION_DELETE"
    var taskList: TaskList

    init(taskList: TaskList) {
        self.taskList = taskList
        
//        let predicate = #Predicate<TaskItem> {
//            $0.list == taskList
//        }
//
//        _items = Query(filter: predicate, sort: \TaskItem.due)
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(items, id: \.self) { item in
                    NavigationLink(destination: ItemEditView()) {
                        VStack {
                            HStack {
                                Text(item.title!)
                                Text("\(item.due!, formatter: dateFormatter)")
                                    .foregroundColor(item.due! < Date() ? .red : .blue)
                                Spacer()
                            }
                            HStack {
                                if let activities = item.activities, activities.count > 0 {
                                    ForEach(activities.reversed(), id: \.self) { activity in
                                        RoundedRectangle(cornerRadius: 10)
                                            .frame(width: 10, height: 10, alignment: .leading)
                                            .foregroundColor(activity.type == "done" ? .blue : .gray)
                                    }
                                    Spacer()
                                }
                            }
                        }
                    }
                    .swipeActions(edge: .leading) {
                        Button { self.doAction(type: "done", item: item) } label: {
                            Label(self.strTaskDone, systemImage: "checkmark.circle")
                        }
                        .tint(.blue)
                    }
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) { print("delete") } label: {
                            Label(self.strTaskDelete, systemImage: "trash")
                        }
                        Button { self.doAction(type: "skip", item: item) } label: {
                            Label(self.strTaskSkip, systemImage: "chevron.right.2")
                        }
                        .tint(.orange)
                    }
                }.onDelete(perform: { indices in
                    indices.forEach {
                        modelContext.delete(self.items[$0])
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
                        let newList = TaskItem()
                        newList.title = title
                        newList.list = self.taskList
                        newList.period = "\(period)\(periodType)"

                        newList.due = self.extendDue(period: newList.period!)
                        
                        modelContext.insert(newList)
                        
                        self.isModal = false
                    })
                })
            }.padding()
        }

        .listStyle(GroupedListStyle())

        .navigationBarTitle(Text(taskList.title!))
        .navigationBarItems(trailing: Button(action: {
            self.taskListMenu = true
        }) {
            Image(systemName: "ellipsis")
                .foregroundColor(.blue)
                .padding()
                .background(Color.yellow)
                .mask(Circle())
        }.actionSheet(isPresented: self.$taskListMenu) {
            ActionSheet(title: Text("What do you want to do?"), message: Text("There's only one choice..."), buttons: [.default(Text("Share List")), .destructive(Text("Delete List"), action: {
                
            }), .cancel()])
        })
    }
    
    private func shareList() {
        
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
        let newActivity = TaskActivity()
        newActivity.date = Date()
        newActivity.item = item
        newActivity.type = type
        newActivity.score = item.score
        
        item.due = self.extendDue(period: item.period!)
        
        modelContext.insert(item)
    }
}

//struct UIKitCloudKitSharingButton: UIViewRepresentable {
//    typealias UIViewType = UIButton
//
//    @ObservedObject
//    var toShare: TaskList
//    @State
//    var share: CKShare?
//
//    func makeUIView(context: UIViewRepresentableContext<UIKitCloudKitSharingButton>) -> UIButton {
//        let button = UIButton()
//
//        button.setImage(UIImage(systemName: "person.crop.circle.badge.plus"), for: .normal)
//        button.addTarget(context.coordinator, action: #selector(context.coordinator.pressed(_:)), for: .touchUpInside)
//
//        context.coordinator.button = button
//        return button
//    }
//
//     func updateUIView(_ uiView: UIButton, context: UIViewRepresentableContext<UIKitCloudKitSharingButton>) {
//
//    }
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    class Coordinator: NSObject, UICloudSharingControllerDelegate {
//        var button: UIButton?
//
//        func cloudSharingController(_ csc: UICloudSharingController, failedToSaveShareWithError error: Error) {
//            //Handle some errors here.
//        }
//
//        func itemTitle(for csc: UICloudSharingController) -> String? {
//            return parent.toShare.title
//        }
//
//        var parent: UIKitCloudKitSharingButton
//
//        init(_ parent: UIKitCloudKitSharingButton) {
//            self.parent = parent
//        }
//
//        @objc func pressed(_ sender: UIButton) {
//            //Pre-Create the CKShare record here, and assign to parent.share...
//
//            let sharingController = UICloudSharingController(share: share, container: CloudManager.current.limitsContainer())
//
//            sharingController.delegate = self
//            sharingController.availablePermissions = [.allowReadWrite]
//            if let button = self.button {
//                sharingController.popoverPresentationController?.sourceView = button
//            }
//
//            UIApplication.shared.windows.first?.rootViewController?.present(sharingController, animated: true)
//        }
//    }
//}

#Preview {
    DetailView(taskList: TaskList(title: "Some List"))
}
