//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 05/07/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public extension CanariPath {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  mutating func unionInPlaceUsingNonZeroRule (_ inPath : CanariPath) {
    var path : Path = self.swiftuiPath
    path = path.union (inPath.swiftuiPath, eoFill: false)
    self = CanariPath (swiftuiPath: path)
  }


  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  mutating func unionInPlaceUsingEvenOddRule (_ inPath : CanariPath) {
    var path : Path = self.swiftuiPath
    path = path.union (inPath.swiftuiPath, eoFill: true)
    self = CanariPath (swiftuiPath: path)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func unioningUsingNonZeroRule (_ inPath : CanariPath) -> CanariPath {
    var path : Path = self.swiftuiPath
    path = path.union (inPath.swiftuiPath, eoFill: false)
    return CanariPath (swiftuiPath: path)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  mutating func unioningUsingEvenOddRule (_ inPath : CanariPath) -> CanariPath {
    var path : Path = self.swiftuiPath
    path = path.union (inPath.swiftuiPath, eoFill: true)
    return CanariPath (swiftuiPath: path)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------


