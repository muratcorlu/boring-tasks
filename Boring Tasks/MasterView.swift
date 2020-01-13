//
//  MasterView.swift
//  Boring Tasks
//
//  Created by Murat Corlu on 13/01/2020.
//  Copyright © 2020 Murat Corlu. All rights reserved.
//

import SwiftUI

struct MasterView: View {
    @FetchRequest(
        entity: TaskList.entity(),
        sortDescriptors: [],
        animation: .default)
    var lists: FetchedResults<TaskList>

    @Environment(\.managedObjectContext)
    var viewContext

    @State var addListModal:Bool = false

    let strAddList: LocalizedStringKey = "ADD_LIST"
    
    var body: some View {
        VStack {
            List {
                ForEach(lists, id: \.self) { list in
                    NavigationLink(
                        destination: DetailView(taskList: list)
                    ) {
                        Text(list.title ?? "Unknown")
                    }
                }.onDelete(perform: { indices in
                    indices.forEach { self.viewContext.delete(self.lists[$0]) }
                    
                    do {
                       try self.viewContext.save()
                    } catch {
                        print("error")
                    }
                })
            }
            HStack {
                Spacer()
                Button(action: {
                    self.addListModal = true
                }) {
                    Text(strAddList)
                }.sheet(isPresented: $addListModal, content: {
                    ListEditView(closeAction: {
                        self.addListModal = false
                    }, doneAction: { title in
                        let newList = TaskList(context: self.viewContext)
                        newList.title = title
                        
                        do {
                            try self.viewContext.save()
                        } catch {
                            print("errorrrrrrrr")
                        }
                        
                        self.addListModal = false
                    })
                })
            }.padding()
        }.listStyle(GroupedListStyle())
    }
}

struct MasterView_Previews: PreviewProvider {
    static var previews: some View {
        MasterView()
    }
}
