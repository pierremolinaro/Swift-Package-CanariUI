//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 21/02/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

extension CanariShapeRoot : Equatable {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public static func == (_ inLeft  : CanariShapeRoot <SHAPE_TYPES_DESCRIPTION>,
                         _ inRight : CanariShapeRoot <SHAPE_TYPES_DESCRIPTION>) -> Bool {
    (inLeft.mOrigin == inRight.mOrigin) && inLeft.mDecoration.isEqual (to: inRight.mDecoration)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
