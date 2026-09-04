//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 17/09/2025.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct CanariGridView : View {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private let mStep : CanariLength
  private let mContext : BackgroundViewContext
  private let mXArray : [CanariLength]
  private let mYArray : [CanariLength]

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (context inContext : BackgroundViewContext,
               step inStep : CanariLength) {
    self.mContext = inContext
    self.mStep = inStep
  //--- X array
    let xStart = Int ((self.mContext.margins.left / inStep).rounded(.up))
    var xArray = [CanariLength] ()
    var x = inContext.margins.left - inStep * xStart
    while x <= inContext.contentSizeWithMargins.width {
      xArray.append (x)
      x += inStep
    }
    self.mXArray = xArray
  //--- Y array
    var yArray = [CanariLength] ()
    let yStart = Int ((self.mContext.margins.bottom / inStep).rounded(.up))
    var y = inContext.margins.bottom - inStep * yStart
    while y <= inContext.contentSizeWithMargins.height {
      yArray.append (y)
      y += inStep
    }
    self.mYArray = yArray
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func displayGrid (_ ioContext : inout GraphicsContext,
                            _ inColor : Color) {
    var path = CanariPath ()
    for yy in self.mYArray {
      let y = yy * self.mContext.canvasScale
      path.addMove (toX: .zero, toY: y)
      path.addLine (toX: self.mContext.contentSizeWithMargins.width * self.mContext.canvasScale, toY: y)
    }
    for xx in self.mXArray {
      let x = xx * self.mContext.canvasScale
      path.addMove (toX: x, toY: .zero)
      path.addLine (toX: x, toY: self.mContext.contentSizeWithMargins.height * self.mContext.canvasScale)
    }
    ioContext.stroke (path, with: .color (inColor), lineWidth: .pt (1))
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var body : some View {
    Canvas { context, size in
      enterTracing ("grid.view.canvas") ; defer { exitTracing ("grid.view.canvas") }
    //--- Appliquer une transformation manuelle
      context.translateBy (x: 0, y: size.height)
      context.scaleBy (x: 1, y: -1)
    //--- Dessiner la grille
      self.displayGrid (&context, .gray.opacity (0.5))
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
