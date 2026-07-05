//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 02/06/2026.
//--------------------------------------------------------------------------------------------------

import AppKit

//--------------------------------------------------------------------------------------------------

public extension CanariPath {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  mutating func addQuadCurve (to inPoint : CanariPoint,
                              control inCtrl : CanariPoint) {
    self.mPath.addQuadCurve (to: inPoint.pxValue, control: inCtrl.pxValue)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  mutating func addQuadCurve (to inPoint : CGPoint,
                              control inCtrl : CGPoint) {
    self.mPath.addQuadCurve (to: inPoint, control: inCtrl)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
