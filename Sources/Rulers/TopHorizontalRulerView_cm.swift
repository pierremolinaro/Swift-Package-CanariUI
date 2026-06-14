//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 17/09/2025.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct TopHorizontalRulerView_cm : View {

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
    var cmArray = [IndexAndX] ()
    var x5MMArray = [CanariLength] ()
    var xMMArray = [CanariLength] ()
  //--- Compute arraies
    if self.mContext.rulerSize.height > .zero {
      let startX_mm = Int ((inContext.scrollX - inContext.leftMargin - inContext.originOffsetX / inContext.scale).mmValue)
      var x : CanariLength = (CanariLength.mm (startX_mm) + inContext.leftMargin - inContext.scrollX) * inContext.scale + inContext.originOffsetX
      var idx = startX_mm
  //    var s = "\(startX_mm) mm :"
      while x <= inContext.rulerSize.width {
        if (idx % 10) == 0 {
  //        s += " \(idx / 10)"
          cmArray.append (IndexAndX (idx: idx / 10, x: x))
        }else if (idx % 5) == 0 {
          x5MMArray.append (x)
        }else if self.mContext.scale > 0.5 {
          xMMArray.append (x)
        }
        x += .mm (1) * inContext.scale
        idx += 1
      }
    }
    self.mArray_cm = cmArray
    self.mArray_5mm = x5MMArray
    self.mArray_mm = xMMArray
//    print (s)
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
        for indexAndX in self.mArray_cm {
           path.move (toX: indexAndX.x, toY: self.mContext.rulerSize.height)
           path.addLine (toX: indexAndX.x, toY: self.mContext.rulerSize.height / 2.0)
        }
        for x in self.mArray_mm {
           path.move (toX: x, toY: self.mContext.rulerSize.height)
           path.addLine (toX: x, toY: self.mContext.rulerSize.height * 5.0 / 6.0)
        }
        for x in self.mArray_5mm {
           path.move (toX: x, toY: self.mContext.rulerSize.height)
           path.addLine (toX: x, toY: self.mContext.rulerSize.height * 2.0 / 3.0)
        }
        context.stroke (path, with: .color (.gray), lineWidth: .px (1))
        path = CanariPath ()
        path.move (toX: .zero, toY: self.mContext.rulerSize.height)
        path.addLine (toX: self.mContext.contentWidth * self.mContext.scale, toY: self.mContext.rulerSize.height)
        context.stroke (path, with: .color (.black), lineWidth: .px (1))
      //--- Hover location
       if let hx = self.mContext.hoverLocationX {
          var path = CanariPath ()
          let x = (hx + self.mContext.leftMargin - self.mContext.scrollX) * self.mContext.scale + self.mContext.originOffsetX
          path.move (toX: x, toY: .zero)
          path.addLine (toX: x, toY: self.mContext.rulerSize.height)
          context.stroke (path, with: .color (.black), lineWidth: .px (1))
        }
      }
      .overlay {
        ForEach (self.mArray_cm.dropLast ().dropFirst (), id: \.self) { indexAndX in
          if (self.mContext.scale > 0.5) || (indexAndX.idx % 2 == 0) {
            Text ("\(indexAndX.idx)").font (.system (size: self.mContext.rulerSize.height.pxValue * 0.4))
            .position (x: indexAndX.x, y: self.mContext.rulerSize.height / 4.0)
          }
        }
        AnchoredPosition (x: self.mContext.rulerSize.width, y: self.mContext.rulerSize.height / 4.0, anchor: .trailing) {
          Text ("cm")
          .font (.system (size: self.mContext.rulerSize.height.pxValue * 0.4))
        }
        AnchoredPosition (x: .zero, y: self.mContext.rulerSize.height / 4.0, anchor: .leading) {
          Text ("cm")
          .font (.system (size: self.mContext.rulerSize.height.pxValue * 0.4))
        }
      }
      .background (self.mBackColor)
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
