//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 17/09/2025.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

private let MAIN_UNIT = CanariLength.cm (1)
private let MAIN_UNIT_STRING = "cm"

//--------------------------------------------------------------------------------------------------

public struct CanariBottomHorizontalRulerView_cm : View {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private let mContext : HorizontalRulerViewContext
  private let mBackColor : Color
  private let mArray_cm : [IndexAndX]
  private let mArray_5mm : [CanariLength]
  private let mArray_mm : [CanariLength]

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (context inContext : HorizontalRulerViewContext,
               backColor inBackColor : Color) {
    self.mContext = inContext
    self.mBackColor = inBackColor
  //--- Compute arraies
    var cmArray = [IndexAndX] ()
    var x5MMArray = [CanariLength] ()
    var xMMArray = [CanariLength] ()
    if self.mContext.rulerSize.height > .zero {
      let startX_mm = Int (inContext.visibleXmin * 10.0 / MAIN_UNIT)
      let endX   = inContext.visibleXmax - inContext.leftMargin / inContext.scale
      let endX_mm = Int (endX * 10.0 / MAIN_UNIT)
      var x = (Double (startX_mm) * MAIN_UNIT / 10.0 + inContext.leftMargin - inContext.scrollX) * inContext.scale + inContext.originOffsetX
      var idx = startX_mm
      let xMax = (Double (endX_mm) * MAIN_UNIT / 10.0 + inContext.leftMargin - inContext.scrollX) * inContext.scale + inContext.originOffsetX
      while x <= xMax {
        if (idx % 10) == 0 {
          cmArray.append (IndexAndX (idx: idx / 10, x: x))
        }else if (idx % 5) == 0 {
          x5MMArray.append (x)
        }else if self.mContext.scale > 0.5 {
          xMMArray.append (x)
        }
        x += MAIN_UNIT * inContext.scale / 10.0
       idx += 1
      }
    }
    self.mArray_cm = cmArray
    self.mArray_5mm = x5MMArray
    self.mArray_mm = xMMArray
  }
  
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private struct IndexAndX : Hashable {
    let idx : Int
    let x : CanariLength
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Utiliser ce body pour visualiser le rectangle du ruler
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

//  @ViewBuilder public var body : some View {
//    Rectangle ().fill (.red)
//  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @ViewBuilder public var body : some View {
    if self.mContext.rulerSize.height <= .zero {
      Spacer ()
    }else{
      Canvas { context, size in
        enterTracing ("bottom.horizontal.ruler.view.canvas") ; defer { exitTracing ("bottom.horizontal.ruler.view.canvas") }
        var path = CanariPath ()
        for indexAndX in self.mArray_cm {
           path.addMove (toX: indexAndX.x, toY: .zero)
           path.addLine (toX: indexAndX.x, toY: self.mContext.rulerSize.height / 2.0)
        }
        for x in self.mArray_mm {
           path.addMove (toX: x, toY: .zero)
           path.addLine (toX: x, toY: self.mContext.rulerSize.height / 6.0)
        }
        for x in self.mArray_5mm {
           path.addMove (toX: x, toY: .zero)
           path.addLine (toX: x, toY: self.mContext.rulerSize.height / 3.0)
        }
        context.stroke (path, with: .color (.gray), lineWidth: .px (1))
        path = CanariPath ()
        path.addMove (toX: .zero, toY: .zero)
        path.addLine (toX: self.mContext.contentWidth * self.mContext.scale, toY: .zero)
        context.stroke (path, with: .color (.black), lineWidth: .px (1))
        if let hx = self.mContext.hoverLocationX {
          var path = CanariPath ()
          let x = (hx + self.mContext.leftMargin - self.mContext.scrollX) * self.mContext.scale + self.mContext.originOffsetX
          path.addMove (toX: x, toY: .zero)
          path.addLine (toX: x, toY: self.mContext.rulerSize.height)
          context.stroke (path, with: .color (.black), lineWidth: .px (1))
        }
      }
      .overlay {
        ForEach (self.mArray_cm, id: \.self) { indexAndX in
          if self.mContext.scale > 0.5 {
            Text ("\(indexAndX.idx)").font (.system (size: 9.0))
            .position (x: indexAndX.x, y: 3.0 * self.mContext.rulerSize.height / 4.0)
          }else if self.mContext.scale > 0.25, (indexAndX.idx % 2) == 0 {
            Text ("\(indexAndX.idx)").font (.system (size: 9.0))
            .position (x: indexAndX.x, y: 3.0 * self.mContext.rulerSize.height / 4.0)
          }else if (indexAndX.idx % 4) == 0 {
            Text ("\(indexAndX.idx)").font (.system (size: 9.0))
            .position (x: indexAndX.x, y: 3.0 * self.mContext.rulerSize.height / 4.0)
          }
        }
        CanariAnchoredLayout (x: self.mContext.rulerSize.width,
                              y: 3.0 * self.mContext.rulerSize.height / 4.0,
                              anchor: .trailing) {
          Text (MAIN_UNIT_STRING)
          .background (self.mBackColor)
          .font (.system (size: 9.0))
        }
        CanariAnchoredLayout (x: .zero,
                              y: 3.0 * self.mContext.rulerSize.height / 4.0,
                              anchor: .leading) {
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
