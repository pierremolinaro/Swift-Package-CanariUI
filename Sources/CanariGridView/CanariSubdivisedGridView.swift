//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 17/09/2025.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct CanariSubdivisedGridView : View {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private let mStep : CanariLength
  private let mContext : BackgroundViewContext
  private let mXArray_mm : [CanariLength]
  private let mYArray_mm : [CanariLength]
  private let mXArray_5mm : [CanariLength]
  private let mYArray_5mm : [CanariLength]
  private let mXArray_cm : [CanariLength]
  private let mYArray_cm : [CanariLength]

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (context inContext : BackgroundViewContext,
               step inStep : CanariLength) {
    self.mContext = inContext
    self.mStep = inStep
    let subStep = inStep / 10
  //--- X arraies
    var xArray_cm = [CanariLength] ()
    var xArray_mm = [CanariLength] ()
    var xArray_5mm = [CanariLength] ()

    let xStartMM = Int ((self.mContext.margins.left / subStep).rounded(.up))
    var x = self.mContext.margins.left - subStep * xStartMM
    var idx = -xStartMM
    while x <= (inContext.contentSizeWithMargins.width + inContext.overWidth) {
      if (idx % 10) == 0 {
        xArray_cm.append (x)
      }else if (idx % 5) == 0 {
        xArray_5mm.append (x)
      }else{
        xArray_mm.append (x)
      }
      x += subStep
      idx += 1
    }
    self.mXArray_mm = xArray_mm
    self.mXArray_5mm = xArray_5mm
    self.mXArray_cm = xArray_cm
  //---
    var yArray_cm = [CanariLength] ()
    var yArray_5mm = [CanariLength] ()
    var yArray_mm = [CanariLength] ()
    let yStartMM = Int ((self.mContext.margins.bottom / subStep).rounded(.up))
    var y = inContext.margins.bottom - subStep * yStartMM
    idx = -yStartMM
    while y <= inContext.contentSizeWithMargins.height {
      if (idx % 10) == 0 {
        yArray_cm.append (y)
      }else if (idx % 5) == 0 {
        yArray_5mm.append (y)
      }else{
        yArray_mm.append (y)
      }
      y += subStep
      idx += 1
    }
    self.mYArray_cm = yArray_cm
    self.mYArray_mm = yArray_mm
    self.mYArray_5mm = yArray_5mm
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func display_cm_grid (_ ioContext : inout GraphicsContext) {
    var path = CanariPath ()
    for y in self.mYArray_cm {
      path.addMove (toX: .zero, toY: y * self.mContext.canvasScale)
      path.addLine (toX: self.mContext.contentSizeWithMargins.width * self.mContext.canvasScale, toY: y * self.mContext.canvasScale)
    }
    for x in self.mXArray_cm {
      path.addMove (toX: x * self.mContext.canvasScale, toY: .zero)
      path.addLine (toX: x * self.mContext.canvasScale, toY: self.mContext.contentSizeWithMargins.height * self.mContext.canvasScale)
    }
    ioContext.stroke (path, with: .color (.gray), lineWidth: .pt (1))
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
    ioContext.stroke (path, with: .color (.gray.opacity (0.25)), lineWidth: .pt (1))
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func display_5mm_grid (_ ioContext : inout GraphicsContext) {
    var path = CanariPath ()
    for y in self.mYArray_5mm {
      path.addMove (toX: .zero, toY: y * self.mContext.canvasScale)
      path.addLine (toX: self.mContext.contentSizeWithMargins.width * self.mContext.canvasScale, toY: y * self.mContext.canvasScale)
    }
    for x in self.mXArray_5mm {
      path.addMove (toX: x * self.mContext.canvasScale, toY: .zero)
      path.addLine (toX: x * self.mContext.canvasScale, toY: self.mContext.contentSizeWithMargins.height * self.mContext.canvasScale)
    }
    ioContext.stroke (path, with: .color (.gray.opacity (0.5)), lineWidth: .pt (1))
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
      self.display_5mm_grid (&context)
      self.display_cm_grid (&context)
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
