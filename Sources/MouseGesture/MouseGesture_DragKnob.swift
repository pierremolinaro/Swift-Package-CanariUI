//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 14/03/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

struct MouseGesture_DragKnob <ANCHOR : CanariShapeAnchorProtocol,
                              DOCUMENT_SHAPES_DISPLAY_SETTINGS,
                              SHAPE_TYPES_DESCRIPTION : DocumentShapesDescriptionProtocol> : MouseGestureProtocol {

  let alignedCurrentPoint : CanariPoint
  let optionKeyInitiallyOn : Bool
  let shapeID : UUID
  let dragKnobAction : (inout CanariShapeRoot <ANCHOR, DOCUMENT_SHAPES_DISPLAY_SETTINGS, SHAPE_TYPES_DESCRIPTION>, CanariPoint, Bool) -> Void

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func onMouseDragged (geometry inGeometry : MouseGestureGeometryContext,
                       beginOrContinueUndoGrouping inBeginOrContinueUndoGrouping : () -> Void,
                       userSelectionRectangle ioUserSelectionRectangle : inout CanariRect?,
                       shapesManagerInterface inShapesManagerInterface : ShapesUserInterface <ANCHOR, DOCUMENT_SHAPES_DISPLAY_SETTINGS, SHAPE_TYPES_DESCRIPTION>,
                       optionalNextState outOptionalNextState : inout (any MouseGestureProtocol<ANCHOR, DOCUMENT_SHAPES_DISPLAY_SETTINGS, SHAPE_TYPES_DESCRIPTION>)?) {
    let translation = inGeometry.alignedUserCurrentLocation - self.alignedCurrentPoint
    if translation != .zero {
      inBeginOrContinueUndoGrouping ()
      if var shape = inShapesManagerInterface [shapeID: self.shapeID] {
        let validatedGlobalTranslation = inShapesManagerInterface.validatedGlobalTranslation (
          proposedValue: translation,
          canvasSize: inGeometry.canvasSize
        )
        let localTranslation = shape.mAnchor.globalTranslationToLocalTranslation (validatedGlobalTranslation)
        self.dragKnobAction (&shape, localTranslation, self.optionKeyInitiallyOn)
        inShapesManagerInterface [shapeID: self.shapeID] = shape
      }
      outOptionalNextState = MouseGesture_DragKnob (
        alignedCurrentPoint: inGeometry.alignedUserCurrentLocation,
        optionKeyInitiallyOn: self.optionKeyInitiallyOn,
        shapeID: self.shapeID,
        dragKnobAction: self.dragKnobAction
      )
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func onMouseUp (removeUndoGrouping inRemoveUndoGrouping : () -> Void,
                  userSelectionRectangle ioUserSelectionRectangle : inout CanariRect?,
                  shapesManagerInterface inShapesManagerInterface : ShapesUserInterface <ANCHOR, DOCUMENT_SHAPES_DISPLAY_SETTINGS, SHAPE_TYPES_DESCRIPTION>) {
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------

