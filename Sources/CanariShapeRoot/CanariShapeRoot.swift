//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 21/02/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public nonisolated struct CanariShapeRoot <SHAPE_TYPES_DESCRIPTION : DocumentShapesDescriptionProtocol> : Sendable, Identifiable {

  public let id = UUID () // Identifiable

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var mAnchor : CanariScaledOrientedAnchor {
    didSet {
      self.mAnchor.setLocalOutline (self.mDecoration.localOutlinePath)
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var mDecoration : any CanariShapeDecorationProtocol <SHAPE_TYPES_DESCRIPTION> {
    didSet {
      self.mAnchor.setLocalOutline (self.mDecoration.localOutlinePath)
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (_ inAnchor : CanariScaledOrientedAnchor,
               _ inDecoration : any CanariShapeDecorationProtocol <SHAPE_TYPES_DESCRIPTION>) {
    self.mAnchor = inAnchor
    self.mDecoration = inDecoration
    self.mAnchor.setLocalOutline (self.mDecoration.localOutlinePath)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Knobs
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  var knobs : [ShapeKnob <SHAPE_TYPES_DESCRIPTION>] {
    var result = self.mDecoration.shapeKnobs
    result.append (ShapeKnob (dragAction: Self.dragCenterKnob))
    return result
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private static func dragCenterKnob (_ ioShape : inout CanariShapeRoot <SHAPE_TYPES_DESCRIPTION>,
                                      _ inLocalTranslation : CanariPoint,
                                      _ inInitialOptionKeyOn : Bool) {
    ioShape.mAnchor.addLocalTranslation (inLocalTranslation)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
