//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 05/07/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public extension CanariPath {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  mutating func unionInPlaceUsingNonZeroRule (_ inPath : CanariPath) {
    var path : Path = self.mPath
    path = path.union (inPath.mPath, eoFill: false)
    self = CanariPath (swiftuiPath: path)
  }


  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  mutating func unionInPlaceUsingEvenOddRule (_ inPath : CanariPath) {
    var path : Path = self.mPath
    path = path.union (inPath.mPath, eoFill: true)
    self = CanariPath (swiftuiPath: path)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func unioningUsingNonZeroRule (_ inPath : CanariPath) -> CanariPath {
    var path : Path = self.mPath
    path = path.union (inPath.mPath, eoFill: false)
    return CanariPath (swiftuiPath: path)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  mutating func unioningUsingEvenOddRule (_ inPath : CanariPath) -> CanariPath {
    var path : Path = self.mPath
    path = path.union (inPath.mPath, eoFill: true)
    return CanariPath (swiftuiPath: path)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------


