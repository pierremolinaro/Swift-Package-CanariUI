//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 30/03/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct CanvasManagerViewContext {
  public let zoomValues : [UInt16]
  public let contentSize : CanariSize
  public let margins : CanvasMargins
  public let rulerDescriptor : RulerDisplayDescriptor
  public let magneticGrid : CanariLength?
  public let rulerBackColor : Color

  public init (zoomValues: [UInt16],
               contentSize: CanariSize,
               margins: CanvasMargins,
               rulerDescriptor: RulerDisplayDescriptor,
               magneticGrid: CanariLength?,
               rulerBackColor: Color) {
    self.zoomValues = zoomValues
    self.contentSize = contentSize
    self.margins = margins
    self.rulerDescriptor = rulerDescriptor
    self.magneticGrid = magneticGrid
    self.rulerBackColor = rulerBackColor
  }
}

//--------------------------------------------------------------------------------------------------
