//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 02/06/2026.
//--------------------------------------------------------------------------------------------------

import AppKit

//--------------------------------------------------------------------------------------------------

public extension CanariPath {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  mutating func addArrow (to inPoint : CanariPoint, arrowhead inLength : CanariLength) {
    if let startPoint = self.currentCanariPoint, inPoint != startPoint {
      let angle = startPoint.angle (to: inPoint)
      self.addLine (to: inPoint)
      let p1 = inPoint + CanariPoint (length: inLength, angle: angle + .degrees (135))
      self.addLine (to: p1)
      let p2 = inPoint + CanariPoint (length: inLength, angle: angle - .degrees (135))
      self.addMove (to: p2)
      self.addLine (to: inPoint)
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
