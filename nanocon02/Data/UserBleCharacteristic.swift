//
//  UserBleCharacteristic.swift
//  nanocon02
//
//  Created by k22036kk on 2024/09/11.
//

import CoreBluetooth

class UserBleCharacteristic: Identifiable, ObservableObject, Hashable {
    
    @Published var id: UUID
    @Published var characteristic: CBCharacteristic
    @Published var uuid: CBUUID
    @Published var characteristicName: String
    
    init(_characteristic: CBCharacteristic, _uuid: CBUUID, _characteristicName: String) {
        id = UUID()
        characteristic = _characteristic
        uuid = _uuid
        characteristicName = _characteristicName
    }
    
    static func == (lhs: UserBleCharacteristic, rhs: UserBleCharacteristic) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
