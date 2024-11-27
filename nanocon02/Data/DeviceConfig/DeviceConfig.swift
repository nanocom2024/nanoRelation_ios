//
//  DeviceConfig.swift
//  nanocon02
//
//  Created by k22036kk on 2024/09/11.
//

import Foundation
@preconcurrency import CoreBluetooth

class DeviceConfig {
    static let init_service_uuid = CBUUID(string: "442F1570-8A00-9A28-CBE1-E1D4212D53EB")
    static let init_characteristic_read_uuid = CBUUID(string: "442F1571-8A00-9A28-CBE1-E1D4212D53EB")
    static let init_characteristic_write_uuid = CBUUID(string: "442F1572-8A00-9A28-CBE1-E1D4212D53EB")
    static let init_characteristic_notify_uuid = CBUUID(string: "442F1573-8A00-9A28-CBE1-E1D4212D53EB")
    
    static let iBeacon_normal_uuid = UUID(uuidString: "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0")!
    static let iBeacon_lost_uuid = UUID(uuidString: "E2C56DB5-DFFB-48D2-B060-D0F5A71096E1")!
}
