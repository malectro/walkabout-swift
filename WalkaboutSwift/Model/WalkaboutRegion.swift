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
import CoreData

final class RegionData: ObservableObject {
  @Published var regions: [WalkaboutRegion] = load("regions.json")
  
  var fetchRequest: FetchRequest<UserRegion> = FetchRequest(entity: UserRegion.entity(), sortDescriptors: [])
  var userRegionsDict: Dictionary<String, UserRegion> {
    Dictionary(uniqueKeysWithValues: fetchRequest.wrappedValue.map { userRegion in
          (userRegion.regionId ?? "bad-key", userRegion)
        })
  }
  var viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext
  
  func getRegion(id: String) -> WalkaboutRegion? {
    regions.first(where: {region in region.id == id})
  }
  
  func getRevealedRegions() -> Array<WalkaboutRegion> {
    let dict = userRegionsDict
    return regions.filter() { region in
      region.revealed || (dict[region.id]?.isRevealed ?? false)
    }
  }
  
  func getRegionsNearLocation(location: CLLocation) -> Array<WalkaboutRegion> {
    return regions.filter { region in
      location.distance(from: region.location) < region.radius
    }
  }
  
  func getOrCreateUserRegion(id: String) -> UserRegion {
    fetchRequest.update()
    let userRegion = fetchRequest.wrappedValue.first { userRegion in
      userRegion.regionId == id
    }
    
    if let userRegion = userRegion {
      return userRegion
    } else {
      let userRegion = UserRegion(context: viewContext)
      userRegion.regionId = id
      userRegion.isUnlocked = false
      userRegion.isRevealed = false
      return userRegion
    }
  }
  
  func unlockRegion(id: String) {
    print("unlocking")
    let userRegion = getOrCreateUserRegion(id: id)
    userRegion.isUnlocked = true
    
    if let region = getRegion(id: id) {
      for regionId in (region.reveals ?? []) {
        let userRegion = getOrCreateUserRegion(id: regionId)
        userRegion.isRevealed = true
      }
    }
    
    do {
      try viewContext.save()
    } catch {
      let nsError = error as NSError
      fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
    }
  }
  
  func lockRegion(id: String) {
    let userRegion = getOrCreateUserRegion(id: id)
    userRegion.isUnlocked = false
    
    if let region = getRegion(id: id) {
      for regionId in (region.reveals ?? []) {
        let userRegion = getOrCreateUserRegion(id: regionId)
        userRegion.isRevealed = false
      }
    }
    
    do {
      try viewContext.save()
    } catch {
      let nsError = error as NSError
      fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
    }
  }
}

struct WalkaboutRegion : Hashable, Codable, Identifiable {
  var id: String
  var radius: Double
  var name: String
  var text: String?
  var audioFile: String?
  var revealed: Bool
  var reveals: Array<String>?

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
}
