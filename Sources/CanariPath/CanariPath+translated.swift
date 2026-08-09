//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 02/06/2026.
//--------------------------------------------------------------------------------------------------

import AppKit

//--------------------------------------------------------------------------------------------------

public extension CanariPath {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func translated (by inPoint : CanariPoint) -> CanariPath {
    return self.translated (xBy: inPoint.x, yBy: inPoint.y)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func translated (xBy inX : CanariLength = .zero,
                   yBy inY : CanariLength = .zero) -> CanariPath {
    let dx = inX.pxValue
    let dy = inY.pxValue
    var path = CanariPath ()
    self.mPath.forEach {
      switch $0 {
      case .closeSubpath :
        path.addClosePath ()
      case .move (to: let p) :
        path.addMove (toX: p.x + dx, toY: p.y + dy)
      case .line (to: let p) :
        path.addLine (to: CGPoint (x: p.x + dx, y: p.y + dy))
      case .curve (to: let p, control1: let ctrl1, control2: let ctrl2) :
        path.addCubicCurve (
          to: CGPoint (x: p.x + dx, y: p.y + dy),
          control1: CGPoint (x: ctrl1.x + dx, y: ctrl1.y + dy),
          control2: CGPoint (x: ctrl2.x + dx, y: ctrl2.y + dy)
        )
      case .quadCurve (to: let p, control: let ctrl) :
         path.addQuadCurve (
          to: CGPoint (x: p.x + dx, y: p.y + dy),
          control: CGPoint (x: ctrl.x + dx, y: ctrl.y + dy)
        )
      }
    }
    return path
  }


  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
