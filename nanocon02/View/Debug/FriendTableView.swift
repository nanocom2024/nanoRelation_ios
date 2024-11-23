//
//  FriendTableView.swift
//  nanocon02
//
//  Created by k22036kk on 2024/11/21.
//

import SwiftUI
import SwiftData

struct FriendTableView: View {
    @State private var friends: [FriendData] = []
    
    var body: some View {
        VStack {
            Text(friends.count.description)
            List {
                ForEach(friends) { one_friend in
                    FriendRow(one_friend: one_friend)
                }
            }
        }
        .onAppear {
            friends = FriendDatastore.shared?.fetchAll() ?? []
        }
    }
}

struct FriendRow: View {
    let one_friend: FriendData
    
    var body: some View {
        HStack {
            Text(one_friend.user_uid)
            Spacer()
            Text(one_friend.name)
            Spacer()
            Text(one_friend.name_id)
        }
    }
}


#Preview {
    FriendTableView()
}
