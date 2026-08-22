//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 01/09/2025.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

private let MAIN_UNIT = CanariLength.inch (1)
private let MAIN_UNIT_STRING = "inch"

//--------------------------------------------------------------------------------------------------

public struct CanariRightVerticalRulerView_inch : View {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private let mContext : VerticalRulerViewContext
  private let mBackColor : Color
  private let mArray_cm : [IndexAndY]
  private let mArray_5mm : [CanariLength]
  private let mArray_mm : [CanariLength]

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (context inContext : VerticalRulerViewContext,
               backColor inBackColor : Color) {
    self.mContext = inContext
    self.mBackColor = inBackColor
    var cmArray = [IndexAndY] ()
    var xMMArray = [CanariLength] ()
    var x5MMArray = [CanariLength] ()
    if self.mContext.rulerSize.width > .zero {
      let startY = inContext.contentHeight - inContext.bottomMargin - inContext.scrollY - (inContext.rulerSize.height + inContext.originOffsetY) / inContext.scale
      let startY_mm = Int (startY / MAIN_UNIT * 10.0)
      var y = (inContext.contentHeight - inContext.bottomMargin - Double (startY_mm) * MAIN_UNIT / 10.0 - inContext.scrollY) * inContext.scale + inContext.originOffsetY
      var idy = startY_mm
      while y >= .zero {
        if (idy % 10) == 0 {
          cmArray.append (IndexAndY (index: idy / 10, y: y))
        }else if (idy % 5) == 0 {
          x5MMArray.append (y)
        }else if self.mContext.scale > 0.5 {
          xMMArray.append (y)
        }
        y -= MAIN_UNIT * inContext.scale / 10.0
        idy += 1
      }
    }
    self.mArray_cm = cmArray
    self.mArray_5mm = x5MMArray
    self.mArray_mm = xMMArray
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private struct IndexAndY : Hashable {
    let index : Int
    let y : CanariLength
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Utiliser ce body pour visualiser le rectangle du ruler
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

//  @ViewBuilder public var body : some View {
//    Rectangle ().fill (.red)
//  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @ViewBuilder public var body : some View {
    if self.mContext.rulerSize.width <= .zero {
      Spacer ()
    }else{
      Canvas { context, size in
        enterTracing ("right.vertical.ruler.view.body") ; defer { exitTracing ("right.vertical.ruler.view.body") }
        var path = CanariPath ()
        for indexAndY in self.mArray_cm {
           path.addMove (toX: .zero, toY: indexAndY.y)
           path.addLine (toX: 5.0 * self.mContext.rulerSize.width / 12.0, toY: indexAndY.y)
        }
        for y in self.mArray_mm {
           path.addMove (toX: .zero, toY: y)
           path.addLine (toX: 2.0 * self.mContext.rulerSize.width / 12.0, toY: y)
        }
        for y in self.mArray_5mm {
           path.addMove (toX: .zero, toY: y)
           path.addLine (toX: 4.0 * self.mContext.rulerSize.width / 12.0, toY: y)
        }
        context.stroke (path, with: .color (.gray), lineWidth: .px (1))
        path = CanariPath ()
        path.addMove (toX: .zero, toY: .zero)
        path.addLine (toX: .zero, toY: self.mContext.rulerSize.height)
        context.stroke (path, with: .color (.black), lineWidth: .px (1))
        if let hy = self.mContext.hoverLocationY {
          var path = CanariPath ()
          let y = (self.mContext.contentHeight - self.mContext.bottomMargin - hy - self.mContext.scrollY) * self.mContext.scale + self.mContext.originOffsetY
          path.addMove (toX: .zero, toY: y)
          path.addLine (toX: self.mContext.rulerSize.width, toY: y)
          context.stroke (path, with: .color (.black), lineWidth: .px (1))
        }
      }
      .overlay {
        ForEach (self.mArray_cm, id: \.self) { indexAndY in
          if self.mContext.scale > 0.5 {
            Text ("\(indexAndY.index)").font (.system (size: 9.0))
            .frame (maxWidth: .infinity, alignment: .trailing)
            .position (x: self.mContext.rulerSize.width / 2.0, y: indexAndY.y)
          }else if self.mContext.scale > 0.25, (indexAndY.index % 2) == 0 {
            Text ("\(indexAndY.index)").font (.system (size: 9.0))
            .frame (maxWidth: .infinity, alignment: .trailing)
            .position (x: self.mContext.rulerSize.width / 2.0, y: indexAndY.y)
          }else if (indexAndY.index % 4) == 0 {
            Text ("\(indexAndY.index)").font (.system (size: 9.0))
            .frame (maxWidth: .infinity, alignment: .trailing)
            .position (x: self.mContext.rulerSize.width / 2.0, y: indexAndY.y)
          }
        }
        CanariAnchoredLayout (x: self.mContext.rulerSize.width / 2.0,
                              y: .zero,
                              anchor: .top) {
          Text (MAIN_UNIT_STRING)
          .background (self.mBackColor)
          .font (.system (size: 9.0))
        }
        CanariAnchoredLayout (x: self.mContext.rulerSize.width / 2.0,
                              y: self.mContext.rulerSize.height,
                              anchor: .bottom) {
          Text (MAIN_UNIT_STRING)
          .background (self.mBackColor)
          .font (.system (size: 9.0))
        }
      }
      .background (self.mBackColor)
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
