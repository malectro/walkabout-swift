//
//  LocationPermissionView.swift
//  WalkaboutSwift
//
//  Created by Kyle Warren on 6/7/21.
//

import SwiftUI

struct LocationPermissionView: View {
  var action: () -> Void
  
  var body: some View {
    VStack(spacing: 20) {
      Text("Walkabout is a location based experience, meaning that it will only work if it has access to your GPS. Your location will never be sent to a third party.")
      Button("Grant location access", action: action).font(.system(size: 24.0))
    }.background(AppColors.bg).foregroundColor(AppColors.fg)
  }
}

struct LocationPermissionView_Previews: PreviewProvider {
    static var previews: some View {
      LocationPermissionView(action: {})
    }
}
