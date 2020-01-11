//
//  ListSwipeActions.swift
//  Boring Tasks
//
//  Created by Murat Corlu on 07/01/2020.
//  Copyright © 2020 Murat Corlu. All rights reserved.
//

import SwiftUI

struct ListSwipeActions: View {
    var body: some View {
        List {
            ForEach(1...5, id: \.self) { index in
                HStack {
                    ZStack {
                        Text("Done")
                            .background(Color.green)
                            .foregroundColor(.white)
                    }
                    Text("\(index). Item")
                    Spacer()
                    Text("Skip").frame(width: 100)
                        .background(Color.orange)
                        .foregroundColor(.white)

                }
            }
        }
    }
}

struct ListSwipeActions_Previews: PreviewProvider {
    static var previews: some View {
        ListSwipeActions()
    }
}
