//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 21/02/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public nonisolated struct CanariShapeRoot <ANCHOR : CanariShapeAnchorProtocol,
                                           DOCUMENT_SHAPES_DISPLAY_SETTINGS,
                                           SHAPE_TYPES_DESCRIPTION : DocumentShapesDescriptionProtocol> : Sendable, Identifiable {

  public let id = UUID () // Identifiable

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (_ inAnchor : ANCHOR,
               _ inDecoration : any CanariShapeDecorationProtocol <ANCHOR, DOCUMENT_SHAPES_DISPLAY_SETTINGS, SHAPE_TYPES_DESCRIPTION>) {
    self.mAnchor = inAnchor
    self.mDecoration = inDecoration
    self.mAnchor.setLocalOutline (self.mDecoration.localOutlinePath)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var mAnchor : ANCHOR {
    didSet {
      self.mAnchor.setLocalOutline (self.mDecoration.localOutlinePath)
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var mDecoration : any CanariShapeDecorationProtocol <ANCHOR, DOCUMENT_SHAPES_DISPLAY_SETTINGS, SHAPE_TYPES_DESCRIPTION> {
    didSet {
      self.mAnchor.setLocalOutline (self.mDecoration.localOutlinePath)
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Knobs
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  var knobs : [ShapeKnob <ANCHOR, DOCUMENT_SHAPES_DISPLAY_SETTINGS, SHAPE_TYPES_DESCRIPTION>] {
    var result = self.mDecoration.shapeKnobs
    result.append (ShapeKnob (dragAction: Self.dragCenterKnob))
    return result
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private static func dragCenterKnob (_ ioShape : inout CanariShapeRoot <ANCHOR, DOCUMENT_SHAPES_DISPLAY_SETTINGS, SHAPE_TYPES_DESCRIPTION>,
                                      _ inLocalTranslation : CanariPoint,
                                      _ inInitialOptionKeyOn : Bool) {
    ioShape.mAnchor.addLocalTranslation (inLocalTranslation)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Issues
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func appendIssues (to ioArray : inout [CanariShapeIssue],
                            executor inShapesUI : ShapesUserInterface <ANCHOR, DOCUMENT_SHAPES_DISPLAY_SETTINGS, SHAPE_TYPES_DESCRIPTION>) {
    if !self.mAnchor.globalOrigin.isAligned (CanariLength.µm (1)) {
      let issue = CanariShapeIssue (
        id: CanariShapeIssue.Identifier (shapeID: self.id, index: 0),
        title: "Center is not µm aligned",
        absoluteOutline: self.mAnchor.globalOutline,
        kind: .warning,
        namedAction: ("µmAlign", { inShapesUI [shapeID: self.id]?.mAnchor.alignGlobalOrigin (on: CanariLength.µm (1)) })
      )
      ioArray.append (issue)
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
