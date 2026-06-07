//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 18/09/2025.
//--------------------------------------------------------------------------------------------------

import Foundation

//--------------------------------------------------------------------------------------------------

extension Array where Element == CanariPoint {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  var pxValues : [CGPoint] {
    var result = [CGPoint] ()
    for p in self {
      result.append (p.pxValue)
    }
    return result
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func aligning (_ inUnit : CanariLength) -> [CanariPoint] {
    var result = [CanariPoint] ()
    for p in self {
      result.append (p.aligning (to: inUnit))
    }
    return result
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func areAligned (_ inUnit : CanariLength) -> Bool {
    for p in self {
      if !p.isAligned (inUnit) {
        return false
      }
    }
    return true
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
