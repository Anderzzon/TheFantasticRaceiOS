//
//  LocationManager.swift
//  TheFantasticRace
//
//  Created by Erik Westervind on 2021-05-09.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject {
    var locationManager = CLLocationManager()
    //@Published var locationString = ""
    @Published var atStop = false
    var stopOrder = ""
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
    }
    
    func startLocationServices() {
        if locationManager.authorizationStatus == .authorizedAlways || locationManager.authorizationStatus == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func setUpMonitoring(for stops: [GameStop], with radius: Double) {
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            for stop in stops {
                let center = CLLocationCoordinate2D(latitude: stop.lat!, longitude: stop.lng!)
                
                let region = CLCircularRegion(center: center, radius: radius, identifier: String(stop.order))
                locationManager.startMonitoring(for: region)
            }
        }
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if locationManager.authorizationStatus == .authorizedAlways || locationManager.authorizationStatus == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        atStop = true
        stopOrder = region.identifier
        locationManager.stopMonitoring(for: region)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latest = locations.first else {
            return
        }
        
        //locationString = "location: \(latest.description)"
        //print("location: \(latest.description)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        guard let clError = error as? CLError else { return }
        switch clError {
        case CLError.denied:
            print("Access denied")
        default:
            print("cl error")
        }
    }
}
