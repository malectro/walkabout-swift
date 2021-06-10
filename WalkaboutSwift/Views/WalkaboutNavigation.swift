//
//  WalkaboutNavigation.swift
//  WalkaboutSwift
//
//  Created by Kyle Warren on 6/7/21.
//

import SwiftUI

struct WalkaboutNavigation: View {
  enum Page {
    case list
    case map
  }

  @State private var page: Page = .list
  @State private var selectedRegion: String?
  @StateObject private var regionData: RegionData = RegionData()

  var body: some View {
    NavigationView {
    VStack {
      GeometryReader { geometryProxy in
        let width = geometryProxy.size.width
        VStack(alignment: .leading) {
          HStack(spacing: Spacing.large) {
            NavButton(page: $page, name: .list, label: "List")
            NavButton(page: $page, name: .map, label: "Map")
          }.font(.system(size: 24, weight: .bold)).padding(
            .horizontal, Spacing.large
          )
          HStack {
            HStack {
              NotesList(
                regions: regionData.regions,
                selectedRegion: $selectedRegion
              )
            }.frame(width: max(width - Spacing.large * 2, 0)).padding(
              .horizontal, Spacing.large
            )
            /*
              RegionsMap(regions: regionData.regions, onSelect: {region in
                selectedRegion = region.id
              }).frame(width: width)
             */
          }.offset(x: page == .list ? 0 : -width).animation(.easeInOut)
        }
      }
    }.background(AppColors.bg.ignoresSafeArea()).foregroundColor(AppColors.fg)
        .navigationBarHidden(true)
    }
  }

  struct NavButton: View {
    @Binding var page: Page
    var name: Page
    var label: String

    var body: some View {
      Button(label, action: { page = name }).foregroundColor(
        page == name ? AppColors.fg : .gray
      )
    }
  }
}

struct WalkaboutNavigation_Previews: PreviewProvider {
  static var previews: some View {
    WalkaboutNavigation()
  }
}
