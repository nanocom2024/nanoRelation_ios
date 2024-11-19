//
//  ObservingChildView.swift
//  nanocon02
//
//  Created by k22036kk on 2024/11/18.
//

import SwiftUI

struct ObservingChildView: View {
    @EnvironmentObject var bleObj: BleCommViewModel
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            if BleCommViewModel.isObservingChild {
//                Text("Observing Child")
//                    .foregroundColor(.green)
                
                ZStack {
                    Color.green.opacity(0.2) // 背景色を指定し、透明度を調整
                        .edgesIgnoringSafeArea(.all) // 画面全体に適用
                        .cornerRadius(50)
                    VStack {
                        // アイコン
                        Image("test-img")
                            .resizable()
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white,lineWidth: 4))
                            .shadow(radius: 10)
                        
                        Text("子供が近くにいます")
                            .font(.largeTitle)
                            .fontWeight(.regular)
                            .multilineTextAlignment(.center) // 中央揃えにする
                    }
                    .frame(height: 300)
                    .padding(EdgeInsets(top:0,leading: 5,bottom: 0,trailing:5))
                }
                
            } else {
//                Text("Lost Child")
//                    .foregroundColor(.red)
                
                ZStack {
                    Color.red.opacity(0.2) // 背景色を指定し、透明度を調整
                            .edgesIgnoringSafeArea(.all) // 画面全体に適用
                            .cornerRadius(50)
                    VStack {
                        // アイコン
                        Image("test-img")
                            .resizable()
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white,lineWidth: 4))
                            .shadow(radius: 10)
                        
                        Text("子供が離れました")
                            .font(.largeTitle)
                            .fontWeight(.regular)
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center) // 中央揃えにする
                        
                    }
                    .frame(height: 300)
                    .padding(EdgeInsets(top:0,leading: 5,bottom: 0,trailing:5))
                }
                
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading:
                Button(action: goBack) {
                    Text("Back")
                        .padding()
                        .frame(width: 80.0, height: 30.0)
                        .foregroundColor(Color.white)
                        .background(Color.purple)
                        .cornerRadius(8)
                }
        )
        
    }
    
    func goBack(){
        self.dismiss()
        if let connectedUserBlePeripheral = bleObj.connectedUserBlePeripheral {
            // 対象のサービスを見つける
            var oneService: UserBleService = connectedUserBlePeripheral.userServices[0]
            for userService in connectedUserBlePeripheral.userServices {
                if userService.uuid == DeviceConfig.init_service_uuid {
                    oneService = userService
                    print("対象のサービスを発見")
                    break
                }
            }
            
            // notifyを停止
            for oneCh in oneService.userCharacteristics {
                if oneCh.uuid == DeviceConfig.init_characteristic_notify_uuid {
                    connectedUserBlePeripheral.userPeripheral.setNotifyValue(false, for: oneCh.characteristic)
                    break
                }
            }
            
            // disconnect
//            bleObj.centralManager?.cancelPeripheralConnection(connectedUserBlePeripheral.userPeripheral)
        }
    }
}

#Preview {
    let observingViewModel = BleCommViewModel()
    // 子供を観察中の状態
//    BleCommViewModel.isObservingChild = true
    // 迷子の状態
    BleCommViewModel.isObservingChild = false

    return ObservingChildView()
        .environmentObject(observingViewModel)
}
