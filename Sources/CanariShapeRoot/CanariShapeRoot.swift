//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 21/02/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public nonisolated struct CanariShapeRoot <ANCHOR : CanariShapeAnchorProtocol,
                                           SHAPE_TYPES_DESCRIPTION : DocumentShapesDescriptionProtocol> : Sendable, Identifiable {

  public let id = UUID () // Identifiable

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var mAnchor : ANCHOR {
    didSet {
      self.mAnchor.setLocalOutline (self.mDecoration.localOutlinePath)
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var mDecoration : any CanariShapeDecorationProtocol <ANCHOR, SHAPE_TYPES_DESCRIPTION> {
    didSet {
      self.mAnchor.setLocalOutline (self.mDecoration.localOutlinePath)
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (_ inAnchor : ANCHOR,
               _ inDecoration : any CanariShapeDecorationProtocol <ANCHOR, SHAPE_TYPES_DESCRIPTION>) {
    self.mAnchor = inAnchor
    self.mDecoration = inDecoration
    self.mAnchor.setLocalOutline (self.mDecoration.localOutlinePath)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Knobs
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  var knobs : [ShapeKnob <ANCHOR, SHAPE_TYPES_DESCRIPTION>] {
    var result = self.mDecoration.shapeKnobs
    result.append (ShapeKnob (dragAction: Self.dragCenterKnob))
    return result
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private static func dragCenterKnob (_ ioShape : inout CanariShapeRoot <ANCHOR, SHAPE_TYPES_DESCRIPTION>,
                                      _ inLocalTranslation : CanariPoint,
                                      _ inInitialOptionKeyOn : Bool) {
    ioShape.mAnchor.addLocalTranslation (inLocalTranslation)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
