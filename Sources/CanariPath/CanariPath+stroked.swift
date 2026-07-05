//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 02/06/2026.
//--------------------------------------------------------------------------------------------------

import AppKit

//--------------------------------------------------------------------------------------------------

public extension CanariPath {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func stroked (with inLineWidth : CanariLength) -> CanariPath {
    let style = CanariStrokeStyle (lineWidth: inLineWidth)
    var result = CanariPath ()
    result.mPath = self.mPath.strokedPath (style.swiftui)
    return result
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func stroked (with inStyle : CanariStrokeStyle) -> CanariPath {
    var result = CanariPath ()
    result.mPath = self.mPath.strokedPath (inStyle.swiftui)
    return result
  }


  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
