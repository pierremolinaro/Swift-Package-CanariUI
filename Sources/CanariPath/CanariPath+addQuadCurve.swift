//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 02/06/2026.
//--------------------------------------------------------------------------------------------------

import AppKit

//--------------------------------------------------------------------------------------------------

public extension CanariPath {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  mutating func addQuadCurve (to inPoint : CanariPoint,
                              control inCtrl : CanariPoint) {
    self.mPath.addQuadCurve (to: inPoint.ptValue, control: inCtrl.ptValue)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  mutating func addQuadCurve (to inPoint : CGPoint,
                              control inCtrl : CGPoint) {
    self.mPath.addQuadCurve (to: inPoint, control: inCtrl)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
