//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 21/02/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

extension CanariBaseShape : Equatable {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public static func == (_ inLeft  : CanariBaseShape <ShapeTypesDescription>,
                         _ inRight : CanariBaseShape <ShapeTypesDescription>) -> Bool {
    (inLeft.orientedOrigin == inRight.orientedOrigin) && inLeft.shape.isEqual (to: inRight.shape)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
