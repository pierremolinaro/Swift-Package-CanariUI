//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 17/09/2025.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct CanariGridView_inch : View {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private let mContext : BackgroundViewContext
  private let mXArray_in : [IndexAndLength]
  private let mYArray_in : [IndexAndLength]

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (context inContext : BackgroundViewContext) {
    self.mContext = inContext
    let xStartIN = Int (self.mContext.margins.left.inchValue.rounded(.up))
    let yStartIN = Int (self.mContext.margins.bottom.inchValue.rounded(.up))
  //--- inch arraies
    var xArray_in = [IndexAndLength] ()
    var yArray_in = [IndexAndLength] ()
    var x = inContext.margins.left - .inch (xStartIN)
    var idx = -xStartIN
    while x <= inContext.contentSizeWithMargins.width {
      xArray_in.append (IndexAndLength (idx: idx, f: x))
      x += .inch (1)
      idx += 1
    }
    var y = inContext.margins.bottom - .inch (yStartIN)
    idx = -yStartIN
    while y <= inContext.contentSizeWithMargins.height {
      yArray_in.append (IndexAndLength (idx: idx, f: y))
      y += .inch (1)
      idx += 1
    }
    self.mXArray_in = xArray_in
    self.mYArray_in = yArray_in
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private struct IndexAndLength : Hashable {
    let idx : Int
    let f : CanariLength
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func display_inch_grid (_ ioContext : inout GraphicsContext,
                                  _ inColor : Color) {
    var path = CanariPath ()
    for indexAndFloat in self.mYArray_in {
      let y = indexAndFloat.f * self.mContext.canvasScale
      path.addMove (toX: .zero, toY: y)
      path.addLine (toX: self.mContext.contentSizeWithMargins.width * self.mContext.canvasScale, toY: y)
    }
    for indexAndFloat in self.mXArray_in {
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
      self.display_inch_grid (&context, .gray)
    //--- Dessiner le rectangle
      let r = CanariRect (
        left: self.mContext.margins.left * self.mContext.canvasScale ,
        bottom: self.mContext.margins.bottom * self.mContext.canvasScale,
        width: (self.mContext.contentSizeWithMargins.width - self.mContext.margins.left - self.mContext.margins.right) * self.mContext.canvasScale,
        height: (self.mContext.contentSizeWithMargins.height - self.mContext.margins.top - self.mContext.margins.bottom) * self.mContext.canvasScale
      )
      let path = CanariPath (rect: r)
      context.stroke (path, with: .color (.black), lineWidth: .px (1))
    }
//    .overlay { self.displayDimensions () }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @ViewBuilder private func displayDimensions () -> some View {
    ForEach (self.mYArray_in, id: \.self) { indexAndFloat in
      if indexAndFloat.idx >= 0, indexAndFloat.idx <= Int ((self.mContext.contentSizeWithMargins.height - self.mContext.margins.top - self.mContext.margins.bottom).cmValue) {
        Text ("\(indexAndFloat.idx)")
        .position (
          x: self.mContext.margins.left - .mm (5),
          y: self.mContext.contentSizeWithMargins.height - indexAndFloat.f,
          scale: self.mContext.canvasScale
        )
        Text ("\(indexAndFloat.idx)")
        .position (
          x: self.mContext.contentSizeWithMargins.width - self.mContext.margins.right + .mm (5),
          y: self.mContext.contentSizeWithMargins.height - indexAndFloat.f,
          scale: self.mContext.canvasScale
        )
      }
    }
    ForEach (self.mXArray_in, id: \.self) { indexAndFloat in
      if indexAndFloat.idx >= 0, indexAndFloat.idx <= Int ((self.mContext.contentSizeWithMargins.width - self.mContext.margins.left - self.mContext.margins.right).cmValue) {
        Text ("\(indexAndFloat.idx)")
        .position (
          x: indexAndFloat.f,
          y: self.mContext.margins.top - .mm (5),
          scale: self.mContext.canvasScale
        )
        Text ("\(indexAndFloat.idx)")
        .position (
          x: indexAndFloat.f,
          y: self.mContext.contentSizeWithMargins.height - self.mContext.margins.bottom + .mm (5),
          scale: self.mContext.canvasScale
        )
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
