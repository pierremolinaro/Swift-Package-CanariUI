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
                       widgetsManagerInterface inWidgetsManagerInterface : WidgetsUserInterface <WidgetTypesDescription>,
                       optionalNextState outOptionalNextState : inout (any MouseGestureProtocol<WidgetTypesDescription>)?) {
    let translation = inWidgetsManagerInterface.validatedTranslation (
      proposedValue: inGeometry.alignedUserCurrentLocation - self.alignedCurrentPoint,
      canvasSize: inGeometry.canvasSize
    )
    if translation != .zero {
      inBeginOrContinueUndoGrouping ()
      for i in 0 ..< inWidgetsManagerInterface.count {
        if ioSelection.contains (inWidgetsManagerInterface [widgetIndex: i].id) {
          inWidgetsManagerInterface [widgetIndex: i].translate (by: translation)
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
                  widgetsManagerInterface inWidgetsManagerInterface : WidgetsUserInterface <WidgetTypesDescription>) {
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
