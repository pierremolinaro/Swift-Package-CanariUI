//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 15/09/2025.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

struct MouseGesture_DragSelection <SHAPE_TYPES_DESCRIPTION : DocumentShapesDescriptionProtocol> : MouseGestureProtocol {

  let alignedCurrentPoint : CanariPoint

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func onMouseDragged (geometry inGeometry : MouseGestureGeometryContext,
                       beginOrContinueUndoGrouping inBeginOrContinueUndoGrouping : () -> Void,
                       userSelectionRectangle ioUserSelectionRectangle : inout CanariRect?,
                       shapesManagerInterface inShapesManagerInterface : ShapesUserInterface <SHAPE_TYPES_DESCRIPTION>,
                       optionalNextState outOptionalNextState : inout (any MouseGestureProtocol<SHAPE_TYPES_DESCRIPTION>)?) {
    let translation = inShapesManagerInterface.validatedGlobalTranslation (
      proposedValue: inGeometry.alignedUserCurrentLocation - self.alignedCurrentPoint,
      canvasSize: inGeometry.canvasSize
    )
    if translation != .zero {
      inBeginOrContinueUndoGrouping ()
      for i in 0 ..< inShapesManagerInterface.shapeCount {
        if inShapesManagerInterface.selection.contains (inShapesManagerInterface [shapeIndex: i].id) {
          inShapesManagerInterface [shapeIndex: i].mOrigin.mPoint += translation
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
                  shapesManagerInterface inShapesManagerInterface : ShapesUserInterface <SHAPE_TYPES_DESCRIPTION>) {
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
