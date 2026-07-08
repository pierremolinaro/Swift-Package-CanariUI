//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 15/09/2025.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

struct MouseGesture_Creation <SHAPE_TYPES_DESCRIPTION : DocumentShapesDescriptionProtocol> : MouseGestureProtocol {

  let objectCreator : (MouseGestureGeometryContext) -> CanariShapeRoot <SHAPE_TYPES_DESCRIPTION>

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func onMouseDragged (geometry inGeometry : MouseGestureGeometryContext,
                       beginOrContinueUndoGrouping inBeginOrContinueUndoGrouping : () -> Void,
                       userSelectionRectangle ioUserSelectionRectangle : inout CanariRect?,
                       shapesManagerInterface inShapesManagerInterface : ShapesUserInterface <SHAPE_TYPES_DESCRIPTION>,
                       optionalNextState outOptionalNextState : inout (any MouseGestureProtocol<SHAPE_TYPES_DESCRIPTION>)?) {
    let newObject = self.objectCreator (inGeometry)
    inShapesManagerInterface [shapeIndex: inShapesManagerInterface.shapeCount - 1] = newObject
    inShapesManagerInterface.setSelection (withID: newObject.id)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func onMouseUp (removeUndoGrouping inRemoveUndoGrouping : () -> Void,
                  userSelectionRectangle ioUserSelectionRectangle : inout CanariRect?,
                  shapesManagerInterface inShapesManagerInterface : ShapesUserInterface <SHAPE_TYPES_DESCRIPTION>) {
    if inShapesManagerInterface [shapeIndex: inShapesManagerInterface.shapeCount - 1].mDecoration.isGraphicallyEmpty {
      inShapesManagerInterface.removeLast ()
      inShapesManagerInterface.clearSelection ()
      inRemoveUndoGrouping ()
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
