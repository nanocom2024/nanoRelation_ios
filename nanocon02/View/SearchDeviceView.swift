//
//  SearchDeviceView.swift
//  nanocon02
//
//  Created by k22036kk on 2024/09/11.
//

import SwiftUI

struct SearchDeviceView: View {

    @EnvironmentObject private var bluetoothViewModel: BleCommViewModel
    @EnvironmentObject private var navigationModel: NavigationModel
    
    var body: some View {
            
            List {
                
                ForEach(bluetoothViewModel.foundPeripherals) { ele in

                    NavigationLink(destination: {
                        DeviceDetailView(oneDev: ele)
                            .environmentObject(bluetoothViewModel)
                    }, label: {
                        PeripheralCell(onePeri: ele)
                    })
                    
                }
            }
            .navigationBarTitle("BLE")
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
        navigationModel.path.removeLast()
        bluetoothViewModel.stopScanning()
    }
}

struct PeripheralCell: View {
        
    @ObservedObject var onePeri: UserBlePeripheral
    var body: some View {
        
        LabeledContent {
            Text("\(onePeri.rssi) dBm")
          
        } label: {
            Text(onePeri.name)
//            Text(String(onePeri.userPeripheral.identifier.uuidString.suffix(8)))   // show only last 8 chars
            
            Text(String(onePeri.userPeripheral.identifier.uuidString))              // show all chars
        }
            
    }
        
}
