//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 09/06/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public extension WidgetUIProtocol {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func drawFromGlobal (context ioContext : inout GraphicsContext,
                       scale inScale : Double,
                       hovered inHovered : Bool,
                       selected inSelected : Bool,
                       groupLevel inGroupLevel : UInt) {
    ioContext.translate (by: self.orientedOrigin.mOrigin)
    ioContext.rotate (by: self.orientedOrigin.mAngle)
    ioContext.scale (by: self.orientedOrigin.mScale, horizontalFlip: self.orientedOrigin.mHorizontalFlip)
    self.drawWidget (
      context: &ioContext,
      scale: inScale * self.orientedOrigin.mScale,
      hovered: inHovered,
      selected: inSelected,
      groupLevel: inGroupLevel
    )
    ioContext.scale (by: 1.0 / self.orientedOrigin.mScale, horizontalFlip: self.orientedOrigin.mHorizontalFlip)
    ioContext.rotate (by: -self.orientedOrigin.mAngle)
    ioContext.translate (by: -self.orientedOrigin.mOrigin)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
