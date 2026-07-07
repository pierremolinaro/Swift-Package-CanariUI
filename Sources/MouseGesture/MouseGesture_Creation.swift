//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 15/09/2025.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

struct MouseGesture_Creation <ShapeTypesDescription : DocumentShapesDescriptionProtocol> : MouseGestureProtocol {

  let objectCreator : (MouseGestureGeometryContext) -> CanariShapeRoot <ShapeTypesDescription>

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func onMouseDragged (geometry inGeometry : MouseGestureGeometryContext,
                       beginOrContinueUndoGrouping inBeginOrContinueUndoGrouping : () -> Void,
                       userSelectionRectangle ioUserSelectionRectangle : inout CanariRect?,
                       shapesManagerInterface inShapesManagerInterface : ShapesUserInterface <ShapeTypesDescription>,
                       optionalNextState outOptionalNextState : inout (any MouseGestureProtocol<ShapeTypesDescription>)?) {
    let newObject = self.objectCreator (inGeometry)
    inShapesManagerInterface [shapeIndex: inShapesManagerInterface.shapeCount - 1] = newObject
    inShapesManagerInterface.setSelection (withID: newObject.mDecoration.id)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func onMouseUp (removeUndoGrouping inRemoveUndoGrouping : () -> Void,
                  userSelectionRectangle ioUserSelectionRectangle : inout CanariRect?,
                  shapesManagerInterface inShapesManagerInterface : ShapesUserInterface <ShapeTypesDescription>) {
    if inShapesManagerInterface [shapeIndex: inShapesManagerInterface.shapeCount - 1].mDecoration.isGraphicallyEmpty {
      inShapesManagerInterface.removeLast ()
      inShapesManagerInterface.clearSelection ()
      inRemoveUndoGrouping ()
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
