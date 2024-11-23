//
//  StreetPassTableView.swift
//  nanocon02
//
//  Created by k22036kk on 2024/11/23.
//

import SwiftUI
import SwiftData

struct StreetPassTableView: View {
    @State private var passes: [StreetPassData] = []
    
    var body: some View {
        VStack {
            Text(passes.count.description)
            List {
                ForEach(passes) { one_pass in
                    PassRow(one_pass: one_pass)
                }
            }
        }
        .onAppear {
            passes = StreetPassDatastore.shared?.fetchAll() ?? []
        }
    }
}

struct PassRow: View {
    let one_pass: StreetPassData
    
    var body: some View {
        HStack {
            Text(one_pass.user_uid)
            Spacer()
            Text(one_pass.timestamp.description)
        }
    }
}


#Preview {
    StreetPassTableView()
}
