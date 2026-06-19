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
                       userSelectionRectangle ioUserSelectionRectangle : inout CanariRect?,
                       widgetsManagerInterface inWidgetsManagerInterface : WidgetsUserInterface <WidgetTypesDescription>,
                       optionalNextState outOptionalNextState : inout (any MouseGestureProtocol<WidgetTypesDescription>)?) {
    let translation = inWidgetsManagerInterface.validatedGlobalTranslation (
      proposedValue: inGeometry.alignedUserCurrentLocation - self.alignedCurrentPoint,
      canvasSize: inGeometry.canvasSize
    )
    if translation != .zero {
      inBeginOrContinueUndoGrouping ()
      for i in 0 ..< inWidgetsManagerInterface.widgetCount {
        if inWidgetsManagerInterface.selection.contains (inWidgetsManagerInterface [widgetIndex: i].shape.id) {
          inWidgetsManagerInterface [widgetIndex: i].shape.orientedOrigin.mOrigin += translation
        }
      }
      outOptionalNextState = MouseGesture_DragSelection (
        alignedCurrentPoint: inGeometry.alignedUserCurrentLocation
      )
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func onMouseUp (removeUndoGrouping inRemoveUndoGrouping : () -> Void,
                  userSelectionRectangle ioUserSelectionRectangle : inout CanariRect?,
                  widgetsManagerInterface inWidgetsManagerInterface : WidgetsUserInterface <WidgetTypesDescription>) {
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
