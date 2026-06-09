//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 14/03/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct WidgetKnob <TypeDictionary : WidgetTypeArrayProtocol> {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private let localCenter : CanariPoint
  let dragAction : (inout any WidgetUIProtocol <TypeDictionary>, CanariPoint, Bool) -> Void
  let menu : ((ContextualMenuExecutor <TypeDictionary>) -> any View)?

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (localCenter inCenter : CanariPoint,
               dragAction inKnobDragAction : @escaping (inout any WidgetUIProtocol <TypeDictionary>, CanariPoint, Bool) -> Void,
               menu inMenu : ((ContextualMenuExecutor <TypeDictionary>) -> any View)? = nil) {
    self.localCenter = inCenter
    self.dragAction = inKnobDragAction
    self.menu = inMenu
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func contains (localPoint inLocalPoint : CanariPoint, zoom inZoom : Double) -> Bool {
    let r = CanariRect (
      center: self.localCenter,
      size: CanariSize (width: .px (10.0 * inZoom), height: .px (10.0 * inZoom))
    )
    return r.contains (inLocalPoint)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func draw (context ioContext : inout GraphicsContext,
             zoom inZoom : Double) {
    let r = CanariRect (center: self.localCenter, size: CanariSize (width: .px (10) / inZoom, height: .px (10) / inZoom))
    let path = CanariPath (ellipse: r)
    ioContext.fill (path, with: .color (.white))
    ioContext.stroke (path, with: .color (.gray), lineWidth: .px (1) / inZoom)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
