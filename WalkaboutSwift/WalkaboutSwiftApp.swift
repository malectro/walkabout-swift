//
//  WalkaboutSwiftApp.swift
//  WalkaboutSwift
//
//  Created by Kyle Warren on 5/27/21.
//

import SwiftUI

@main
struct WalkaboutSwiftApp: App {
    var body: some Scene {
        WindowGroup {
          ContentView().onAppear {
            print("content view appear")
          }.onDisappear {
            print("content view disappear")
          }
        }
    }
}
