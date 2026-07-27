//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 14/03/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct ShapeKnob <ANCHOR : CanariShapeAnchorProtocol,
                         DOCUMENT_SHAPES_DISPLAY_SETTINGS,
                         SHAPE_TYPES_DESCRIPTION : DocumentShapesDescriptionProtocol> {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  fileprivate enum Shape {
    case rect
    case circle
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private let localCenter : CanariPoint
  private let shape : Shape
  let dragKnobAction : (inout CanariShapeRoot <ANCHOR, DOCUMENT_SHAPES_DISPLAY_SETTINGS, SHAPE_TYPES_DESCRIPTION>, CanariPoint, Bool) -> Void
  let menu : ((ContextualMenuExecutor <ANCHOR, DOCUMENT_SHAPES_DISPLAY_SETTINGS, SHAPE_TYPES_DESCRIPTION>) -> any View)?

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (localCenter inCenter : CanariPoint,
               dragAction inKnobDragAction : @escaping (inout CanariShapeRoot <ANCHOR, DOCUMENT_SHAPES_DISPLAY_SETTINGS, SHAPE_TYPES_DESCRIPTION>, CanariPoint, Bool) -> Void,
               menu inMenu : ((ContextualMenuExecutor <ANCHOR, DOCUMENT_SHAPES_DISPLAY_SETTINGS, SHAPE_TYPES_DESCRIPTION>) -> any View)? = nil) {
    self.localCenter = inCenter
    self.shape = .circle
    self.dragKnobAction = inKnobDragAction
    self.menu = inMenu
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (dragAction inKnobDragAction : @escaping (inout CanariShapeRoot <ANCHOR, DOCUMENT_SHAPES_DISPLAY_SETTINGS, SHAPE_TYPES_DESCRIPTION>, CanariPoint, Bool) -> Void,
               menu inMenu : ((ContextualMenuExecutor <ANCHOR, DOCUMENT_SHAPES_DISPLAY_SETTINGS, SHAPE_TYPES_DESCRIPTION>) -> any View)? = nil) {
    self.localCenter = .zero
    self.shape = .rect
    self.dragKnobAction = inKnobDragAction
    self.menu = inMenu
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func contains (localPoint inLocalPoint : CanariPoint,
                        drawingScale inDrawingScale : Double) -> Bool {
    let r = CanariRect (
      center: self.localCenter,
      size: CanariSize (width: .px (10.0) / inDrawingScale, height: .px (10.0) / inDrawingScale)
    )
    return r.contains (inLocalPoint)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func drawKnob (context ioContext : inout GraphicsContext,
                 inside inInside : Bool,
                 scale inScale : Double) {
    let r = CanariRect (
      center: self.localCenter,
      size: CanariSize (width: .px (10) / inScale, height: .px (10) / inScale)
    )
    let path : CanariPath
    switch self.shape {
    case .rect:
      path = CanariPath (rect: r)
    case .circle:
      path = CanariPath (ellipse: r)
    }
    ioContext.fill (
      path,
      with: .color (inInside ? .gray : .white)
    )
    ioContext.stroke (
      path,
      with: .color (inInside ? .black : .gray),
      lineWidth: .px (1) / inScale
    )
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
