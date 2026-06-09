//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 15/09/2025.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

struct MouseGesture_DragSelection <TypeDictionary : WidgetTypeArrayProtocol> : MouseGestureProtocol {

  let alignedCurrentPoint : CanariPoint

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func onMouseDragged (geometry inGeometry : MouseGestureGeometryContext,
                       beginOrContinueUndoGrouping inBeginOrContinueUndoGrouping : () -> Void,
                       selection ioSelection : inout Set <UUID>,
                       userSelectionRectangle ioUserSelectionRectangle : inout CanariRect?,
                       widgetsManager ioWidgetsManager : inout WidgetsManager <TypeDictionary>,
                       optionalNextState outOptionalNextState : inout (any MouseGestureProtocol<TypeDictionary>)?) {
    var translation = inGeometry.alignedUserCurrentLocation - self.alignedCurrentPoint
    for i in 0 ..< ioWidgetsManager.count {
      if ioSelection.contains (ioWidgetsManager [widget: i].id) {
        ioWidgetsManager [widget: i].limitTranslation (&translation, inGeometry.canvasSize)
      }
    }
    if translation != .zero {
      inBeginOrContinueUndoGrouping ()
      for i in 0 ..< ioWidgetsManager.count {
        if ioSelection.contains (ioWidgetsManager [widget: i].id) {
          ioWidgetsManager [widget: i].translate (by: translation)
        }
      }
      outOptionalNextState = MouseGesture_DragSelection (
        alignedCurrentPoint: inGeometry.alignedUserCurrentLocation
      )
    }
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
