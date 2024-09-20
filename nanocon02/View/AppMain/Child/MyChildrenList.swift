//
//  MyChildren.swift
//  nanocon02
//
//  Created by X22049xx on 2024/08/27.
//

import SwiftUI

struct MyChildrenList: View {
    // @Stateでメッセージのリストを管理
    @State private var children: [Child] = []
    @StateObject private var myChildrenObj = MyChildrenListViewModel()
    @EnvironmentObject private var navigationModel: NavigationModel
    
    
    var body: some View {
        // 全体の縦構造
        VStack{

            // MARK: ナビゲーションバー
            HStack{
                Spacer()
                
//                // plus mark
//                Button(action: {
//                    children.append(Child(name: "なまえ"))
//                }) {
//                    Image(systemName: "plus.circle")
//                        .font(Font.system(size: 30, weight: .light))
////                        .foregroundColor(.gray)
//                        .foregroundColor(.black)
//                }
                
                Spacer().frame(width: 10)
                
                // setting mark
                Button(action: {
                    // test viewへ
                    navigationModel.path.append("test")
                }) {
                    Image(systemName: "gearshape")
                        .font(Font.system(size: 30, weight: .light))
                        .foregroundColor(.black)
                }
                
            }
            // MARK: - END ナビゲーションバー
            
            ScrollView { //スクロールする領域を指定
// ーーーーーーーーーーーーーーーーーmessages配列の要素をどのように並べるか、デザインーーーーーーーーーーーーーーーーーーー
                ForEach(children) { child in //ForEach　配列の要素を構成するとき使い回しするもの
                
                    NavigationLink(destination: Talk03()) {
                        HStack{ //各個人
                            child.image
                                .resizable()
                                .frame(width: 55, height: 55)
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading){
                                Text(child.name) // 配列内のメッセージを表示
                                    .font(.subheadline)
                                    .foregroundColor(.black)
//                                Text("2024年10月20日 18時23分")
//                                    .frame(width: 180)
//                                    .font(.subheadline)
//                                    .foregroundColor(.gray)
////                                    .background(.yellow)
                                    
                            }
                            
                            Spacer()
                            
                            Image(systemName: "figure.walk.circle")
                                .padding(-3.0)
                                .font(Font.system(size: 40, weight: .light))
                                .foregroundColor(.gray)

                            
                            Image(systemName: "speaker.wave.2.circle")
                                .font(Font.system(size: 40, weight: .light))
                                .foregroundColor(.gray)
                        }
                        .padding(.bottom,15)
                    }
                } // messages配列の中身を表示
// ーーーーーーーーーーーーーーーーーmessages配列の要素をどのように並べるか、デザインーーーーーーーーーーーーーーーーーーー
            } // ScrollView
            
        }
        .padding(EdgeInsets(top: 20, leading: 25, bottom: 0, trailing:25))
        .onAppear {
            Task {
                let children_data = await myChildrenObj.getChildren()
                DispatchQueue.main.async {
                    children = children_data
                }
            }
        }
    }
    // MARK: END - var body: some View
}

// メッセージの構造体
struct Child: Identifiable {
    let id: String // uid
    let name: String
    let image = Image("hiddenlake")
}


#Preview {
    MyChildrenList()
}
