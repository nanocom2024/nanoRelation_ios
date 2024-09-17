//
//  UserBlePeripheral.swift
//  nanocon02
//
//  Created by k22036kk on 2024/09/11.
//

import CoreBluetooth

class UserBlePeripheral: Identifiable, ObservableObject, Hashable {

    @Published var id: UUID
    @Published var userPeripheral: CBPeripheral
    @Published var userServices: [UserBleService]
    @Published var name: String
    @Published var rssi: Int
    
    init(_userPeripheral: CBPeripheral,
         _userServices: [UserBleService],
         _name: String,
         _rssi: Int
         )
    {
        id = UUID()
        userServices = _userServices
        userPeripheral = _userPeripheral
        name = _name
        rssi = _rssi

    }
    
    // Hashableの実装
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)  // idを基にハッシュを計算
    }
    
    static func == (lhs: UserBlePeripheral, rhs: UserBlePeripheral) -> Bool {
        return lhs.id == rhs.id
    }
}
