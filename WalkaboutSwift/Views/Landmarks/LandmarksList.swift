//
//  LandmarksList.swift
//  WalkaboutSwift
//
//  Created by Kyle Warren on 5/27/21.
//

import SwiftUI

struct LandmarksList: View {
  @EnvironmentObject var modelData: ModelData
  @State private var showFavoritesOnly = false
  
  var filteredLandmarks: [Landmark] {
    modelData.landmarks.filter { landmark in
      (!showFavoritesOnly || landmark.isFavorite)
    }
  }
  
  var body: some View {
    NavigationView {
      List {
        Toggle(isOn: $showFavoritesOnly) {
          Text("Favorites only")
        }
        ForEach(filteredLandmarks) { landmark in
          NavigationLink(
            destination: LandmarkDetail(landmark: landmark)
          ){
            LandmarkRow(landmark: landmark)
          }
        }.navigationTitle("Landmarks")
      }
    }
  }
}

struct LandmarksList_Previews: PreviewProvider {
    static var previews: some View {
        LandmarksList()
          .environmentObject(ModelData())
    }
}
