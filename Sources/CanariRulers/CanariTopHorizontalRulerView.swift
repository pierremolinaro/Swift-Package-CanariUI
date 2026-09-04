//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 17/09/2025.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct CanariTopHorizontalRulerView : View {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private let mDescriptor : CanariRulerUnitDescriptor
  private let mContext : CanariHorizontalRulerViewContext
  private let mBackColor : Color
  private let mArray_unit : [IndexAndX]
  private let mArray_halfUnit : [CanariLength]
  private let mArray_tenthUnit : [CanariLength]

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (context inContext : CanariHorizontalRulerViewContext,
               backColor inBackColor : Color,
               descriptor inDescriptor : CanariRulerUnitDescriptor) {
    self.mContext = inContext
    self.mBackColor = inBackColor
    self.mDescriptor = inDescriptor
  //--- Compute arraies
    var cmArray = [IndexAndX] ()
    var x5MMArray = [CanariLength] ()
    var xMMArray = [CanariLength] ()
    if self.mContext.rulerSize.height > .zero {
      let startX_tenthUnit = Int (inContext.visibleXmin * 10.0 / self.mDescriptor.mainUnitLength)
      let endX = inContext.visibleXmax - inContext.leftMargin // / inContext.scale
      let endX_tenthUnit = Int (endX * 10.0 / self.mDescriptor.mainUnitLength)
      var x = (Double (startX_tenthUnit) * self.mDescriptor.mainUnitLength / 10.0 + inContext.leftMargin - inContext.scrollX) * inContext.scale + inContext.originOffsetX
      var idx = startX_tenthUnit
      let xMax = (Double (endX_tenthUnit) * self.mDescriptor.mainUnitLength / 10.0 + inContext.leftMargin - inContext.scrollX) * inContext.scale + inContext.originOffsetX
      while x <= xMax {
        if (idx % 10) == 0 {
          cmArray.append (IndexAndX (idx: idx / 10, x: x))
        }else if (idx % 5) == 0 {
          x5MMArray.append (x)
        }else if self.mContext.scale > 0.5 {
          xMMArray.append (x)
        }
        x += self.mDescriptor.mainUnitLength * inContext.scale / 10.0
        idx += 1
      }
    }
    self.mArray_unit = cmArray
    self.mArray_halfUnit = x5MMArray
    self.mArray_tenthUnit = xMMArray
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
        enterTracing ("top.horizontal.ruler.view.canvas") ; defer { exitTracing ("top.horizontal.ruler.view.canvas") }
        var path = CanariPath ()
        for indexAndX in self.mArray_unit {
          path.addMove (toX: indexAndX.x, toY: self.mContext.rulerSize.height)
          path.addLine (toX: indexAndX.x, toY: self.mContext.rulerSize.height / 2.0)
        }
        for x in self.mArray_tenthUnit {
          path.addMove (toX: x, toY: self.mContext.rulerSize.height)
          path.addLine (toX: x, toY: self.mContext.rulerSize.height * 5.0 / 6.0)
        }
        for x in self.mArray_halfUnit {
          path.addMove (toX: x, toY: self.mContext.rulerSize.height)
          path.addLine (toX: x, toY: self.mContext.rulerSize.height * 2.0 / 3.0)
        }
        context.stroke (path, with: .color (.gray), lineWidth: .pt (1))
        path = CanariPath ()
        path.addMove (toX: .zero, toY: self.mContext.rulerSize.height)
        path.addLine (toX: self.mContext.contentWidth * self.mContext.scale, toY: self.mContext.rulerSize.height)
        context.stroke (path, with: .color (.black), lineWidth: .pt (1))
        if let hx = self.mContext.hoverLocationX {
          var path = CanariPath ()
          let x = (hx + self.mContext.leftMargin - self.mContext.scrollX) * self.mContext.scale + self.mContext.originOffsetX
          path.addMove (toX: x, toY: .zero)
          path.addLine (toX: x, toY: self.mContext.rulerSize.height)
          context.stroke (path, with: .color (.black), lineWidth: .pt (1))
        }
      }
      .overlay {
        ForEach (self.mArray_unit, id: \.self) { indexAndX in
          if self.mContext.scale > 0.5 {
            Text ("\(indexAndX.idx * self.mDescriptor.displayFactor)").font (.system (size: 9.0))
            .position (x: indexAndX.x, y: self.mContext.rulerSize.height / 4.0)
          }else if self.mContext.scale > 0.25, (indexAndX.idx % 2) == 0 {
            Text ("\(indexAndX.idx * self.mDescriptor.displayFactor)").font (.system (size: 9.0))
            .position (x: indexAndX.x, y: self.mContext.rulerSize.height / 4.0)
          }else if (indexAndX.idx % 4) == 0 {
            Text ("\(indexAndX.idx * self.mDescriptor.displayFactor)").font (.system (size: 9.0))
            .position (x: indexAndX.x, y: self.mContext.rulerSize.height / 4.0)
          }
        }
        CanariAnchoredLayout (x: self.mContext.rulerSize.width,
                              y: self.mContext.rulerSize.height / 4.0,
                              anchor: .trailing) {
          Text (self.mDescriptor.mainUnitString)
          .background (self.mBackColor)
          .font (.system (size: 9.0))
        }
        CanariAnchoredLayout (x: .zero,
                              y: self.mContext.rulerSize.height / 4.0,
                              anchor: .leading) {
          Text (self.mDescriptor.mainUnitString)
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
