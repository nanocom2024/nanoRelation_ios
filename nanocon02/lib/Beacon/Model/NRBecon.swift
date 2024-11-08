//
//  BeconModel.swift
//  nanocon02
//
//  Created by 後藤裕太郎 on 2024/11/08.
//

import Foundation
import CoreBluetooth
import CoreLocation

class NRBeacon {
    
    static let UUIDStr: UUID          = UUID(uuidString: "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0")!
    static let identifier: String           = "NR_device"
    static let localName: String            = ""
    static var beaconRegion: CLBeaconRegion {
        return CLBeaconRegion(uuid: self.UUIDStr, identifier: self.identifier)
    }
    
    // CLBeaconIdentityConstraint
    static var constraintUUID: CLBeaconIdentityConstraint {
        // メジャーやマイナーでフィルターすることも可能
        return CLBeaconIdentityConstraint(uuid: DeviceConfig.iBeacon_uuid)
    }
}
