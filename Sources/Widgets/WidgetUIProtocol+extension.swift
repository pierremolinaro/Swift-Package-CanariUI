//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 09/06/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public extension WidgetUIProtocol {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Canvas Enclosing rect
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  var canvasEnclosingRect : CanariRect {
    self.orientedOrigin.localToGlobal (self.localEnclosingRect).boundingRect
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Rotate
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

//  mutating func rotate (by inAngle : CanariAngle) {
//    self.orientedOrigin.mAngle += inAngle
//  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Limit Translation
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func limitTranslation (_ ioTranslation : inout CanariPoint, _ inCanvasSize : CanariSize) {
    let r = self.canvasEnclosingRect
    let newTopRight = r.topRight + ioTranslation
    if newTopRight.x > inCanvasSize.width {
      ioTranslation.x -= newTopRight.x - inCanvasSize.width
    }
    if newTopRight.y > inCanvasSize.height {
      ioTranslation.y -= newTopRight.y - inCanvasSize.height
    }
    let newBottomLeft = r.bottomLeft + ioTranslation
    if newBottomLeft.x < .zero {
      ioTranslation.x -= newBottomLeft.x
    }
    if newBottomLeft.y < .zero {
      ioTranslation.y -= newBottomLeft.y
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Translate
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  mutating func translate (by inTranslation : CanariPoint) {
    self.orientedOrigin.mOrigin.x += inTranslation.x
    self.orientedOrigin.mOrigin.y += inTranslation.y
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func drawFromCanvas (context ioContext : inout GraphicsContext,
                       scale inScale : Double,
                       hovered inHovered : Bool,
                       selected inSelected : Bool,
                       groupLevel inGroupLevel : UInt) {
    ioContext.translateBy (self.orientedOrigin.mOrigin)
    ioContext.rotate (by: self.orientedOrigin.mAngle)
    ioContext.scaleBy (x: self.orientedOrigin.mScale, y: self.orientedOrigin.mScale)
    self.draw (
      context: &ioContext,
      scale: inScale * self.orientedOrigin.mScale,
      hovered: inHovered,
      selected: inSelected,
      groupLevel: inGroupLevel
    )
    ioContext.scaleBy (x: 1.0 / self.orientedOrigin.mScale, y: 1.0 / self.orientedOrigin.mScale)
    ioContext.rotate (by: -self.orientedOrigin.mAngle)
    ioContext.translateBy (-self.orientedOrigin.mOrigin)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
