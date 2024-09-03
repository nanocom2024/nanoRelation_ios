//
//  ContentView.swift
//  nanocon02
//
//  Created by X22049xx on 2024/08/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView{
            FriendList()
                .toolbar{
                    ToolbarItemGroup(placement: .bottomBar) {
//                        NavigationLink(destination: SecondView()) {//下部アイコン01
                            VStack{
                                Image(systemName: "person.fill")
                                    .font(Font.system(size: 40))
                                    .padding(.bottom, -10)
                                Text("友達")
                            }
                            .foregroundColor(.blue)
//                        }//下部アイコン01
                        .padding(EdgeInsets(top:0,leading: 15,bottom: -10,trailing:0))
                        Spacer()
                        
                        NavigationLink(destination: SecondView()) {//下部アイコン02
                            VStack{
                                Image(systemName: "person.2.slash.fill")
                                    .font(Font.system(size: 35))
                                    .padding(.bottom, -17)
                                Text("迷子リスト")
                            }
                            .foregroundColor(.gray)
                        }//下部アイコン02
                        .padding(.bottom, -10)
                        Spacer()
                        
                        NavigationLink(destination: ThirdView()) {//下部アイコン03
                            VStack{
                                Image(systemName: "figure.and.child.holdinghands")
                                    .font(Font.system(size: 35))
                                    .padding(.bottom, -10)
                                Text("子供")
                            }
                            .foregroundColor(.gray)
                        }//下部アイコン03
                        .padding(.bottom, -10)
                        Spacer()
                        
                        NavigationLink(destination: FourthView()) {//下部アイコン04
                            VStack{
                                Image(systemName: "person.circle.fill")
                                    .font(Font.system(size: 40))
                                    .padding(.bottom, -10)
                                Text("自分")
                            }
                            .foregroundColor(.gray)
                        }//下部アイコン04
                        .padding(EdgeInsets(top:0,leading: 0,bottom: -10,trailing:15))
                    }//ToolbarItemGroup
                }//.toolbar
        }//NavigationView
        .navigationBarBackButtonHidden(true)

    }
}

#Preview {
    ContentView()
}

