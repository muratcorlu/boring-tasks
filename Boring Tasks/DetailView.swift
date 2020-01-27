//
//  DetailView.swift
//  Boring Tasks
//
//  Created by Murat Corlu on 13/01/2020.
//  Copyright © 2020 Murat Corlu. All rights reserved.
//

import SwiftUI
import CloudKit

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
    @State var taskListMenu: Bool = false
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
//        .navigationBarItems(trailing: Button(action: {
//            self.taskListMenu = true
//        }) {
//            Image(systemName: "ellipsis")
//                .foregroundColor(.blue)
//                .padding()
//                .background(Color.yellow)
//                .mask(Circle())
//        }.actionSheet(isPresented: self.$taskListMenu) {
//            ActionSheet(title: Text("What do you want to do?"), message: Text("There's only one choice..."), buttons: [.default(Text("Share List")), .destructive(Text("Delete List"), action: {
//                
//            }), .cancel()])
//        })
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

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(taskList: TaskList())
    }
}
