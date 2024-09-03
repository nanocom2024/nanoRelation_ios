//
//  LostChildren.swift
//  nanocon02
//
//  Created by X22049xx on 2024/08/25.
//

import SwiftUI

struct LostChildren: View {
    var body: some View {
        VStack{//全体の縦構造
            
            NavigationLink(destination: Talk02()) {//下部アイコン01
                HStack{//各個人
                    Image("chilkoottrail")
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
                    
                    Image(systemName: "speaker.wave.2.circle")
                        .font(Font.system(size: 50, weight: .regular))
                }
                .foregroundColor(.black)
            }
            
            
            NavigationLink(destination: Talk02()) {//下部アイコン01
                HStack{//各個人
                    Image("chilkoottrail")
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
                    
                    Image(systemName: "speaker.wave.2.circle")
                        .font(Font.system(size: 50, weight: .regular))
                }
                .foregroundColor(.black)
            }
            
            Spacer()
        }
        .padding(EdgeInsets(top:-5,leading: 20,bottom: -20,trailing:20))
    }
}

#Preview {
    LostChildren()
}
