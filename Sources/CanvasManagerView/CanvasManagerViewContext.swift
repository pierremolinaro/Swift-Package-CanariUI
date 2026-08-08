//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 30/03/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct CanvasManagerViewContext {
  public let zoomValues : [UInt16]
  public let canvasSize : CanariSize
  public let contentSizeWithMargins : CanariSize
  public let margins : CanvasMargins
  public let rulerDescriptor : CanariRulerDisplayDescriptor
  public let magneticGrid : CanariLength?
  public let rulerBackColor : Color

  public init (zoomValues: [UInt16],
               canvasSize: CanariSize,
               margins: CanvasMargins,
               rulerDescriptor: CanariRulerDisplayDescriptor,
               magneticGrid: CanariLength?,
               rulerBackColor: Color) {
    self.zoomValues = zoomValues
    self.canvasSize = canvasSize
    self.margins = margins
    self.rulerDescriptor = rulerDescriptor
    self.magneticGrid = magneticGrid
    self.rulerBackColor = rulerBackColor
    self.contentSizeWithMargins = CanariSize (
      width: canvasSize.width + margins.left + margins.right,
      height: canvasSize.height + margins.top + margins.bottom
    )
  }
}

//--------------------------------------------------------------------------------------------------
