//
//  WalkaboutSwiftApp.swift
//  WalkaboutSwift
//
//  Created by Kyle Warren on 5/27/21.
//

import SwiftUI

@main
struct WalkaboutSwiftApp: App {
  let persistenceController = PersistenceController.shared
  
    var body: some Scene {
        WindowGroup {
          ContentView().environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
