//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 14/03/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

struct MouseGesture_DragKnob <WidgetTypesDescription : DocumentWidgetsDescriptionProtocol> : MouseGestureProtocol {

  let alignedCurrentPoint : CanariPoint
  let optionKeyInitiallyOn : Bool
  let widgetID : UUID
  let dragWidgetKnobAction : (inout any WidgetUIProtocol <WidgetTypesDescription>, CanariPoint, Bool) -> Void

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func onMouseDragged (geometry inGeometry : MouseGestureGeometryContext,
                       beginOrContinueUndoGrouping inBeginOrContinueUndoGrouping : () -> Void,
                       selection ioSelection : inout Set <UUID>,
                       userSelectionRectangle ioUserSelectionRectangle : inout CanariRect?,
                       widgetsManagerInterface inWidgetsManagerInterface : WidgetsUserInterface <WidgetTypesDescription>,
                       optionalNextState outOptionalNextState : inout (any MouseGestureProtocol<WidgetTypesDescription>)?) {
    let translation = inGeometry.alignedUserCurrentLocation - self.alignedCurrentPoint
    if translation != .zero {
      inBeginOrContinueUndoGrouping ()
      if var widget = inWidgetsManagerInterface [id: widgetID] {
        let localTranslation = CanariAffinity (scale: 1.0 / widget.orientedOrigin.mScale)
          .rotating (-widget.orientedOrigin.mAngle)
          .transforming (translation)
        self.dragWidgetKnobAction (&widget, localTranslation, self.optionKeyInitiallyOn)
        inWidgetsManagerInterface [id: widgetID] = widget
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
                  selection ioSelection : inout Set <UUID>,
                  userSelectionRectangle ioUserSelectionRectangle : inout CanariRect?,
                  widgetsManagerInterface inWidgetsManagerInterface : WidgetsUserInterface <WidgetTypesDescription>) {
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------

