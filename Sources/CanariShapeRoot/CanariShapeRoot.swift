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
  //--- Drag knob
    result.append (ShapeKnob (dragAction: Self.dragCenterKnob))
  //--- Rotation Knob
    if SHAPE_TYPES_DESCRIPTION.rotationKnobIsDisplayed (type (of: self.mDecoration)) {
      let boundingRect = self.mDecoration.localOutlinePath.boundingRect
      if boundingRect.maxX >= boundingRect.maxY {
        let localPosition = CanariPoint (x: self.mDecoration.localOutlinePath.boundingRect.maxX / 2.0)
        result.append (ShapeKnob (localCenter: localPosition, dragAction: Self.dragLeftRotationKnob))
      }else{
        let localPosition = CanariPoint (y: self.mDecoration.localOutlinePath.boundingRect.maxY / 2.0)
        result.append (ShapeKnob (localCenter: localPosition, dragAction: Self.dragTopRotationKnob))
      }
    }
    return result
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private static func dragCenterKnob (_ ioShape : inout CanariShapeRoot <ANCHOR, DOCUMENT_SHAPES_DISPLAY_SETTINGS, SHAPE_TYPES_DESCRIPTION>,
                                      _ inLocalTranslation : CanariPoint,
                                      _ inInitialOptionKeyOn : Bool) {
    ioShape.mAnchor.addLocalTranslation (inLocalTranslation)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private static func dragLeftRotationKnob (_ ioShape : inout CanariShapeRoot <ANCHOR, DOCUMENT_SHAPES_DISPLAY_SETTINGS, SHAPE_TYPES_DESCRIPTION>,
                                            _ inLocalTranslation : CanariPoint,
                                            _ inInitialOptionKeyOn : Bool) {
    let p = CanariPoint (x: ioShape.mDecoration.localOutlinePath.boundingRect.maxX / 2.0) + inLocalTranslation
    let angle = p.angle ()
    ioShape.mAnchor.addRotation (angle)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private static func dragTopRotationKnob (_ ioShape : inout CanariShapeRoot <ANCHOR, DOCUMENT_SHAPES_DISPLAY_SETTINGS, SHAPE_TYPES_DESCRIPTION>,
                                           _ inLocalTranslation : CanariPoint,
                                           _ inInitialOptionKeyOn : Bool) {
    let p = CanariPoint (y: ioShape.mDecoration.localOutlinePath.boundingRect.maxY / 2.0) + inLocalTranslation
    let angle = p.angle ()
    ioShape.mAnchor.addRotation (angle)
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
