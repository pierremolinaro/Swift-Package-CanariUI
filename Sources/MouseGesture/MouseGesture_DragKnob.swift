//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 14/03/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

struct MouseGesture_DragKnob <WidgetTypesDescription : DocumentWidgetsDescriptionProtocol> : MouseGestureProtocol {

  let alignedCurrentPoint : CanariPoint
  let optionKeyInitiallyOn : Bool
  let widgetID : UUID
  let dragWidgetKnobAction : (inout any CanariShapeUIProtocol <WidgetTypesDescription>, CanariPoint, Bool) -> Void

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func onMouseDragged (geometry inGeometry : MouseGestureGeometryContext,
                       beginOrContinueUndoGrouping inBeginOrContinueUndoGrouping : () -> Void,
                       userSelectionRectangle ioUserSelectionRectangle : inout CanariRect?,
                       widgetsManagerInterface inWidgetsManagerInterface : WidgetsUserInterface <WidgetTypesDescription>,
                       optionalNextState outOptionalNextState : inout (any MouseGestureProtocol<WidgetTypesDescription>)?) {
    let translation = inGeometry.alignedUserCurrentLocation - self.alignedCurrentPoint
    if translation != .zero {
      inBeginOrContinueUndoGrouping ()
      if var widget = inWidgetsManagerInterface [shapeID: widgetID] {
        let validatedGlobalTranslation = inWidgetsManagerInterface.validatedGlobalTranslation (
          proposedValue: translation,
          canvasSize: inGeometry.canvasSize
        )
        let localTranslation = CanariAffinity (scale: 1.0 / widget.shape.orientedOrigin.mScale)
          .rotating (-widget.shape.orientedOrigin.mAngle)
          .transforming (validatedGlobalTranslation)
        self.dragWidgetKnobAction (&widget.shape, localTranslation, self.optionKeyInitiallyOn)
        inWidgetsManagerInterface [shapeID: widgetID] = widget
      }
      outOptionalNextState = MouseGesture_DragKnob (
        alignedCurrentPoint: inGeometry.alignedUserCurrentLocation,
        optionKeyInitiallyOn: self.optionKeyInitiallyOn,
        widgetID: self.widgetID,
        dragWidgetKnobAction: self.dragWidgetKnobAction
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

