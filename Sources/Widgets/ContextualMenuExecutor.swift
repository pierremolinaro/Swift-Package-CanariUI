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

  public func execute <T : CanariShapeUIProtocol <ShapeTypesDescription>> (_ inAction : (inout T) -> Void) {
    var widget = self.mShapesUserInterface [shapeIndex: self.mShapeIndex]
    if var shape = widget.shape as? T {
      inAction (&shape)
      widget.shape = shape
      self.mShapesUserInterface [shapeIndex: self.mShapeIndex] = widget
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
