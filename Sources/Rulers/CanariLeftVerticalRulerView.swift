//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 01/09/2025.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct CanariLeftVerticalRulerView : View {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private let mUnit : CanariRulerUnit
  private let mContext : VerticalRulerViewContext
  private let mBackColor : Color
  private let array_cm : [IndexAndY]
  private let array_5mm : [CanariLength]
  private let array_mm : [CanariLength]

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (context inContext : VerticalRulerViewContext,
               unit inUnit : CanariRulerUnit,
               backColor inBackColor : Color) {
    self.mUnit = inUnit
    self.mContext = inContext
    self.mBackColor = inBackColor
    var cmArray = [IndexAndY] ()
    var xMMArray = [CanariLength] ()
    var x5MMArray = [CanariLength] ()
    if self.mContext.rulerSize.width > .zero {
      let startY = inContext.contentHeight - inContext.bottomMargin - inContext.scrollY - (inContext.rulerSize.height + inContext.originOffsetY) / inContext.scale
      let startY_mm = Int (inUnit.doubleValue (for: startY) * 10.0)
      var y = (inContext.contentHeight - inContext.bottomMargin - Double (startY_mm) * inUnit.length / 10.0 - inContext.scrollY) * inContext.scale + inContext.originOffsetY
      var idx = startY_mm
      while y >= .zero {
        if (idx % 10) == 0 {
          cmArray.append (IndexAndY (idx: idx / 10, y: y))
        }else if (idx % 5) == 0 {
          x5MMArray.append (y)
        }else if self.mContext.scale > 0.5 {
          xMMArray.append (y)
        }
        y -= self.mUnit.length * inContext.scale / 10.0
        idx += 1
      }
    }
    self.array_cm = cmArray
    self.array_5mm = x5MMArray
    self.array_mm = xMMArray
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private struct IndexAndY : Hashable {
    let idx : Int
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
        enterTracing ("left.vertical.ruler.view.body") ; defer { exitTracing ("left.vertical.ruler.view.body") }
        var path = CanariPath ()
        for indexAndY in self.array_cm {
           path.addMove (toX: 7.0 * self.mContext.rulerSize.width / 12.0, toY: indexAndY.y)
           path.addLine (toX: self.mContext.rulerSize.width, toY: indexAndY.y)
        }
        for y in self.array_5mm {
           path.addMove (toX: 9.0 * self.mContext.rulerSize.width / 12.0, toY: y)
           path.addLine (toX: self.mContext.rulerSize.width, toY: y)
        }
        for y in self.array_mm {
           path.addMove (toX: 10.0 * self.mContext.rulerSize.width / 12.0, toY: y)
           path.addLine (toX: self.mContext.rulerSize.width, toY: y)
        }
        context.stroke (path, with: .color (.gray), lineWidth: .px (1))
        path = CanariPath ()
        path.addMove (toX: self.mContext.rulerSize.width, toY: .zero)
        path.addLine (toX: self.mContext.rulerSize.width, toY: self.mContext.rulerSize.height)
        context.stroke (path, with: .color (.black), lineWidth: .px (1))
        if let hy = self.mContext.hoverLocationY {
          var path = CanariPath ()
          let y = (self.mContext.contentHeight - self.mContext.bottomMargin - hy - self.mContext.scrollY) * self.mContext.scale + self.mContext.originOffsetY
          path.addMove (toX: .zero, toY: y)
          path.addLine (toX: self.mContext.rulerSize.width, toY: y)
          context.stroke (path, with: .color (.black), lineWidth: .px (1))
        }
      }
      .overlay { // X par rapprt au centre
        ForEach (self.array_cm, id: \.self) { indexAndY in
          if self.mContext.scale > 0.5 {
            Text ("\(indexAndY.idx)").font (.system (size: self.mContext.rulerSize.width.pxValue * 0.4))
            .frame (maxWidth: .infinity, alignment: .trailing)
            .position (x: self.mContext.rulerSize.width / 12.0 - .px (1), y: indexAndY.y)
          }else if self.mContext.scale > 0.25, indexAndY.idx % 2 == 0 {
            Text ("\(indexAndY.idx)").font (.system (size: self.mContext.rulerSize.width.pxValue * 0.4))
            .frame (maxWidth: .infinity, alignment: .trailing)
            .position (x: self.mContext.rulerSize.width / 12.0 - .px (1), y: indexAndY.y)
          }else if indexAndY.idx % 4 == 0 {
            Text ("\(indexAndY.idx)").font (.system (size: self.mContext.rulerSize.width.pxValue * 0.4))
            .frame (maxWidth: .infinity, alignment: .trailing)
            .position (x: self.mContext.rulerSize.width / 12.0 - .px (1), y: indexAndY.y)
          }
        }
        CanariAnchoredLayout (x: self.mContext.rulerSize.width / 2.0,
                              y: .zero,
                              anchor: .top) {
          Text (self.mUnit.string)
          .background (self.mBackColor)
          .font (.system (size: self.mContext.rulerSize.width.pxValue * 0.4))
        }
        CanariAnchoredLayout (x: self.mContext.rulerSize.width / 2.0,
                              y: self.mContext.rulerSize.height,
                              anchor: .bottom) {
          Text (self.mUnit.string)
          .background (self.mBackColor)
          .font (.system (size: self.mContext.rulerSize.width.pxValue * 0.4))
        }
      }
      .background (self.mBackColor)
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
