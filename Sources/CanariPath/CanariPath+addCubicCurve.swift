//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 02/06/2026.
//--------------------------------------------------------------------------------------------------

import AppKit

//--------------------------------------------------------------------------------------------------

public extension CanariPath {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  mutating func addCubicCurve (to inPoint : CanariPoint,
                               control1 inCtrl1 : CanariPoint,
                               control2 inCtrl2 : CanariPoint) {
    self.mPath.addCurve (to: inPoint.ptValue, control1: inCtrl1.ptValue, control2: inCtrl2.ptValue)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  mutating func addCubicCurve (to inPoint : CGPoint,
                               control1 inCtrl1 : CGPoint,
                               control2 inCtrl2 : CGPoint) {
    self.mPath.addCurve (to: inPoint, control1: inCtrl1, control2: inCtrl2)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
