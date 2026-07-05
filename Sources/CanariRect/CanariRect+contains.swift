//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 20/12/2025.
//--------------------------------------------------------------------------------------------------

import Foundation

//--------------------------------------------------------------------------------------------------
//  struct CanariRect
//--------------------------------------------------------------------------------------------------

public extension CanariRect {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

   func contains (_ inPoint : CanariPoint) -> Bool {
    var result = inPoint.x >= self.minX
    if result {
      result = inPoint.x <= self.maxX
    }
    if result {
      result = inPoint.y >= self.minY
    }
    if result {
      result = inPoint.y <= self.maxY
    }
    return result
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func contains (_ inRect : CanariRect) -> Bool {
    let contains = (self.minX <= inRect.minX)
      && (self.maxX >= inRect.maxX)
      && (self.minY <= inRect.minY)
      && (self.maxY >= inRect.maxY)
    return contains
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
