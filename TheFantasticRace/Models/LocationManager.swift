//
//  LocationManager.swift
//  TheFantasticRace
//
//  Created by Erik Westervind on 2021-05-09.
//

import Foundation
import CoreLocation
import Combine
import UserNotifications

class LocationManager: NSObject, ObservableObject {
    var locationManager = CLLocationManager()
    @Published var atStop = false {
        didSet {
            if atStop {
                if lastStop {
                    gameFinished = true
                    showSheet = false
                } else {
                    showSheet = true
                }
                
            }
        }
    }
    @Published var showSheet = false
    @Published var gameFinished = false
    @Published var geofenceRegion: CLRegion?
    
    var stopOrder = ""
    var currentStop: GameStop?
    var lastStop = false
    var gameName = ""
    
    private var isAtStop: AnyPublisher<Bool, Never> {
        $atStop
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { input in
                return input
            }
            .eraseToAnyPublisher()
    }
    
    private var hasFinished: AnyPublisher<Bool, Never> {
        $gameFinished
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { input in
                return input
            }
            .eraseToAnyPublisher()
    }
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func startLocationServices() {
        if locationManager.authorizationStatus == .authorizedAlways || locationManager.authorizationStatus == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func createGeofence(for stop: GameStop, with radius: Double, isLastStop: Bool) {
        currentStop = stop
        lastStop = isLastStop
        
        let monitoredRegions = locationManager.monitoredRegions
        
        for region in monitoredRegions{
            locationManager.stopMonitoring(for: region)
        }
        
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            let center = CLLocationCoordinate2D(latitude: stop.lat!, longitude: stop.lng!)
            
            let region = CLCircularRegion(center: center, radius: radius, identifier: String(stop.order))
            locationManager.startMonitoring(for: region)
        }
        
    }
    
    func removeGeofence(for region: CLRegion) {
        locationManager.stopMonitoring(for: region)
        atStop = false
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
        geofenceRegion = region
        var notificationText = ""
        if lastStop {
            notificationText = "You have reached the final stop!"
        } else {
            notificationText = "You have now entered stop #\(Int(region.identifier)!+1)"
        }
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "\(gameName)"
        notificationContent.subtitle = notificationText
        notificationContent.body = "\(currentStop?.name ?? "")"
        notificationContent.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let notificatrionIDtoRemove = Int(region.identifier)!-1
        if notificatrionIDtoRemove > 0 {
            UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [String(notificatrionIDtoRemove)])
            
        }
        
        let request = UNNotificationRequest(identifier: region.identifier, content: notificationContent, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        atStop = false
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        if state == .inside {
            if state == .inside {
                self.atStop = true
                self.stopOrder = region.identifier
                self.geofenceRegion = region
            }
            
        } else {
            print("not here")
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latest = locations.first else { return }
        
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
