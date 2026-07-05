//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 20/12/2025.
//--------------------------------------------------------------------------------------------------

import Foundation

//--------------------------------------------------------------------------------------------------
//  struct CanariRect
//--------------------------------------------------------------------------------------------------

public extension CanariRect {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func scaled (by inScale : CGFloat) -> CanariRect {
    return CanariRect (
      origin: CanariPoint (x: self.origin.x * inScale, y: self.origin.y * inScale),
      size: CanariSize (width: self.size.width * inScale, height: self.size.height * inScale)
    )
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func moved (x inX : CanariLength, y inY : CanariLength) -> CanariRect {
    CanariRect (
      left: self.origin.x + inX,
      bottom: self.origin.y + inY,
      width: self.width,
      height: self.height
    )
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func moved (by inPoint : CanariPoint) -> CanariRect {
    CanariRect (
      left: self.origin.x + inPoint.x,
      bottom: self.origin.y + inPoint.y,
      width: self.width,
      height: self.height
    )
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
