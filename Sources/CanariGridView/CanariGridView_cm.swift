//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 17/09/2025.
//--------------------------------------------------------------------------------------------------

import SwiftUI
import CanariUI

//--------------------------------------------------------------------------------------------------

struct CanariGridView_cm : View {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private let mContext : BackgroundViewContext
  private let mXArray_cm : [IndexAndLength]
  private let mYArray_cm : [IndexAndLength]

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  init (context inContext : BackgroundViewContext) {
    self.mContext = inContext
  //--- cm arraies
    let xStartMM = Int (self.mContext.margins.left.mmValue.rounded(.up))
    let yStartMM = Int (self.mContext.margins.bottom.mmValue.rounded(.up))
    var xArray_cm = [IndexAndLength] ()
    var yArray_cm = [IndexAndLength] ()
    var x = inContext.margins.left - .mm ((xStartMM / 10) * 10)
    var idx = -xStartMM / 10
    while x <= inContext.contentSizeWithMargins.width {
      xArray_cm.append (IndexAndLength (idx: idx, f: x))
      x += .mm (10)
      idx += 1
    }
    var y = inContext.margins.bottom - .mm ((yStartMM / 10) * 10)
    idx = -yStartMM / 10
    while y <= inContext.contentSizeWithMargins.height {
      yArray_cm.append (IndexAndLength (idx: idx, f: y))
      y += .mm (10)
      idx += 1
    }
    self.mXArray_cm = xArray_cm
    self.mYArray_cm = yArray_cm
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private struct IndexAndLength : Hashable {
    let idx : Int
    let f : CanariLength
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func display_cm_grid (_ ioContext : inout GraphicsContext,
                                _ inColor : Color) {
    var path = CanariPath ()
    for indexAndFloat in self.mYArray_cm {
      let y = indexAndFloat.f * self.mContext.canvasScale
      path.addMove (toX: .zero, toY: y)
      path.addLine (toX: self.mContext.contentSizeWithMargins.width * self.mContext.canvasScale, toY: y)
    }
    for indexAndFloat in self.mXArray_cm {
      let x = indexAndFloat.f * self.mContext.canvasScale
      path.addMove (toX: x, toY: .zero)
      path.addLine (toX: x, toY: self.mContext.contentSizeWithMargins.height * self.mContext.canvasScale)
    }
    ioContext.stroke (path, with: .color (inColor), lineWidth: .px (1))
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  var body : some View {
    Canvas { context, size in
      enterTracing ("grid.view.canvas") ; defer { exitTracing ("grid.view.canvas") }
    //--- Appliquer une transformation manuelle
      context.translateBy (x: 0, y: size.height)
      context.scaleBy (x: 1, y: -1)
    //--- Dessiner la grille
      self.display_cm_grid (&context, .gray.opacity (0.5))
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
    ForEach (self.mYArray_cm, id: \.self) { indexAndFloat in
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
    ForEach (self.mXArray_cm, id: \.self) { indexAndFloat in
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
