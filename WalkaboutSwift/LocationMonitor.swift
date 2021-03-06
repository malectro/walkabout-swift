//
//  LocationMonitor.swift
//  WalkaboutSwift
//
//  Created by Kyle Warren on 5/28/21.
//

import Foundation
import CoreLocation


class LocationMonitor: NSObject, CLLocationManagerDelegate, ObservableObject {
  private let locationManager: CLLocationManager
  private var subscribers: Int = 0
  
  @Published var authorizationStatus: CLAuthorizationStatus
  @Published var currentLocation: CLLocation?
  @Published var error: Error?
  
  override init() {
    locationManager = CLLocationManager()
    authorizationStatus = locationManager.authorizationStatus
    
    super.init()
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
  }
  
  func requestPermission() {
    locationManager.requestWhenInUseAuthorization()
  }
  
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    authorizationStatus = manager.authorizationStatus
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError errorArg: Error) {
    error = errorArg
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    error = nil
    currentLocation = locations.first
  }
  
  func startUpdatingLocation() {
    self.subscribers += 1
    if self.subscribers == 1 {
      print("updating location")
      locationManager.startUpdatingLocation()
    }
  }
  
  func stopUpdatingLocation() {
    self.subscribers -= 1
    if self.subscribers == 0 {
      print("not updating location")
      locationManager.stopUpdatingLocation()
    }
  }
}

struct RegionMonitor {
  /*
  var locationMonitor: LocationMonitor {
    didSet {
      locationMonitor.$currentLocation.sink { <#CLLocation?#> in
        filterRegions()
      }
    }
  }
 */
  var regions: Array<CLCircularRegion> = []
  
  mutating func addRegion(region: CLCircularRegion) {
    regions.append(region)
  }
  
  func getRegionsAtCoordinate(coordinate: CLLocationCoordinate2D) -> Array<CLCircularRegion> {
    return regions.filter { region in
      region.contains(coordinate)
    }
  }
}
