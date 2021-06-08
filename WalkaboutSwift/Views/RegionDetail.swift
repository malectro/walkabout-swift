//
//  RegionDetail.swift
//  WalkaboutSwift
//
//  Created by Kyle Warren on 6/8/21.
//

import SwiftUI

struct RegionDetail: View {
  var region: WalkaboutRegion
  
    var body: some View {
      GeometryReader { geometryProxy in
      ScrollView {
      VStack(alignment: .leading, spacing: Spacing.medium) {
        Text(region.name).font(.title)
        region.image
        Text("Encrypted")
        Spacer()
      }.foregroundColor(AppColors.fg).padding(Spacing.large)
      }
      }.navigationBarTitleDisplayMode(.inline).background(AppColors.bg.ignoresSafeArea())
    }
}

struct RegionDetail_Previews: PreviewProvider {
  static var regionData = RegionData()
  
    static var previews: some View {
      RegionDetail(region: regionData.regions[0])
    }
}
