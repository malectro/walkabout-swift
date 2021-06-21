//
//  NotesList.swift
//  WalkaboutSwift
//
//  Created by Kyle Warren on 6/7/21.
//

import SwiftUI

struct NotesList: View {
  var regions: [WalkaboutRegion]
  @Binding var selectedRegion: String?
  @EnvironmentObject var regionsData: RegionData
  
  @FetchRequest(entity: UserRegion.entity(), sortDescriptors: []) var userRegions: FetchedResults<UserRegion>
  
  var userRegionsDict: Dictionary<String, UserRegion> {
    Dictionary(uniqueKeysWithValues: userRegions.map { userRegion in
          (userRegion.regionId ?? "bad-key", userRegion)
        })
  }

  
  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 40) {
        ForEach(regions) {region in
          NavigationLink(destination: RegionDetail(region: region).environmentObject(regionsData), tag: region.id, selection: $selectedRegion) {
            RegionListItem(region: region, isUnlocked: userRegionsDict[region.id]?.isUnlocked ?? false)
          }
        }
      }
    }
  }
}

struct NotesList_Previews: PreviewProvider {
  static var regionData: RegionData = RegionData()
  
    static var previews: some View {
      NotesList(regions: regionData.regions, selectedRegion: .constant("hi"))
    }
}


struct RegionListItem: View {
  var region: WalkaboutRegion
  var isUnlocked: Bool
  
  var body: some View {
    VStack(alignment: .leading) {
      region.image.resizable()
        .aspectRatio(contentMode: .fill)
        .frame(height: 120, alignment: .center).clipped()
      /*
       region.image.frame(maxWidth: .infinity, maxHeight: 120).clipped().aspectRatio(contentMode: .fill)
        */
      HStack {
        Text(region.name)
        Spacer()
        if isUnlocked {
          Text("Decrypted")
        } else {
          Text("Encrypted")
        }
      }
    }
  }
}
