//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 17/09/2025.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct CanariGridView : View {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private let mStep : CanariLength
  private let mContext : BackgroundViewContext
  private let mXArray : [IndexAndLength]
  private let mYArray : [IndexAndLength]

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (context inContext : BackgroundViewContext,
               step inStep : CanariLength) {
    self.mContext = inContext
    self.mStep = inStep
  //--- cm arraies
    let xStartMM = Int ((self.mContext.margins.left / self.mStep).rounded(.up))
    let yStartMM = Int ((self.mContext.margins.bottom / self.mStep).rounded(.up))
    var xArray = [IndexAndLength] ()
    var yArray = [IndexAndLength] ()
    var x = inContext.margins.left - self.mStep * (xStartMM / 10)
    var idx = -xStartMM / 10
    while x <= inContext.contentSizeWithMargins.width {
      xArray.append (IndexAndLength (idx: idx, f: x))
      x += self.mStep
      idx += 1
    }
    var y = inContext.margins.bottom - self.mStep * (yStartMM / 10)
    idx = -yStartMM / 10
    while y <= inContext.contentSizeWithMargins.height {
      yArray.append (IndexAndLength (idx: idx, f: y))
      y += self.mStep
      idx += 1
    }
    self.mXArray = xArray
    self.mYArray = yArray
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private struct IndexAndLength : Hashable {
    let idx : Int
    let f : CanariLength
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func displayGrid (_ ioContext : inout GraphicsContext,
                            _ inColor : Color) {
    var path = CanariPath ()
    for indexAndFloat in self.mYArray {
      let y = indexAndFloat.f * self.mContext.canvasScale
      path.addMove (toX: .zero, toY: y)
      path.addLine (toX: self.mContext.contentSizeWithMargins.width * self.mContext.canvasScale, toY: y)
    }
    for indexAndFloat in self.mXArray {
      let x = indexAndFloat.f * self.mContext.canvasScale
      path.addMove (toX: x, toY: .zero)
      path.addLine (toX: x, toY: self.mContext.contentSizeWithMargins.height * self.mContext.canvasScale)
    }
    ioContext.stroke (path, with: .color (inColor), lineWidth: .px (1))
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
