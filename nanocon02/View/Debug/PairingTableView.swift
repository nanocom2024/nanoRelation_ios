//
//  PairingTableView.swift
//  nanocon02
//
//  Created by k22036kk on 2024/11/20.
//

import SwiftUI
import SwiftData

struct PairingTableView: View {
    @State private var pairings: [Pairing] = []
    
    var body: some View {
        VStack {
            Text(pairings.count.description)
            List {
                ForEach(pairings) { pairing in
                    PairingRow(pairing: pairing)
                }
            }
        }
        .onAppear {
            pairings = PairingDatastore.shared?.fetchAll() ?? []
        }
    }
}

struct PairingRow: View {
    let pairing: Pairing
    
    var body: some View {
        HStack {
            Text(pairing.user_uid)
            Spacer()
            Text(pairing.major)
            Spacer()
            Text(pairing.minor)
        }
    }
}


#Preview {
    PairingTableView()
}
