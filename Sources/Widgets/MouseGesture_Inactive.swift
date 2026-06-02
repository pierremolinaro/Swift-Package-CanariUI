//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 15/09/2025.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

struct MouseGesture_Inactive <TypeDictionary : WidgetTypeArrayProtocol> : MouseGestureProtocol {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func onMouseDragged (geometry inGeometry : MouseGestureGeometryContext,
                       beginOrContinueUndoGrouping inBeginOrContinueUndoGrouping : () -> Void,
                       selection ioSelection : inout Set <UUID>,
                       userSelectionRectangle ioUserSelectionRectangle : inout CanariRect?,
                       widgetsManager ioWidgetsManager : inout WidgetsManager <TypeDictionary>,
                       optionalNextState outOptionalNextState : inout (any MouseGestureProtocol<TypeDictionary>)?) {
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func onMouseUp (removeUndoGrouping inRemoveUndoGrouping : () -> Void,
                  selection ioSelection : inout Set <UUID>,
                  userSelectionRectangle ioUserSelectionRectangle : inout CanariRect?,
                  widgetsManager ioWidgetsManager : inout WidgetsManager <TypeDictionary>) {
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
