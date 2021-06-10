//
//  ContentView.swift
//  WalkaboutSwift
//
//  Created by Kyle Warren on 5/27/21.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
  @StateObject private var locationMonitor: LocationMonitor = LocationMonitor()
  
  var body: some View {
    switch locationMonitor.authorizationStatus {
    case .notDetermined:
      LocationPermissionView(action: locationMonitor.requestPermission)
    case .authorized, .authorizedAlways, .authorizedWhenInUse:
      WalkaboutNavigation().environmentObject(locationMonitor)
        .onAppear {
          print("got permission appear")
          locationMonitor.startUpdatingLocation()
        }
        .onDisappear { print("got permission disappear") }
    default:
      ErrorView(authorizationStatus: locationMonitor.authorizationStatus)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var modelData: ModelData = ModelData()
  
  static var previews: some View {
    ContentView()
      .environmentObject(modelData)
  }
}

struct GotPermission: View {
  @EnvironmentObject var locationMonitor: LocationMonitor
  @StateObject var regionData: RegionData = RegionData()
  var currentLocation: CLLocation? {
    locationMonitor.currentLocation
  }
  
  var body: some View {
    Group {
      if let currentLocation = currentLocation {
        let regions = regionData.getRegionsNearLocation(location: currentLocation)
        VStack {
          Text("Location").font(.title)
          Text("Latitude: \(currentLocation.coordinate.latitude)\nLongitude: \(currentLocation.coordinate.longitude)")
          ForEach(regions) { region in
            Text(region.id)
          }
          MapView(coordinate: currentLocation.coordinate)
        }
      } else if locationMonitor.error != nil {
        Text("oops \(locationMonitor.error!.localizedDescription)")
      } else {
        Text("oops")
      }
    }.onAppear(
      perform: locationMonitor.startUpdatingLocation
    ).onDisappear(perform: locationMonitor.stopUpdatingLocation)
  }
}

struct ErrorView: View {
  var authorizationStatus: CLAuthorizationStatus
  
  var body: some View {
    VStack {
      Text("This app requires location services.")
      Text("hi \(authorizationStatus.rawValue)")
    }
  }
}
