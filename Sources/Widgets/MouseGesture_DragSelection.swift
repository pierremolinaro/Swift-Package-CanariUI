//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 15/09/2025.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

struct MouseGesture_DragSelection <WidgetTypesDescription : DocumentWidgetsDescriptionProtocol> : MouseGestureProtocol {

  let alignedCurrentPoint : CanariPoint

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func onMouseDragged (geometry inGeometry : MouseGestureGeometryContext,
                       beginOrContinueUndoGrouping inBeginOrContinueUndoGrouping : () -> Void,
                       selection ioSelection : inout Set <UUID>,
                       userSelectionRectangle ioUserSelectionRectangle : inout CanariRect?,
                       widgetsManager ioWidgetsManager : inout WidgetsManager <WidgetTypesDescription>,
                       optionalNextState outOptionalNextState : inout (any MouseGestureProtocol<WidgetTypesDescription>)?) {
    var translation = inGeometry.alignedUserCurrentLocation - self.alignedCurrentPoint
    var unselectedWidgetOutlines = [CanariPath] ()
    for i in 0 ..< ioWidgetsManager.count {
      if !ioSelection.contains (ioWidgetsManager [widget: i].id) {
        unselectedWidgetOutlines.append (ioWidgetsManager [widget: i].orientedOrigin.globalOutline)
      }
    }
    for i in 0 ..< ioWidgetsManager.count {
      if ioSelection.contains (ioWidgetsManager [widget: i].id) {
        ioWidgetsManager [widget: i].orientedOrigin.limitTranslationWithinCanvas (&translation, inGeometry.canvasSize, unselectedWidgetOutlines)
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
                  widgetsManager ioWidgetsManager : inout WidgetsManager <WidgetTypesDescription>) {
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
