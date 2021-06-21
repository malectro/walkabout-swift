//
//  RegionDetail.swift
//  WalkaboutSwift
//
//  Created by Kyle Warren on 6/8/21.
//

import SwiftUI
import CoreLocation

struct RegionDetail: View {
  var region: WalkaboutRegion
  var onBack: () -> Void

  @Environment(\.managedObjectContext) private var viewContext
  @EnvironmentObject var locationMonitor: LocationMonitor
  @EnvironmentObject var regionsData: RegionData
  
  var currentLocation: CLLocation? {
    locationMonitor.currentLocation
  }
  
  @FetchRequest(entity: UserRegion.entity(), sortDescriptors: []) var userRegions: FetchedResults<UserRegion>
  
  var userRegion: UserRegion? {
    userRegions.first { userRegion in
          userRegion.regionId == region.id
        }
  }

  var body: some View {
    return GeometryReader { _ in
      ScrollView {
        VStack(alignment: .leading, spacing: Spacing.medium) {
          HStack {
            Spacer().overlay(
              Button(action: onBack) {
                Image(systemName: "chevron.backward")
              },
              alignment: .leading
            )
            Text(region.name).font(Fonts.title)
            Spacer()
          }
          region.image.resizable().aspectRatio(contentMode: .fit)
          if userRegion?.isUnlocked ?? false {
            HStack {
              Text("Decrypted")
              Spacer()
              Button("Lock", action: toggle)
            }
            if let name = region.audioFile {
              AudioPlayer(name: name)
            }
            if let text = region.text {
              Text(text)
            }
          } else {
            HStack {
              Text("Encrypted")
              Spacer()
              Button("Unlock", action: toggle)
            }
          }
          Spacer()
        }.foregroundColor(AppColors.fg).padding(.horizontal, Spacing.large)
      }
    }.navigationBarHidden(true)
      .background(AppColors.bg.ignoresSafeArea())
  }

  /*
  func toggle() {
    let userRegion = regionsData.getOrCreateUserRegion(id: region.id)
    if !userRegion.isUnlocked {
      /*
      var isNear: Bool
      if let currentLocation = currentLocation {
        isNear = region.containsLocation(currentLocation)
      } else {
        isNear = false
      }
       */
      let isNear = true
      
     if isNear {
       regionsData.unlockRegion(id: region.id)
     } else {
       print("cannot unlock location")
     }
    } else {
      regionsData.lockRegion(id: region.id)
    }
  }
  */

  func getOrCreateUserRegion(id: String) -> UserRegion {
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

  func toggle() {
    let dbUserRegion = self.userRegion
    var userRegion: UserRegion
    if let unwrappedUserRegion = dbUserRegion {
      userRegion = unwrappedUserRegion
    } else {
      userRegion = UserRegion(context: viewContext)
      userRegion.regionId = region.id
      userRegion.isUnlocked = false
    }
    
    
    if !userRegion.isUnlocked {
      /*
      var isNear: Bool
      if let currentLocation = currentLocation {
        isNear = region.containsLocation(currentLocation)
      } else {
        isNear = false
      }
       */
      let isNear = true
      
     if isNear {
       userRegion.isUnlocked = true
       for id in (region.reveals ?? []) {
         let userRegion = getOrCreateUserRegion(id: id)
         userRegion.isRevealed = true
       }
     } else {
       print("cannot unlock location")
     }
    } else {
      userRegion.isUnlocked = false
      for id in (region.reveals ?? []) {
        let userRegion = getOrCreateUserRegion(id: id)
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

struct RegionDetail_Previews: PreviewProvider {
  static var regionData = RegionData()

  static var previews: some View {
    RegionDetail(region: regionData.regions[0], onBack: {})
  }
}
