//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 14/03/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct WidgetKnob <TypeDictionary : WidgetTypeArrayProtocol> {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private let center : CanariPoint
  let dragAction : (inout any WidgetUIProtocol <TypeDictionary>, CanariPoint, Bool) -> Void
  let menu : ((ContextualMenuExecutor <TypeDictionary>) -> any View)?

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (center inCenter : CanariPoint,
               dragAction inKnobDragAction : @escaping (inout any WidgetUIProtocol <TypeDictionary>, CanariPoint, Bool) -> Void,
               menu inMenu : ((ContextualMenuExecutor <TypeDictionary>) -> any View)?) {
    self.center = inCenter
    self.dragAction = inKnobDragAction
    self.menu = inMenu
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func contains (point inPoint : CanariPoint, zoom inZoom : Double) -> Bool {
    let r = CanariRect (
      center: self.center,
      size: CanariSize (width: .px (10.0 * inZoom), height: .px (10.0 * inZoom))
    )
    return r.contains (inPoint)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func draw (context ioContext : inout GraphicsContext,
                    zoom inZoom : Double) {
    let r = CanariRect (center: self.center.scaled (by: inZoom), size: CanariSize (width: .px (10), height: .px (10)))
    let path = CanariPath (ellipse: r)
    ioContext.fill (path, with: .color (.white))
    ioContext.stroke (path, with: .color (.gray), lineWidth: .px (1))
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
