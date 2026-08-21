//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 17/09/2025.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct CanariGridView_100mils : View {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private let mContext : BackgroundViewContext
  private let mXArray_100mils : [IndexAndLength]
  private let mYArray_100mils : [IndexAndLength]
  private let mXArray_10mils : [CanariLength]
  private let mYArray_10mils : [CanariLength]
  private let mXArray_50mils : [CanariLength]
  private let mYArray_50mils : [CanariLength]

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (context inContext : BackgroundViewContext) {
    self.mContext = inContext
  //--- 50 mils and 10 mils arraies
    var xArray_10mils = [CanariLength] ()
    var yArray_10mils = [CanariLength] ()
    var xArray_50mils = [CanariLength] ()
    var yArray_50mils = [CanariLength] ()
    let xStart10mils = Int (self.mContext.margins.left.inchValue.rounded(.up)) * 100
    let yStart10mils = Int (self.mContext.margins.bottom.inchValue.rounded(.up)) * 100
    var x = self.mContext.margins.left - .mil (xStart10mils * 10)
    var idx = -xStart10mils * 10
    while x <= (inContext.contentSizeWithMargins.width + inContext.overWidth) {
      if (idx % 5) == 0 {
        xArray_50mils.append (x)
      }else if inContext.canvasScale > 0.5 {
        xArray_10mils.append (x)
      }
      x += .mil (10)
      idx += 1
    }
    var y = inContext.margins.bottom - .mil (yStart10mils * 10)
    idx = -yStart10mils * 10
    while y <= inContext.contentSizeWithMargins.height {
      if (idx % 5) == 0 {
        yArray_50mils.append (y)
      }else if inContext.canvasScale > 0.5 {
        yArray_10mils.append (y)
      }
      y += .mil (10)
      idx += 1
    }
    self.mXArray_10mils = xArray_10mils
    self.mYArray_10mils = yArray_10mils
    self.mXArray_50mils = xArray_50mils
    self.mYArray_50mils = yArray_50mils
  //--- inch arraies
    let xStart100mils = Int (self.mContext.margins.left.inchValue.rounded(.up)) * 10
    let yStart100mils = Int (self.mContext.margins.bottom.inchValue.rounded(.up)) * 10
    var xArray_100mils = [IndexAndLength] ()
    var yArray_100mils = [IndexAndLength] ()
    x = inContext.margins.left - .mil (xStart100mils * 100)
    idx = -xStart100mils
    while x <= inContext.contentSizeWithMargins.width {
      xArray_100mils.append (IndexAndLength (idx: idx, f: x))
      x += .mil (100)
      idx += 1
    }
    y = inContext.margins.bottom - .mil (yStart100mils * 100)
    idx = -yStart100mils
    while y <= inContext.contentSizeWithMargins.height {
      yArray_100mils.append (IndexAndLength (idx: idx, f: y))
      y += .mil (100)
      idx += 1
    }
    self.mXArray_100mils = xArray_100mils
    self.mYArray_100mils = yArray_100mils
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private struct IndexAndLength : Hashable {
    let idx : Int
    let f : CanariLength
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func display_10mils_grid (_ ioContext : inout GraphicsContext,
                                    _ inColor : Color) {
    var path = CanariPath ()
    for y in self.mYArray_10mils {
      path.addMove (toX: .zero, toY: y * self.mContext.canvasScale)
      path.addLine (toX: self.mContext.contentSizeWithMargins.width * self.mContext.canvasScale, toY: y * self.mContext.canvasScale)
    }
    for x in self.mXArray_10mils {
      path.addMove (toX: x * self.mContext.canvasScale, toY: .zero)
      path.addLine (toX: x * self.mContext.canvasScale, toY: self.mContext.contentSizeWithMargins.height * self.mContext.canvasScale)
    }
    ioContext.stroke (path, with: .color (inColor), lineWidth: .px (1))
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func display_50mils_grid (_ ioContext : inout GraphicsContext,
                                    _ inColor : Color) {
    var path = CanariPath ()
    for y in self.mYArray_50mils {
      path.addMove (toX: .zero, toY: y * self.mContext.canvasScale)
      path.addLine (toX: self.mContext.contentSizeWithMargins.width * self.mContext.canvasScale, toY: y * self.mContext.canvasScale)
    }
    for x in self.mXArray_50mils {
      path.addMove (toX: x * self.mContext.canvasScale, toY: .zero)
      path.addLine (toX: x * self.mContext.canvasScale, toY: self.mContext.contentSizeWithMargins.height * self.mContext.canvasScale)
    }
    ioContext.stroke (path, with: .color (inColor), lineWidth: .px (1))
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func display_100mils_grid (_ ioContext : inout GraphicsContext,
                                     _ inColor : Color) {
    var path = CanariPath ()
    for indexAndFloat in self.mYArray_100mils {
      let y = indexAndFloat.f * self.mContext.canvasScale
      path.addMove (toX: .zero, toY: y)
      path.addLine (toX: self.mContext.contentSizeWithMargins.width * self.mContext.canvasScale, toY: y)
    }
    for indexAndFloat in self.mXArray_100mils {
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
      self.display_10mils_grid (&context, .gray.opacity (0.25))
      self.display_50mils_grid (&context, .gray.opacity (0.50))
      self.display_100mils_grid (&context, .gray)
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
    ForEach (self.mYArray_100mils, id: \.self) { indexAndFloat in
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
    ForEach (self.mXArray_100mils, id: \.self) { indexAndFloat in
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
