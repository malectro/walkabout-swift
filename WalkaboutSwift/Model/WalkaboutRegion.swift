//
//  WalkaboutRegion.swift
//  WalkaboutSwift
//
//  Created by Kyle Warren on 5/29/21.
//

import Foundation
import SwiftUI
import Combine
import CoreLocation

final class RegionData: ObservableObject {
  @Published var regions: [WalkaboutRegion] = load("regions.json")
  
  func getRegion(id: String) -> WalkaboutRegion? {
    regions.first(where: {region in region.id == id})
  }
  
  func getRegionsNearLocation(location: CLLocation) -> Array<WalkaboutRegion> {
    return regions.filter { region in
      location.distance(from: region.location) < region.radius
    }
  }
}

struct WalkaboutRegion : Hashable, Codable, Identifiable {
  var id: String
  var radius: Double
  var name: String
  
  private var imageName: String
  var image: Image {
    Image(imageName)
  }
  
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
  
  func containsLocation(_ otherLocation: CLLocation) -> Bool {
    location.distance(from: otherLocation) < radius
  }
  
  var audioFile: String?
}
