//
//  FriendList.swift
//  nanocon02
//
//  Created by X22049xx on 2024/08/23.
//

import SwiftUI

struct FriendList: View {
    var body: some View {
        VStack{//全体の縦構造
            HStack{//検索バーの部分
                Spacer()
                Image(systemName: "plus.circle")
                    .font(Font.system(size: 35, weight: .regular))
            }
            
            NavigationLink(destination: Talk01()) {//下部アイコン01
                HStack{//各個人
                    Image("charleyrivers")
                        .resizable()
                        .frame(width: 70, height: 70)
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading){
                        Text("なまえ")
                            .font(.headline)
                        Text("2024年1月20日 18時23分")
                            .font(.subheadline)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "figure.walk.circle")
                        .padding(-3.0)
                        .font(Font.system(size: 50, weight: .regular))
                    
                    Image(systemName: "speaker.wave.2.circle")
                        .font(Font.system(size: 50, weight: .regular))
                }
                .foregroundColor(.black)
            }
            
            NavigationLink(destination: Talk01()) {//下部アイコン01
                HStack{//各個人
                    Image("charleyrivers")
                        .resizable()
                        .frame(width: 70, height: 70)
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading){
                        Text("なまえ")
                            .font(.headline)
                        Text("2024年1月20日 18時23分")
                            .font(.subheadline)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "figure.walk.circle")
                        .padding(-3.0)
                        .font(Font.system(size: 50, weight: .regular))
                    
                    Image(systemName: "speaker.wave.2.circle")
                        .font(Font.system(size: 50, weight: .regular))
                }
                .foregroundColor(.black)
            }
            Spacer()
        }
        .padding(EdgeInsets(top:-15,leading: 20,bottom: -20,trailing:20))
    }
}

#Preview {
    FriendList()
}
