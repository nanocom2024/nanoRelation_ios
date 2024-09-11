//
//  DetailView.swift
//  nanocon02
//
//  Created by k22036kk on 2024/09/11.
//

import SwiftUI
import CoreBluetooth

struct DeviceDetailView: View {
    
    @StateObject public var oneDev: UserBlePeripheral
    @StateObject public var bleViewModel: BleCommViewModel
    @State var connectionStatus: String = "Connecting ..."
    @EnvironmentObject private var navigationModel: NavigationModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Group {
            
            Text(oneDev.name)
            Spacer().frame(height: 20)
            
            if oneDev.userPeripheral.state == CBPeripheralState.connected {
                Text("connected")
                
                ForEach(bleViewModel.connectedUserBlePeripheral?.userServices ?? []) { item in
                    GroupBox(
                        label:
                            VStack {
                                Text("Service: \(item.serviceName)")
                                Text("\(item.uuid.uuidString) \n").font(.subheadline)
                            }
                    ) {
                        ForEach (item.userCharacteristics) { userChar in
                            Divider().padding(.vertical, 2)
                            NavigationLink(destination: CharacteristicPropertyView(
                                oneChar: userChar,
                                oneDevPeri: bleViewModel.connectedUserBlePeripheral!,
                                bleObj: bleViewModel)) {
                                    CharacteristicCell(onePeri: bleViewModel.connectedUserBlePeripheral!,
                                                       oneChar: userChar)
                            }
                        }
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.blue, lineWidth: 1)
                    ).padding(.horizontal, 10)  // padding border
                }
            } else {
                
                Text("\(connectionStatus)")
                
                var count = 0
                let _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                    if (count >= 3) {
                        connectionStatus = "Cannot connect"
                        timer.invalidate()
                    }
                    count += 1
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
        .onAppear{
            
            bleViewModel.centralManager?.connect(oneDev.userPeripheral)
//            print("Connecting")
        }
    }
    
    func goBack(){
        self.dismiss()
        bleViewModel.centralManager?.cancelPeripheralConnection(oneDev.userPeripheral)
    }
    
    struct CharacteristicCell: View {
        @ObservedObject var onePeri: UserBlePeripheral
        @ObservedObject var oneChar: UserBleCharacteristic
        
        var body: some View {
            LabeledContent {
                
                HStack {
//                    Image(systemName: "arrow.right.circle")
                }
                
            } label: {
                
                Text("Chars: \(oneChar.characteristicName)")
                Text(oneChar.uuid.uuidString)
                
            }
            .font(.subheadline)
            
        }
    }
}

//#Preview {
//    DetailView()
//}

