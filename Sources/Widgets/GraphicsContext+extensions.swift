//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 31/03/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public extension GraphicsContext {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  mutating func translateBy (x inX : CanariLength, y inY : CanariLength) {
    self.translateBy (x: inX.pxValue, y: inY.pxValue)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  mutating func translate (by inPoint : CanariPoint) {
    self.translateBy (x: inPoint.x, y: inPoint.y)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  mutating func rotate (by inAngle : CanariAngle) {
    self.rotate (by: Angle.radians (inAngle.radians))
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  mutating func scale (by inScale : Double) {
    self.scaleBy (x: inScale, y: inScale)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
