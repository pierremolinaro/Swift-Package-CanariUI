//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 21/02/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

extension CanariShapeRoot : Equatable {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public static func == (_ inLeft  : CanariShapeRoot <ANCHOR, DOCUMENT_SHAPES_DISPLAY_SETTINGS, SHAPE_TYPES_DESCRIPTION>,
                         _ inRight : CanariShapeRoot <ANCHOR, DOCUMENT_SHAPES_DISPLAY_SETTINGS, SHAPE_TYPES_DESCRIPTION>) -> Bool {
    (inLeft.mAnchor == inRight.mAnchor) && inLeft.mDecoration.isEqual (to: inRight.mDecoration)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
