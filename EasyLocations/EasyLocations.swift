//
//  EasyLocations.swift
//  EasyLocations
//
//  Created by Anatoly Myaskov on 1/12/19.
//  Copyright © 2019 Anatoly Myaskov. All rights reserved.
//

import Foundation
import CoreLocation

public typealias LocationsHandler = (_ locations: [CLLocation]?, _ status: EasyLocationsStatus?) -> ()

public enum EasyLocationsMode {
    case inUse
    case always
}

public enum EasyLocationsStatus {
    case allowed
    case denied
    case notEnabled
}

public class EasyLocations: NSObject {

    fileprivate var locationManager: CLLocationManager?
    fileprivate var mode: EasyLocationsMode?

    fileprivate var currentStatus: EasyLocationsStatus?

    fileprivate var handler: LocationsHandler?

    public init(mode: EasyLocationsMode = .inUse) {
        super.init()
        self.mode = mode
        locationManager = CLLocationManager()
    }

    public func requestAuthorization() {
        switch mode! {
        case .inUse:
            if Bundle.main.object(forInfoDictionaryKey: "NSLocationWhenInUseUsageDescription") == nil {
                fatalError("To work in the inUse mode, you need to add a line to the info.plist file: NSLocationWhenInUseUsageDescription")
            }
            locationManager!.requestWhenInUseAuthorization()

        case .always:
            if Bundle.main.object(forInfoDictionaryKey: "NSLocationAlwaysUsageDescription") == nil {
                fatalError("To work in the always mode, you need to add a line to the info.plist file: NSLocationAlwaysUsageDescription")
            }
            locationManager!.requestAlwaysAuthorization()
        }
    }

    public func checkStatus() -> EasyLocationsStatus {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                return .denied
            case .authorizedAlways, .authorizedWhenInUse:
                return .allowed
            }
        } else {
            return .notEnabled
        }
    }

    public func startUpdating() {
        locationManager!.delegate = self
        locationManager!.startUpdatingLocation()
    }

    public func stopUpdating() {
        locationManager!.stopUpdatingLocation()
    }

    public func locations(_ handler: @escaping LocationsHandler) {
        self.handler = handler
    }
}

extension EasyLocations: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.handler!(locations, self.currentStatus)
    }

    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                currentStatus = .denied
            case .authorizedAlways, .authorizedWhenInUse:
                currentStatus = .allowed
            }
        } else {
            currentStatus = .notEnabled
        }
    }
}
