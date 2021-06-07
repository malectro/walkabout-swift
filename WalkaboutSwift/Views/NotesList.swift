//
//  NotesList.swift
//  WalkaboutSwift
//
//  Created by Kyle Warren on 6/7/21.
//

import SwiftUI

struct NotesList: View {
  var regions: [WalkaboutRegion]
  
  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 40) {
        ForEach(regions) {region in
          RegionListItem(region: region)
        }
      }
    }
  }
}

struct NotesList_Previews: PreviewProvider {
  static var regionData: RegionData = RegionData()
  
    static var previews: some View {
      NotesList(regions: regionData.regions)
    }
}


struct RegionListItem: View {
  var region: WalkaboutRegion
  
  var body: some View {
    VStack(alignment: .leading) {
      region.image.frame(height: 120).clipped().aspectRatio(contentMode: .fill)
      Text(region.name)
    }
  }
}
