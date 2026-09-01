//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 29/03/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public extension GeometryProxy {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  var availableWidth : CanariLength {
    return .pt (self.size.width - self.containerCornerInsets.bottomTrailing.width)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  var availableHeight : CanariLength {
    return .pt (self.size.height - self.containerCornerInsets.bottomTrailing.height)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
