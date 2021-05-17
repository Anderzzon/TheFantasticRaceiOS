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
    //@Published var locationString = ""
    @Published var atStop = false {
        didSet {
            print("atStop changed", atStop)
            if atStop {
                showSheet = true
            }
        }
    }
    @Published var showSheet = false
    @Published var geofenceRegion: CLRegion?
    
    var stopOrder = ""
    var currentStop: GameStop?
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
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("Notifications set")
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
    
//    func setUpMonitoring(for stops: [GameStop], with radius: Double) {
//        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
//            for stop in stops {
//                let center = CLLocationCoordinate2D(latitude: stop.lat!, longitude: stop.lng!)
//
//                let region = CLCircularRegion(center: center, radius: radius, identifier: String(stop.order))
//                locationManager.startMonitoring(for: region)
//            }
//        }
//    }
    
    func createGeofence(for stop: GameStop, with radius: Double) {
        currentStop = stop
        
        let monitoredRegions = locationManager.monitoredRegions

        for region in monitoredRegions{
            locationManager.stopMonitoring(for: region)
        }
        
        print("All regions before ", locationManager.monitoredRegions)
        
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
                let center = CLLocationCoordinate2D(latitude: stop.lat!, longitude: stop.lng!)
                
                let region = CLCircularRegion(center: center, radius: radius, identifier: String(stop.order))
                locationManager.startMonitoring(for: region)
            print("Geofence created:", stop.name)
            
        }
        
        print("All regions after", locationManager.monitoredRegions)
    }
    
    func removeGeofence(for region: CLRegion) {
        locationManager.stopMonitoring(for: region)
        atStop = false
        print("Stoped minitoring for", region.identifier)
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if locationManager.authorizationStatus == .authorizedAlways || locationManager.authorizationStatus == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Entered geofence", region.identifier)
        atStop = true
        stopOrder = region.identifier
        //locationManager.stopMonitoring(for: region)
        geofenceRegion = region
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "\(gameName)"
        notificationContent.subtitle = "You have now entered stop #\(Int(region.identifier)!+1)"
        notificationContent.body = "\(currentStop?.name ?? "")"
        notificationContent.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
            let notificatrionIDtoRemove = Int(region.identifier)!-1
        if notificatrionIDtoRemove > 0 {
            UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [String(notificatrionIDtoRemove)])
            print("Notification removed")
        
        }
        
        let request = UNNotificationRequest(identifier: region.identifier, content: notificationContent, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        if state == .inside {
        print("Already inside geofence", region.identifier)
        print("Hashvalue:", region.hashValue)
        atStop = true
        stopOrder = region.identifier
        geofenceRegion = region
        //locationManager.stopMonitoring(for: region)
        } else {
            print("not here")
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latest = locations.first else { return }
        
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
