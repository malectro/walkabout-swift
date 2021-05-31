//
//  WalkaboutRegion.swift
//  WalkaboutSwift
//
//  Created by Kyle Warren on 5/29/21.
//

import Foundation
import Combine
import CoreLocation

final class RegionData: ObservableObject {
  @Published var regions: [WalkaboutRegion] = load("regions.json")
  
  func getRegionsNearLocation(location: CLLocation) -> Array<WalkaboutRegion> {
    return regions.filter { region in
      location.distance(from: region.location) < region.radius
    }
  }
}

struct WalkaboutRegion : Hashable, Codable, Identifiable {
  var id: String
  var radius: Double
  
  private var coordinates: Coordinates
  var locationCoordinate: CLLocationCoordinate2D {
    CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)
  }
  var location: CLLocation {
    CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
  }
  struct Coordinates: Hashable, Codable {
    var latitude: Double
    var longitude: Double
  }
}
