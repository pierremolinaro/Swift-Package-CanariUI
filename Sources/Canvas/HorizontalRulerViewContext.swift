//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 28/03/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct HorizontalRulerViewContext {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public let contentWidth : CanariLength
  public let rulerSize : CanariSize
  public let scale : Double
  public let hoverLocationX : CanariLength?
  public let scrollX : CanariLength
  public let originOffsetX : CanariLength
  public let leftMargin : CanariLength

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (contentWidth: CanariLength,
               rulerSize: CanariSize,
               scale: Double,
               hoverLocationX: CanariLength?,
               scrollX: CanariLength,
               originOffsetX: CanariLength,
               leftMargin: CanariLength) {
    self.contentWidth = contentWidth
    self.rulerSize = rulerSize
    self.scale = scale
    self.hoverLocationX = hoverLocationX
    self.scrollX = scrollX
    self.originOffsetX = originOffsetX
    self.leftMargin = leftMargin
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
