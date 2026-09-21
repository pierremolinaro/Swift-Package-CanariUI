//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 04/07/2026.
//--------------------------------------------------------------------------------------------------

import AppKit

//--------------------------------------------------------------------------------------------------

public extension CanariPath {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  mutating func subtractInPlace (_ inPath : CanariPath, using inRule : Self.Rule) {
    let r = self.mPath.cgPath.subtracting (inPath.mPath.cgPath, using: .winding)
    self = CanariPath (cgPath: r)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func subtracting (_ inPath : CanariPath, using inRule : Self.Rule) -> CanariPath {
    let r = self.mPath.cgPath.subtracting (inPath.mPath.cgPath, using: inRule.cgRule)
    return CanariPath (cgPath: r)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------

