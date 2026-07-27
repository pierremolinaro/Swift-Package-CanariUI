//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 15/09/2025.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

struct MouseGesture_Inactive <ANCHOR : CanariShapeAnchorProtocol,
                              DOCUMENT_SHAPES_DISPLAY_SETTINGS,
                              SHAPE_TYPES_DESCRIPTION : DocumentShapesDescriptionProtocol> : MouseGestureProtocol {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func onMouseDragged (geometry inGeometry : MouseGestureGeometryContext,
                       beginOrContinueUndoGrouping inBeginOrContinueUndoGrouping : () -> Void,
                       userSelectionRectangle ioUserSelectionRectangle : inout CanariRect?,
                       shapesManagerInterface inShapesManagerInterface : ShapesUserInterface <ANCHOR, DOCUMENT_SHAPES_DISPLAY_SETTINGS, SHAPE_TYPES_DESCRIPTION>,
                       optionalNextState outOptionalNextState : inout (any MouseGestureProtocol<ANCHOR, DOCUMENT_SHAPES_DISPLAY_SETTINGS, SHAPE_TYPES_DESCRIPTION>)?) {
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func onMouseUp (removeUndoGrouping inRemoveUndoGrouping : () -> Void,
                  userSelectionRectangle ioUserSelectionRectangle : inout CanariRect?,
                  shapesManagerInterface inShapesManagerInterface : ShapesUserInterface <ANCHOR, DOCUMENT_SHAPES_DISPLAY_SETTINGS, SHAPE_TYPES_DESCRIPTION>) {
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
