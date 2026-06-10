//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 28/03/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct VerticalRulerViewContext {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public let contentHeight : CanariLength
  public let rulerSize : CanariSize
  public let scale : Double
  public let hoverLocationY : CanariLength?
  public let scrollY : CanariLength
  public let originOffsetY : CanariLength
  public let bottomMargin : CanariLength

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (contentHeight: CanariLength,
               rulerSize: CanariSize,
               scale: Double,
               hoverLocationY: CanariLength?,
               scrollY: CanariLength,
               originOffsetY: CanariLength,
               bottomMargin: CanariLength) {
    self.contentHeight = contentHeight
    self.rulerSize = rulerSize
    self.scale = scale
    self.hoverLocationY = hoverLocationY
    self.scrollY = scrollY
    self.originOffsetY = originOffsetY
    self.bottomMargin = bottomMargin
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
