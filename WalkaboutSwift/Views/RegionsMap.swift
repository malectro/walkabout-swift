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

  var body: some View {
    Map(
      coordinateRegion: $sutroRegion, showsUserLocation: true,
      annotationItems: regions
    ) {
      region in
      MapAnnotation(coordinate: region.locationCoordinate, anchorPoint: CGPoint(x: 0, y: 1)) {
        ZStack(alignment: .center) {
          Circle().fill(AppColors.fg)
          Circle().stroke(lineWidth: 1).size(width: 10, height: 10)
          if region == selectedRegion {
            region.image.resizable().aspectRatio(contentMode: .fill).clipped().frame(width: 40, height: 20).offset(y: -40)
          }
        }.frame(width: 10, height: 10).onTapGesture {
          selectedRegion = region
          print("region is \(selectedRegion)")
        }
      }
    }
  }
}

struct RegionsMap_Previews: PreviewProvider {
  static var regionsData: RegionData = RegionData()

  static var previews: some View {
    RegionsMap(regions: regionsData.regions)
  }
}
