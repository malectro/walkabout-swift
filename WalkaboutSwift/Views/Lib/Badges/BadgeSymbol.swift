//
//  BadgeSymbol.swift
//  WalkaboutSwift
//
//  Created by Kyle Warren on 5/28/21.
//

import SwiftUI

struct BadgeSymbol: View {
  static let symbolColor = make255Color(red: 79.0, green: 79.0, blue: 191.0)
  
  var body: some View {
    GeometryReader { geometry in
      Path { path in
        let width = min(geometry.size.width, geometry.size.height)
        let height = width * 0.75

        let spacing = width * 0.030
        let middle = width * 0.5

        let topWidth = width * 0.226
        let topHeight = height * 0.488

        let yCornerStone = topHeight / 2 + spacing

        
        path.addLines([
          CGPoint(x: middle, y: spacing),
          CGPoint(x: middle - topWidth, y: topHeight - spacing),
          CGPoint(x: middle, y: yCornerStone),
          CGPoint(x: middle + topWidth, y: topHeight - spacing),
          CGPoint(x: middle, y: spacing),
        ])

        path.move(to: CGPoint(x: middle, y: yCornerStone + spacing * 2))

        path.addLines([
          CGPoint(x: middle - topWidth - spacing, y: topHeight + spacing),
          CGPoint(x: spacing, y: height - spacing),
          CGPoint(x: width - spacing, y: height - spacing),
          CGPoint(x: middle + topWidth + spacing, y: topHeight + spacing),
          CGPoint(x: middle, y: yCornerStone + spacing * 2)
        ])
      }.fill(Self.symbolColor)
    }
  }
}

struct BadgeSymbol_Previews: PreviewProvider {
  static var previews: some View {
    BadgeSymbol()
  }
}
