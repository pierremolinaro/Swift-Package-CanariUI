//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 25/03/2026.
//--------------------------------------------------------------------------------------------------

import Foundation

//--------------------------------------------------------------------------------------------------

public final class ContextualMenuExecutor <ANCHOR : CanariShapeAnchorProtocol,
                                           DOCUMENT_SHAPES_DISPLAY_SETTINGS,
                                           SHAPE_TYPES_DESCRIPTION : DocumentShapesDescriptionProtocol> {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private let mShapesUserInterface : ShapesUserInterface <ANCHOR, DOCUMENT_SHAPES_DISPLAY_SETTINGS, SHAPE_TYPES_DESCRIPTION>
  private let mShapeIndex : Int

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  init (_ inShapesUserInterface : ShapesUserInterface <ANCHOR, DOCUMENT_SHAPES_DISPLAY_SETTINGS, SHAPE_TYPES_DESCRIPTION>,
        _ inIndex : Int) {
    self.mShapesUserInterface = inShapesUserInterface
    self.mShapeIndex = inIndex
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func execute <T : CanariShapeDecorationProtocol <ANCHOR, DOCUMENT_SHAPES_DISPLAY_SETTINGS, SHAPE_TYPES_DESCRIPTION>> (_ inAction : (inout T) -> Void) {
    var shape = self.mShapesUserInterface [shapeIndex: self.mShapeIndex]
    if var decoration = shape.mDecoration as? T {
      inAction (&decoration)
      shape.mDecoration = decoration
      self.mShapesUserInterface [shapeIndex: self.mShapeIndex] = shape
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
