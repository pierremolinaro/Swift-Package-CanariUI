//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 05/07/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI
import CanariGeometry

//--------------------------------------------------------------------------------------------------

public extension CanariPath {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  mutating func unionInPlace (_ inPath : CanariPath, using inRule : Self.Rule) {
//    var path : Path = self.mPath
//    path = path.union (inPath.mPath, eoFill: inRule.uiEvenOddFill)
//    self = CanariPath (swiftuiPath: path)
    self = self.unioning (inPath, using: inRule)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func unioning (_ inPath : CanariPath, using inRule : Self.Rule) -> CanariPath {
//    var path : Path = self.mPath
//    path = path.union (inPath.mPath, eoFill: inRule.uiEvenOddFill)
//    return CanariPath (swiftuiPath: path)
    let r = self.cgPath.union (inPath.cgPath, using: inRule.cgRule)
    return CanariPath (cgPath: r)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
