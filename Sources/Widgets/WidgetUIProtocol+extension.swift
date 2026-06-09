//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 09/06/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

extension WidgetUIProtocol {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Canvas Enclosing rect
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  var canvasEnclosingRect : CanariRect {
    self.orientedOrigin.localToCanvas (self.localEnclosingRect).boundingRect
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Rotate
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  mutating func rotate (by inAngle : CanariAngle) {
    self.orientedOrigin.rotate (inAngle)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Limit Translation
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func limitTranslation (_ ioTranslation : inout CanariPoint) {
    let r = self.canvasEnclosingRect
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
    self.orientedOrigin.translate (x: inTranslation.x, y: inTranslation.y)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
