//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 14/03/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

struct MouseGesture_DragKnob <ShapeTypesDescription : DocumentShapesDescriptionProtocol> : MouseGestureProtocol {

  let alignedCurrentPoint : CanariPoint
  let optionKeyInitiallyOn : Bool
  let shapeID : UUID
  let dragKnobAction : (inout CanariScaledOrientedOrigin, inout any CanariShapeUIProtocol <ShapeTypesDescription>, CanariPoint, Bool) -> Void

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func onMouseDragged (geometry inGeometry : MouseGestureGeometryContext,
                       beginOrContinueUndoGrouping inBeginOrContinueUndoGrouping : () -> Void,
                       userSelectionRectangle ioUserSelectionRectangle : inout CanariRect?,
                       shapesManagerInterface inShapesManagerInterface : ShapesUserInterface <ShapeTypesDescription>,
                       optionalNextState outOptionalNextState : inout (any MouseGestureProtocol<ShapeTypesDescription>)?) {
    let translation = inGeometry.alignedUserCurrentLocation - self.alignedCurrentPoint
    if translation != .zero {
      inBeginOrContinueUndoGrouping ()
      if var shape = inShapesManagerInterface [shapeID: self.shapeID] {
        let validatedGlobalTranslation = inShapesManagerInterface.validatedGlobalTranslation (
          proposedValue: translation,
          canvasSize: inGeometry.canvasSize
        )
        let localTranslation = CanariAffinity (scale: 1.0 / shape.orientedOrigin.mScale)
          .rotating (-shape.orientedOrigin.mAngle)
          .transforming (validatedGlobalTranslation)
        var origin = shape.orientedOrigin // §
        self.dragKnobAction (&origin, &shape.shape, localTranslation, self.optionKeyInitiallyOn)
        shape.orientedOrigin = origin
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
                  shapesManagerInterface inShapesManagerInterface : ShapesUserInterface <ShapeTypesDescription>) {
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------

