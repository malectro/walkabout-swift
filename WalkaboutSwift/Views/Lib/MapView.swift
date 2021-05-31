//
//  MapView.swift
//  WalkaboutSwift
//
//  Created by Kyle Warren on 5/27/21.
//

import MapKit
import SwiftUI

struct MapView: View {
  var coordinate: CLLocationCoordinate2D

  @State private var region = MKCoordinateRegion()

  var body: some View {
    Map(coordinateRegion: $region, showsUserLocation: true).onAppear {
      setRegion(coordinate)
    }
  }

  private func setRegion(_ coordinate: CLLocationCoordinate2D) {
    region = MKCoordinateRegion(
      center: coordinate,
      span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
    )
  }
}

struct MapView_Previews: PreviewProvider {
  static var previews: some View {
    MapView(
      coordinate: CLLocationCoordinate2D(
        latitude: 34.0, longitude: -122.0
      ))
  }
}
