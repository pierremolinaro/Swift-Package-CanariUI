//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 14/03/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct ShapeKnob <ANCHOR : CanariShapeAnchorProtocol,
                         DOCUMENT_SHAPES_DISPLAY_SETTINGS,
                         SHAPE_TYPES_DESCRIPTION : DocumentShapesDescriptionProtocol> {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public enum Role {
    case translate
    case extendShrink (localCenter : CanariPoint)
    case rotate (localPosition : CanariPoint)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private let mRole : Role
  let dragKnobAction : (inout CanariShapeRoot <ANCHOR, DOCUMENT_SHAPES_DISPLAY_SETTINGS, SHAPE_TYPES_DESCRIPTION>, CanariPoint, Bool) -> Void
  let menu : ((ContextualMenuExecutor <ANCHOR, DOCUMENT_SHAPES_DISPLAY_SETTINGS, SHAPE_TYPES_DESCRIPTION>) -> any View)?

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (role inRole : Self.Role,
               dragAction inKnobDragAction : @escaping (inout CanariShapeRoot <ANCHOR, DOCUMENT_SHAPES_DISPLAY_SETTINGS, SHAPE_TYPES_DESCRIPTION>, CanariPoint, Bool) -> Void,
               menu inMenu : ((ContextualMenuExecutor <ANCHOR, DOCUMENT_SHAPES_DISPLAY_SETTINGS, SHAPE_TYPES_DESCRIPTION>) -> any View)? = nil) {
    self.mRole = inRole
    self.dragKnobAction = inKnobDragAction
    self.menu = inMenu
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func contains (localPoint inLocalPoint : CanariPoint,
                        drawingScale inDrawingScale : Double) -> Bool {
    let r = CanariRect (
      center: self.knobLocalCenter,
      size: CanariSize (width: .pt (10.0) / inDrawingScale, height: .pt (10.0) / inDrawingScale)
    )
    return r.contains (inLocalPoint)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private var knobLocalCenter : CanariPoint {
    switch self.mRole {
    case .translate :
      return .zero
    case .extendShrink (let localCenter) :
      return localCenter
    case .rotate (let localCenter) :
      return localCenter
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func drawKnobBackground (context ioContext : inout GraphicsContext,
                           scale inScale : Double) {
    switch self.mRole {
    case .translate, .extendShrink :
      ()
    case .rotate (let localCenter) :
      let line = CanariPath (points: [.zero, localCenter], isClosed: false)
      ioContext.stroke (
        line,
        with: .color (.black),
        lineWidth: .pt (1) / inScale
      )
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func drawKnob (context ioContext : inout GraphicsContext,
                 inside inInside : Bool,
                 scale inScale : Double) {
    let path : CanariPath
    switch self.mRole {
    case .translate :
      let r = CanariRect (
        center: .zero,
        size: CanariSize (width: .pt (10) / inScale, height: .pt (10) / inScale)
      )
      path = CanariPath (rect: r)
    case .extendShrink (let localCenter) :
      let r = CanariRect (
        center: localCenter,
        size: CanariSize (width: .pt (10) / inScale, height: .pt (10) / inScale)
      )
      path = CanariPath (ellipse: r)
    case .rotate (let localCenter) :
      let r = CanariRect (
        center: localCenter,
        size: CanariSize (width: .pt (10) / inScale, height: .pt (10) / inScale)
      )
      path = CanariPath (ellipse: r)
    }
    ioContext.fill (
      path,
      with: .color (inInside ? .gray : .white),
      style: .nonZero
    )
    ioContext.stroke (
      path,
      with: .color (inInside ? .black : .gray),
      lineWidth: .pt (1) / inScale
    )
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
