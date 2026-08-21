//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 17/09/2025.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct CanariGridView_mm : View {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private let mContext : BackgroundViewContext
  private let mXArray_mm : [CanariLength]
  private let mYArray_mm : [CanariLength]
  private let mXArray_5mm : [CanariLength]
  private let mYArray_5mm : [CanariLength]
  private let mXArray_cm : [IndexAndLength]
  private let mYArray_cm : [IndexAndLength]

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (context inContext : BackgroundViewContext) {
    self.mContext = inContext
  //--- mm arraies
    var xArray_mm = [CanariLength] ()
    var yArray_mm = [CanariLength] ()
    var xArray_5mm = [CanariLength] ()
    var yArray_5mm = [CanariLength] ()

    let xStartMM = Int (self.mContext.margins.left.mmValue.rounded(.up))
    let yStartMM = Int (self.mContext.margins.bottom.mmValue.rounded(.up))
    var x = self.mContext.margins.left - .mm (xStartMM)
    var idx = -xStartMM
    while x <= (inContext.contentSizeWithMargins.width + inContext.overWidth) {
      if (idx % 5) == 0 {
        xArray_5mm.append (x)
      }else if inContext.canvasScale > 0.5 {
        xArray_mm.append (x)
      }
      x += .mm (1)
      idx += 1
    }
    var y = inContext.margins.bottom - .mm (yStartMM)
    idx = -yStartMM
    while y <= inContext.contentSizeWithMargins.height {
      if (idx % 5) == 0 {
        yArray_5mm.append (y)
      }else if inContext.canvasScale > 0.5 {
        yArray_mm.append (y)
      }
      y += .mm (1)
      idx += 1
    }
    self.mXArray_mm = xArray_mm
    self.mYArray_mm = yArray_mm
    self.mXArray_5mm = xArray_5mm
    self.mYArray_5mm = yArray_5mm
  //--- cm arraies
    var xArray_cm = [IndexAndLength] ()
    var yArray_cm = [IndexAndLength] ()
    x = inContext.margins.left - .mm ((xStartMM / 10) * 10)
    idx = -xStartMM / 10
    while x <= inContext.contentSizeWithMargins.width {
      xArray_cm.append (IndexAndLength (idx: idx, f: x))
      x += .mm (10)
      idx += 1
    }
    y = inContext.margins.bottom - .mm ((yStartMM / 10) * 10)
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

  private func display_mm_grid (_ ioContext : inout GraphicsContext) {
    var path = CanariPath ()
    for y in self.mYArray_mm {
      path.addMove (toX: .zero, toY: y * self.mContext.canvasScale)
      path.addLine (toX: self.mContext.contentSizeWithMargins.width * self.mContext.canvasScale, toY: y * self.mContext.canvasScale)
    }
    for x in self.mXArray_mm {
      path.addMove (toX: x * self.mContext.canvasScale, toY: .zero)
      path.addLine (toX: x * self.mContext.canvasScale, toY: self.mContext.contentSizeWithMargins.height * self.mContext.canvasScale)
    }
    ioContext.stroke (path, with: .color (.gray.opacity (0.25)), lineWidth: .px (1))
    path = CanariPath ()
    for y in self.mYArray_5mm {
      path.addMove (toX: .zero, toY: y * self.mContext.canvasScale)
      path.addLine (toX: self.mContext.contentSizeWithMargins.width * self.mContext.canvasScale, toY: y * self.mContext.canvasScale)
    }
    for x in self.mXArray_5mm {
      path.addMove (toX: x * self.mContext.canvasScale, toY: .zero)
      path.addLine (toX: x * self.mContext.canvasScale, toY: self.mContext.contentSizeWithMargins.height * self.mContext.canvasScale)
    }
    ioContext.stroke (path, with: .color (.gray.opacity (0.5)), lineWidth: .px (1))
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var body : some View {
    Canvas { context, size in
      enterTracing ("grid.view.canvas") ; defer { exitTracing ("grid.view.canvas") }
    //--- Appliquer une transformation manuelle
      context.translateBy (x: 0, y: size.height)
      context.scaleBy (x: 1, y: -1)
    //--- Dessiner la grille
      self.display_mm_grid (&context)
      self.display_cm_grid (&context, .gray)
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
