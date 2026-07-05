//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 01/03/2026.
//--------------------------------------------------------------------------------------------------

import Foundation

//--------------------------------------------------------------------------------------------------

public struct BackgroundViewContext {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public let contentSizeWithMargins : CanariSize
  public let canvasScale : Double
  public let overWidth : CanariLength
  public let overHeight : CanariLength
  public let margins : CanvasMargins

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (contentSizeWithMargins: CanariSize,
               canvasScale: Double,
               overWidth: CanariLength,
               overHeight: CanariLength,
               margins: CanvasMargins) {
    self.contentSizeWithMargins = contentSizeWithMargins
    self.canvasScale = canvasScale
    self.overWidth = overWidth
    self.overHeight = overHeight
    self.margins = margins
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
