//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 14/03/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct ShapeKnob <ANCHOR : CanariShapeAnchorProtocol,
                         SHAPE_TYPES_DESCRIPTION : DocumentShapesDescriptionProtocol> {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  fileprivate enum Shape {
    case rect
    case circle
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private let localCenter : CanariPoint
  private let shape : Shape
  let dragKnobAction : (inout CanariShapeRoot <ANCHOR, SHAPE_TYPES_DESCRIPTION>, CanariPoint, Bool) -> Void
  let menu : ((ContextualMenuExecutor <ANCHOR, SHAPE_TYPES_DESCRIPTION>) -> any View)?

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (localCenter inCenter : CanariPoint,
               dragAction inKnobDragAction : @escaping (inout CanariShapeRoot <ANCHOR, SHAPE_TYPES_DESCRIPTION>, CanariPoint, Bool) -> Void,
               menu inMenu : ((ContextualMenuExecutor <ANCHOR, SHAPE_TYPES_DESCRIPTION>) -> any View)? = nil) {
    self.localCenter = inCenter
    self.shape = .circle
    self.dragKnobAction = inKnobDragAction
    self.menu = inMenu
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (dragAction inKnobDragAction : @escaping (inout CanariShapeRoot <ANCHOR, SHAPE_TYPES_DESCRIPTION>, CanariPoint, Bool) -> Void,
               menu inMenu : ((ContextualMenuExecutor <ANCHOR, SHAPE_TYPES_DESCRIPTION>) -> any View)? = nil) {
    self.localCenter = .zero
    self.shape = .rect
    self.dragKnobAction = inKnobDragAction
    self.menu = inMenu
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func contains (localPoint inLocalPoint : CanariPoint, scale inScale : Double) -> Bool {
    let r = CanariRect (
      center: self.localCenter,
      size: CanariSize (width: .px (10.0) / inScale, height: .px (10.0) / inScale)
    )
    return r.contains (inLocalPoint)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func drawKnob (context ioContext : inout GraphicsContext,
                 inside inInside : Bool,
                 scale inScale : Double) {
    let r = CanariRect (center: self.localCenter, size: CanariSize (width: .px (10) / inScale, height: .px (10) / inScale))
    let path : CanariPath
    switch self.shape {
    case .rect:
      path = CanariPath (rect: r)
    case .circle:
      path = CanariPath (ellipse: r)
    }
    ioContext.fill (path, with: .color (inInside ? .gray : .white))
    ioContext.stroke (path, with: .color (.gray), lineWidth: .px (1) / inScale)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
