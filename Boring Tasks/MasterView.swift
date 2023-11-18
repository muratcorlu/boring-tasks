//
//  MasterView.swift
//  Boring Tasks
//
//  Created by Murat Corlu on 13/01/2020.
//  Copyright © 2020 Murat Corlu. All rights reserved.
//

import SwiftUI
import SwiftData

struct MasterView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var lists: [TaskList]
    
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
                    indices.forEach {
                        modelContext.delete(self.lists[$0])
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
                        let newList = TaskList(title: title)
                        
                        modelContext.insert(newList)
                        
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
