//
//  BadgeBackground.swift
//  WalkaboutSwift
//
//  Created by Kyle Warren on 5/28/21.
//

import SwiftUI

struct BadgeBackground: View {
  var body: some View {
    GeometryReader { geometry in
      Path { path in
        var width: CGFloat = min(
          geometry.size.width, geometry.size.height
        )
        let height = width

        let xScale: CGFloat = 0.832
        let xOffset = (width * (1.0 - xScale)) / 2.0

        width *= xScale

        path.move(
          to: CGPoint(
            x: width * 0.95 + xOffset,
            y: height * (0.20 + HexagonParameters.adjustment)
          )
        )

        HexagonParameters.segments.forEach { segment in
          path.addLine(
            to: CGPoint(
              x: width * segment.line.x + xOffset,
              y: height * segment.line.y
            )
          )

          path.addQuadCurve(
            to: CGPoint(
              x: width * segment.curve.x + xOffset,
              y: height * segment.curve.y
            ),
            control: CGPoint(
              x: width * segment.control.x + xOffset,
              y: height * segment.control.y
            )
          )
        }
      }.fill(
        LinearGradient(
          gradient: Gradient(
            colors: [Self.gradientStart, Self.gradientEnd]
          ),
          startPoint: UnitPoint(x: 0.5, y: 0),
          endPoint: UnitPoint(x: 0.5, y: 0.6)
        )
      )
    }
  }
  
  static let gradientStart = make255Color(
    red: 239.0, green: 120.0, blue: 221.0
  )
  static let gradientEnd = make255Color(
    red: 239.0, green: 172.0, blue: 120.0
  )
}

func make255Color(red: Double, green: Double, blue: Double) -> Color {
  Color(
    red: red / 255.0,
    green: green / 255.0,
    blue: blue / 255.0
  )
}

struct BadgeBackground_Previews: PreviewProvider {
  static var previews: some View {
    BadgeBackground()
  }
}
