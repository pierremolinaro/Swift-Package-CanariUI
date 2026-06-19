//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 14/03/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct WidgetKnob <WidgetTypesDescription : DocumentWidgetsDescriptionProtocol> {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  fileprivate enum Shape {
    case rect
    case circle
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private let localCenter : CanariPoint
  private let shape : Shape
  let dragWidgetKnobAction : (inout any CanariShapeUIProtocol <WidgetTypesDescription>, CanariPoint, Bool) -> Void
  let menu : ((ContextualMenuExecutor <WidgetTypesDescription>) -> any View)?

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (localCenter inCenter : CanariPoint,
               dragAction inKnobDragAction : @escaping (inout any CanariShapeUIProtocol <WidgetTypesDescription>, CanariPoint, Bool) -> Void,
               menu inMenu : ((ContextualMenuExecutor <WidgetTypesDescription>) -> any View)? = nil) {
    self.localCenter = inCenter
    self.shape = .circle
    self.dragWidgetKnobAction = inKnobDragAction
    self.menu = inMenu
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (dragAction inKnobDragAction : @escaping (inout any CanariShapeUIProtocol <WidgetTypesDescription>, CanariPoint, Bool) -> Void,
               menu inMenu : ((ContextualMenuExecutor <WidgetTypesDescription>) -> any View)? = nil) {
    self.localCenter = .zero
    self.shape = .rect
    self.dragWidgetKnobAction = inKnobDragAction
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
