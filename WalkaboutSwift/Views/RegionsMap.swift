//
//  RegionsMap.swift
//  WalkaboutSwift
//
//  Created by Kyle Warren on 6/7/21.
//

import MapKit
import SwiftUI

struct RegionsMap: View {
  @State private var sutroRegion = MKCoordinateRegion(
    center: CLLocationCoordinate2D(
      latitude: 37.772465, longitude: -122.445739
    ), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
  @State var selectedRegion: WalkaboutRegion?

  var regions: [WalkaboutRegion]
  var onSelect: (WalkaboutRegion) -> Void

  var body: some View {
    Map(
      coordinateRegion: $sutroRegion, showsUserLocation: true,
      annotationItems: regions
    ) {
      region in
      MapAnnotation(
        coordinate: region.locationCoordinate, anchorPoint: CGPoint(x: 0, y: 1)
      ) {
        ZStack(alignment: .center) {
          Circle().fill(AppColors.fg).frame(width: 10, height: 10).overlay(
            Circle().stroke(AppColors.bg, lineWidth: 1)
          ).shadow(radius: 4)
          if region == selectedRegion {
            region.image.resizable().aspectRatio(
              contentMode: .fill
            ).frame(
              width: 40, height: 30
            ).cornerRadius(4).offset(y: -30).shadow(radius: 10).overlay(
              RoundedRectangle(cornerRadius: 4).offset(y: -30).stroke(
                AppColors.fg, lineWidth: 2
              )
            )
          }
        }.frame(width: 10, height: 10).onTapGesture {
          if selectedRegion == region {
            onSelect(region)
          }
          selectedRegion = region
        }
      }
    }
  }
}

struct RegionsMap_Previews: PreviewProvider {
  static var regionsData: RegionData = RegionData()

  static var previews: some View {
    RegionsMap(regions: regionsData.regions) { region in
      print("Selected \(region)")
    }
  }
}
