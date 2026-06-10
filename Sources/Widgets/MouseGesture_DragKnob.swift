//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 14/03/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

struct MouseGesture_DragKnob <TypeDictionary : WidgetTypeArrayProtocol> : MouseGestureProtocol {

  let alignedCurrentPoint : CanariPoint
  let optionKeyInitiallyOn : Bool
  let widgetID : UUID
  let dragAction : (inout any WidgetUIProtocol <TypeDictionary>, CanariPoint, Bool) -> Void

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func onMouseDragged (geometry inGeometry : MouseGestureGeometryContext,
                       beginOrContinueUndoGrouping inBeginOrContinueUndoGrouping : () -> Void,
                       selection ioSelection : inout Set <UUID>,
                       userSelectionRectangle ioUserSelectionRectangle : inout CanariRect?,
                       widgetsManager ioWidgetsManager : inout WidgetsManager <TypeDictionary>,
                       optionalNextState outOptionalNextState : inout (any MouseGestureProtocol<TypeDictionary>)?) {
    let translation = inGeometry.alignedUserCurrentLocation - self.alignedCurrentPoint
    if translation != .zero {
      inBeginOrContinueUndoGrouping ()
      if var widget = ioWidgetsManager [id: widgetID] {
        let localTranslation = CanariAffinity (scale: 1.0 / widget.orientedOrigin.mScale)
          .rotating (-widget.orientedOrigin.mAngle)
          .transforming (translation)
        self.dragAction (&widget, localTranslation, self.optionKeyInitiallyOn)
        ioWidgetsManager [id: widgetID] = widget
      }
      outOptionalNextState = MouseGesture_DragKnob (
        alignedCurrentPoint: inGeometry.alignedUserCurrentLocation,
        optionKeyInitiallyOn: self.optionKeyInitiallyOn,
        widgetID: self.widgetID,
        dragAction: self.dragAction
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

