//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 25/03/2026.
//--------------------------------------------------------------------------------------------------

import Foundation

//--------------------------------------------------------------------------------------------------

public final class ContextualMenuExecutor <ShapeTypesDescription : DocumentShapesDescriptionProtocol> {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private let mShapesUserInterface : ShapesUserInterface <ShapeTypesDescription>
  private let mShapeIndex : Int

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  init (_ inShapesUserInterface : ShapesUserInterface <ShapeTypesDescription>,
        _ inIndex : Int) {
    self.mShapesUserInterface = inShapesUserInterface
    self.mShapeIndex = inIndex
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func execute <T : CanariShapeDecorationProtocol <ShapeTypesDescription>> (_ inAction : (inout T) -> Void) {
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
