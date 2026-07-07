//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 20/09/2024.
//--------------------------------------------------------------------------------------------------

import Foundation

//--------------------------------------------------------------------------------------------------

extension CanariAffinity : CustomStringConvertible {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var description : String {
    var s = "m11: \(self.mAffineTransform.m11), m12: \(self.mAffineTransform.m12)"
    s += " m21: \(self.mAffineTransform.m21), m22: \(self.mAffineTransform.m22)"
    s += " tX: \(self.mAffineTransform.tX), tY: \(self.mAffineTransform.tY)"
    return s
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
