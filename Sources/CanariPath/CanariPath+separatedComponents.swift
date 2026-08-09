//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 04/07/2026.
//--------------------------------------------------------------------------------------------------

import AppKit

//--------------------------------------------------------------------------------------------------

extension CanariPath {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func separatedComponentsUsingNonZeroRule () -> [CanariPath] {
    let components = self.mPath.cgPath.componentsSeparated (using: .winding)
    var result = [CanariPath] ()
    for p in components {
      result.append (CanariPath (cgPath: p))
    }
    return result
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func separatedComponentsUsingEvenOddRule () -> [CanariPath] {
    let components = self.mPath.cgPath.componentsSeparated (using: .evenOdd)
    var result = [CanariPath] ()
    for p in components {
      result.append (CanariPath (cgPath: p))
    }
    return result
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
