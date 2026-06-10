//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 15/09/2025.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

struct MouseGesture_Creation <TypeDictionary : WidgetTypeArrayProtocol> : MouseGestureProtocol {

  let objectCreator : (MouseGestureGeometryContext) -> any WidgetUIProtocol <TypeDictionary>

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func onMouseDragged (geometry inGeometry : MouseGestureGeometryContext,
                       beginOrContinueUndoGrouping inBeginOrContinueUndoGrouping : () -> Void,
                       selection ioSelection : inout Set <UUID>,
                       userSelectionRectangle ioUserSelectionRectangle : inout CanariRect?,
                       widgetsManager ioWidgetsManager : inout WidgetsManager<TypeDictionary>,
                       optionalNextState outOptionalNextState : inout (any MouseGestureProtocol<TypeDictionary>)?) {
    let newObject = self.objectCreator (inGeometry)
    ioWidgetsManager [widget: ioWidgetsManager.count - 1] = newObject
    ioSelection = [newObject.id]
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func onMouseUp (removeUndoGrouping inRemoveUndoGrouping : () -> Void,
                  selection ioSelection : inout Set <UUID>,
                  userSelectionRectangle ioUserSelectionRectangle : inout CanariRect?,
                  widgetsManager ioWidgetsManager : inout WidgetsManager<TypeDictionary>) {
    if ioWidgetsManager [widget: ioWidgetsManager.count - 1].isGraphicallyEmpty {
      ioWidgetsManager.removeLast ()
      ioSelection.removeAll ()
      inRemoveUndoGrouping ()
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
