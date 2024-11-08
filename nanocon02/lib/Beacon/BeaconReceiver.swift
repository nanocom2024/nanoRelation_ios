//
//  BeaconReceiver.swift
//  nanocon02
//
//  Created by k22036kk on 2024/09/12.
//

import Foundation
import CoreLocation

class BeaconReceiver: NSObject, ObservableObject {
    static let `default` = BeaconReceiver()
    
    var delegate: BeaconReceiverDelegate?
    
    var locationManager = CLLocationManager()
    

    @Published var beaconHistory: [String] = []
    @Published var latestBeaconInfo: BeaconInfo?
    @Published var currentLocation: CLLocation? // 最新の位置情報
    
    // init
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.allowsBackgroundLocationUpdates = true
    }
    
    // 起動時処理
    func initAwake() {
        // Nothing
    }
    
    // 領域の監視開始
    func startMonitoring() {
        let state = CLLocationManager().authorizationStatus
        guard state == .authorizedAlways else {
            switch state {
            case .notDetermined:
                // 再要求
                self.locationManager.requestAlwaysAuthorization()
            default:
                self.delegate?.requestLocationAlways()
                break
            }
            // monitoring false ユーザーステータスとしてどこかで一元管理　以降２箇所
            return
        }
        // monitoring true
        if self.isMonitoring() {
            return
        }
        self.locationManager.startMonitoring(for: NRBeacon.beaconRegion)
    }
    
    // 領域の監視停止
    func stopMonitoring() {
        // monitoring false
        
        if !self.isMonitoring() {
            return
        }
        self.locationManager.stopMonitoring(for: NRBeacon.beaconRegion)
    }
    
    func isMonitoring() -> Bool {
        for region in self.locationManager.monitoredRegions {
            if region.identifier == NRBeacon.identifier {
                return true
            }
        }
        return false
    }
}

// BeaconCentralManagerDelegate
protocol BeaconReceiverDelegate: AnyObject {
    func requestLocationAlways()
}

// CLLocationManagerDelegateメソッド群
extension BeaconReceiver : CLLocationManagerDelegate{
    // ---------------
    // 位置情報
    // ---------------
    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        for beacon in beacons {
            
            Task {
                let proximityString: String
                
                switch beacon.proximity {
                case .immediate:
                    proximityString = "Very Close"
                case .near:
                    proximityString = "Near"
                case .far:
                    proximityString = "Far Away"
                default:
                    proximityString = "Unknown"
                }
                
                let location = currentLocation
                let latitude = location?.coordinate.latitude
                let longitude = location?.coordinate.longitude
                
                DispatchQueue.main.async {
                    self.latestBeaconInfo = BeaconInfo(
                        proximity: proximityString,
                        major: beacon.major.stringValue,
                        minor: beacon.minor.stringValue,
                        rssi: beacon.rssi,
                        latitude: latitude,
                        longitude: longitude
                    )
                }
                
                // ビーコンの詳細情報
                let beaconInfo = "Proximity: \(proximityString),\nMajor: \(beacon.major), Minor: \(beacon.minor), RSSI: \(beacon.rssi)"
                
                DispatchQueue.main.async {
                    self.beaconHistory.append(beaconInfo)
                    if self.beaconHistory.count > 5 {
                        self.beaconHistory.removeFirst(self.beaconHistory.count - 5) // 最新5つのみ保持
                    }
                }
            }
            
        }
    }
    
    // 位置情報の更新が行われたときに呼ばれるメソッド
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // 最新の位置情報を取得
        if let location = locations.last {
            currentLocation = location
        }
    }
    
    // ---------------
    // 権限関連
    // ---------------
    // didChangeAuthorization: 位置情報の許可状況が変化したとき
     func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
         // Not Implemented
     }
    
    // ---------------
    // モニタリング
    // ---------------
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error)")
    }
    
    // didEnterRegion: ビーコン圏内に入ったとき
    private func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLBeaconRegion) {
        print(#function)
        
        // UUID指定でレンジング
        locationManager.startRangingBeacons(satisfying: NRBeacon.constraintUUID)
    }
    
    // didExitRegion: ビーコン圏内から出たとき（つまり周りに対象ビーコンがない）
    private func locationManager(_ manager: CLLocationManager, didExitRegion region: CLBeaconRegion) {
        print(#function)
        
        // レンジング停止
        locationManager.stopRangingBeacons(satisfying: NRBeacon.constraintUUID)
        
    }
    
    // ---------------
    // レンジング
    // ---------------
    // didRangeBeacons: レンジング中にiBeaconの情報を取得したとき
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        // ここでbeaconsに回りのビーコン情報を得られる
        // major,minorなどでフィルター処理
    }
    
    // rangingBeaconsDidFailFor: レンジング中にエラーが発生したとき
    func locationManager(_ manager: CLLocationManager, rangingBeaconsDidFailFor region: CLBeaconRegion, withError error: Error) {
        // Not Implemented
    }
}

struct BeaconInfo: Equatable {
//    var id: UUID = UUID()
    var proximity: String
    var major: String
    var minor: String
    var rssi: Int
    var latitude: Double? // 緯度
    var longitude: Double? // 経度
}
