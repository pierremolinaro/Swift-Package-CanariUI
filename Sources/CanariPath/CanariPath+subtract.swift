//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 04/07/2026.
//--------------------------------------------------------------------------------------------------

import AppKit

//--------------------------------------------------------------------------------------------------

extension CanariPath {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func subtractingUsingNonZeroRule (_ inPath : CanariPath) -> CanariPath {
    let r = self.swiftuiPath.cgPath.subtracting (inPath.swiftuiPath.cgPath, using: .winding)
    return CanariPath (cgPath: r)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func subtractingUsingEvenOddRule (_ inPath : CanariPath) -> CanariPath {
    let r = self.swiftuiPath.cgPath.subtracting (inPath.swiftuiPath.cgPath, using: .evenOdd)
    return CanariPath (cgPath: r)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------

