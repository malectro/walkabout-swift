//
//  RegionDetail.swift
//  WalkaboutSwift
//
//  Created by Kyle Warren on 6/8/21.
//

import SwiftUI

struct RegionDetail: View {
  var region: WalkaboutRegion

  @Environment(\.managedObjectContext) private var viewContext

  private var fetchRequest: FetchRequest<UserRegion>

  init(region: WalkaboutRegion) {
    self.region = region
    fetchRequest = FetchRequest(
      entity: UserRegion.entity(),
      sortDescriptors: [],
      predicate: NSPredicate(
        format: "regionId = %@",
        region.id
      )
    )
  }

//  @FetchRequest(predicate: NSPredicate(format: "regionId = %@", arguments: [region.id]))

  var body: some View {
    let userRegion = fetchRequest.wrappedValue.first

    GeometryReader { _ in
      ScrollView {
        VStack(alignment: .leading, spacing: Spacing.medium) {
          Text(region.name).font(.title)
          region.image.resizable().aspectRatio(contentMode: .fit)
          if userRegion?.isUnlocked ?? false {
            HStack {
              Text("Decrypted")
              Spacer()
              Button("Lock", action: toggle)
            }
          } else {
            HStack {
              Text("Encrypted")
              Spacer()
              Button("Unlock", action: toggle)
            }
          }
          Spacer()
        }.foregroundColor(AppColors.fg).padding(Spacing.large)
      }
    }.navigationBarTitleDisplayMode(.inline)
      .background(AppColors.bg.ignoresSafeArea())
  }

  func toggle() {
    let dbUserRegion = fetchRequest.wrappedValue.first
    var userRegion: UserRegion
    if let unwrappedUserRegion = dbUserRegion {
      userRegion = unwrappedUserRegion
    } else {
      userRegion = UserRegion(context: viewContext)
      userRegion.regionId = region.id
    }
    userRegion.isUnlocked = !userRegion.isUnlocked
    print("isUnlocked \(userRegion.isUnlocked)")

    do {
      try viewContext.save()
    } catch {
      let nsError = error as NSError
      fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
    }
  }
}

struct RegionDetail_Previews: PreviewProvider {
  static var regionData = RegionData()

  static var previews: some View {
    RegionDetail(region: regionData.regions[0])
  }
}
