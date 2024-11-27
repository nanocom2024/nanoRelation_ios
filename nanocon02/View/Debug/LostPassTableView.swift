//
//  LostPassTableView.swift
//  nanocon02
//
//  Created by k22036kk on 2024/11/23.
//

import SwiftUI
import SwiftData

struct LostPassTableView: View {
    @State private var lostPasses: [LostPassData] = []
    
    var body: some View {
        VStack {
            Text(lostPasses.count.description)
            List {
                ForEach(lostPasses) { one_lost_pass in
                    LostPassRow(one_lost_pass: one_lost_pass)
                }
            }
        }
        .onAppear {
            lostPasses = LostPassDatastore.shared?.fetchAll() ?? []
        }
    }
}

struct LostPassRow: View {
    let one_lost_pass: LostPassData
    
    var body: some View {
        HStack {
            Text(one_lost_pass.major)
            Spacer()
            Text(one_lost_pass.minor)
            Spacer()
            Text(one_lost_pass.latitude?.description ?? "no-data")
            Spacer()
            Text(one_lost_pass.longitude?.description ?? "no-data")
            Spacer()
            Text(one_lost_pass.timestamp.description)
        }
    }
}


#Preview {
    LostPassTableView()
}
