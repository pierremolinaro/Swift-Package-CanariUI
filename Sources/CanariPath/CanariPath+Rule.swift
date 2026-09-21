//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 21/09/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public extension CanariPath {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  enum Rule {
    case evenOddRule
    case nonZeroRule

    var uiEvenOddFill : Bool {
      switch self {
      case .evenOddRule : true
      case .nonZeroRule : false
      }
    }

    var cgRule : CGPathFillRule {
      switch self {
      case .evenOddRule : .evenOdd
      case .nonZeroRule : .winding
      }
    }

  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
