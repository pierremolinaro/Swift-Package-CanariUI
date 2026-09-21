//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 04/07/2026.
//--------------------------------------------------------------------------------------------------

import AppKit

//--------------------------------------------------------------------------------------------------

extension CanariPath {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func separatedComponents (using inRule : Self.Rule) -> [CanariPath] {
    let components = self.mPath.cgPath.componentsSeparated (using: inRule.cgRule)
    var result = [CanariPath] ()
    for p in components {
      result.append (CanariPath (cgPath: p))
    }
    return result
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
