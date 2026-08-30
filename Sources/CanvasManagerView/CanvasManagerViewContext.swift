//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 30/03/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct CanvasManagerViewContext {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public let zoomValues : [UInt16]
  public let canvasSize : CanariSize
  public let contentSizeWithMargins : CanariSize
  public let margins : CanvasMargins
  public let magneticGrid : CanariLength?
  public let rulerBackColor : Color
  public let rulerSize : CanariSize
  public let showTopHorizontalRuler : Bool
  public let showBottomHorizontalRuler : Bool
  public let showLeftVerticalRuler : Bool
  public let showRightVerticalRuler : Bool
  public let backgroundView : ((BackgroundViewContext) -> any View)?
  public let topHorizontalRulerView : (CanariHorizontalRulerViewContext) -> any View
  public let leftVerticalRulerView : (CanariVerticalRulerViewContext) -> any View
  public let bottomHorizontalRulerView : (CanariHorizontalRulerViewContext) -> any View
  public let rightVerticalRulerView : (CanariVerticalRulerViewContext) -> any View
  public let drawCanvasBackGround : (_ ioContext : inout GraphicsContext) -> Void
  public let drawCanvasOverlay : (_ ioContext : inout GraphicsContext) -> Void
  public let droppedFilesHandler : (([Data], CanariPoint) -> Void)?

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (zoomValues: [UInt16],
               canvasSize: CanariSize,
               margins: CanvasMargins,
               magneticGrid: CanariLength?,
               rulerBackColor: Color,
               rulerSize inRulerSize : CanariSize,
               showTopHorizontalRuler inShowTopHorizontalRuler : Bool,
               showBottomHorizontalRuler inShowBottomHorizontalRuler : Bool,
               showLeftVerticalRuler inShowLeftVerticalRuler : Bool,
               showRightVerticalRuler inShowRightVerticalRuler : Bool,
               backgroundView inBackgroundView : ((BackgroundViewContext) -> any View)?,
               leftVerticalRulerView : @escaping (CanariVerticalRulerViewContext) -> any View,
               topHorizontalRulerView : @escaping (CanariHorizontalRulerViewContext) -> any View,
               rightVerticalRulerView : @escaping (CanariVerticalRulerViewContext) -> any View,
               bottomHorizontalRulerView : @escaping (CanariHorizontalRulerViewContext) -> any View,
               drawCanvasBackGround : @escaping (_ ioContext : inout GraphicsContext) -> Void,
               drawCanvasOverlay : @escaping (_ ioContext : inout GraphicsContext) -> Void,
               droppedFilesHandler : (([Data], CanariPoint) -> Void)?,
               ) {
    self.zoomValues = zoomValues
    self.canvasSize = canvasSize
    self.margins = margins
    self.rulerSize = inRulerSize
    self.showTopHorizontalRuler = inShowTopHorizontalRuler
    self.showLeftVerticalRuler = inShowLeftVerticalRuler
    self.showBottomHorizontalRuler = inShowBottomHorizontalRuler
    self.showRightVerticalRuler = inShowRightVerticalRuler
    self.magneticGrid = magneticGrid
    self.rulerBackColor = rulerBackColor
    self.backgroundView = inBackgroundView
    self.leftVerticalRulerView = leftVerticalRulerView
    self.topHorizontalRulerView = topHorizontalRulerView
    self.rightVerticalRulerView = rightVerticalRulerView
    self.bottomHorizontalRulerView = bottomHorizontalRulerView
    self.drawCanvasBackGround = drawCanvasBackGround
    self.drawCanvasOverlay = drawCanvasOverlay
    self.droppedFilesHandler = droppedFilesHandler
    self.contentSizeWithMargins = CanariSize (
      width: margins.left + canvasSize.width + margins.right,
      height: margins.bottom + canvasSize.height + margins.top
    )
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var topHorizontalRulerHeight : CanariLength {
    self.showTopHorizontalRuler ? self.rulerSize.height : .zero
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var bottomHorizontalRulerHeight : CanariLength {
    self.showBottomHorizontalRuler ? self.rulerSize.height : .zero
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var leftVerticalRulerWidth : CanariLength {
    self.showLeftVerticalRuler ? self.rulerSize.width : .zero
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var rightVerticalRulerWidth : CanariLength {
    self.showRightVerticalRuler ? self.rulerSize.width : .zero
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
