//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 14/03/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct WidgetKnob <WidgetTypesDescription : DocumentWidgetsDescriptionProtocol> {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private let localPoint : CanariPoint
  let dragWidgetKnobAction : (inout any WidgetUIProtocol <WidgetTypesDescription>, CanariPoint, Bool) -> Void
  let menu : ((ContextualMenuExecutor <WidgetTypesDescription>) -> any View)?

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (localPoint inCenter : CanariPoint,
               dragAction inKnobDragAction : @escaping (inout any WidgetUIProtocol <WidgetTypesDescription>, CanariPoint, Bool) -> Void,
               menu inMenu : ((ContextualMenuExecutor <WidgetTypesDescription>) -> any View)? = nil) {
    self.localPoint = inCenter
    self.dragWidgetKnobAction = inKnobDragAction
    self.menu = inMenu
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func contains (localPoint inLocalPoint : CanariPoint, scale inScale : Double) -> Bool {
    let r = CanariRect (
      center: self.localPoint,
      size: CanariSize (width: .px (10.0 * inScale), height: .px (10.0 * inScale))
    )
    return r.contains (inLocalPoint)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func drawKnob (context ioContext : inout GraphicsContext,
                 scale inScale : Double) {
    let r = CanariRect (center: self.localPoint, size: CanariSize (width: .px (10) / inScale, height: .px (10) / inScale))
    let path = CanariPath (ellipse: r)
    ioContext.fill (path, with: .color (.white))
    ioContext.stroke (path, with: .color (.gray), lineWidth: .px (1) / inScale)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
