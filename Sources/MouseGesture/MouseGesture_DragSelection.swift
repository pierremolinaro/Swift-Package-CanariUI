//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 15/09/2025.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

struct MouseGesture_DragSelection <ShapeTypesDescription : DocumentShapesDescriptionProtocol> : MouseGestureProtocol {

  let alignedCurrentPoint : CanariPoint

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func onMouseDragged (geometry inGeometry : MouseGestureGeometryContext,
                       beginOrContinueUndoGrouping inBeginOrContinueUndoGrouping : () -> Void,
                       userSelectionRectangle ioUserSelectionRectangle : inout CanariRect?,
                       shapesManagerInterface inShapesManagerInterface : ShapesUserInterface <ShapeTypesDescription>,
                       optionalNextState outOptionalNextState : inout (any MouseGestureProtocol<ShapeTypesDescription>)?) {
    let translation = inShapesManagerInterface.validatedGlobalTranslation (
      proposedValue: inGeometry.alignedUserCurrentLocation - self.alignedCurrentPoint,
      canvasSize: inGeometry.canvasSize
    )
    if translation != .zero {
      inBeginOrContinueUndoGrouping ()
      for i in 0 ..< inShapesManagerInterface.shapeCount {
        if inShapesManagerInterface.selection.contains (inShapesManagerInterface [shapeIndex: i].shape.id) {
          inShapesManagerInterface [shapeIndex: i].orientedOrigin.mOrigin += translation
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
                  shapesManagerInterface inShapesManagerInterface : ShapesUserInterface <ShapeTypesDescription>) {
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
