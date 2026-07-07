//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 21/02/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public nonisolated struct CanariShapeRoot <ShapeTypesDescription : DocumentShapesDescriptionProtocol> : Sendable {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var mOrigin : CanariScaledOrientedOrigin {
    didSet {
      self.mOrigin.setLocalOutline (self.mDecoration.localOutlinePath)
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var mDecoration : any CanariShapeDecorationProtocol <ShapeTypesDescription> {
    didSet {
      self.mOrigin.setLocalOutline (self.mDecoration.localOutlinePath)
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (_ inOrientedOrigin : CanariScaledOrientedOrigin,
               _ inDecoration : any CanariShapeDecorationProtocol <ShapeTypesDescription>) {
    self.mOrigin = inOrientedOrigin
    self.mDecoration = inDecoration
    self.mOrigin.setLocalOutline (self.mDecoration.localOutlinePath)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Knobs
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  var knobs : [ShapeKnob <ShapeTypesDescription>] {
    var result = self.mDecoration.shapeKnobs
    result.append (ShapeKnob (dragAction: Self.dragCenterKnob))
    return result
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private static func dragCenterKnob (_ ioShape : inout CanariShapeRoot <ShapeTypesDescription>,
                                      _ inLocalTranslation : CanariPoint,
                                      _ inInitialOptionKeyOn : Bool) {
    ioShape.mOrigin.addLocalTranslation (inLocalTranslation)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
