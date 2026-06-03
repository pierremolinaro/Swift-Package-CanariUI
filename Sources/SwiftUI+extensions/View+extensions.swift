//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 21/02/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public extension View {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @inlinable func position (x inX : CanariLength = .zero,
                            y inY : CanariLength = .zero,
                            zoom inZoom : Double = 1.0) -> some View {
    self.position (x: inX.pxValue * inZoom, y: inY.pxValue * inZoom)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @inlinable func position (p inPoint : CanariPoint) -> some View {
    self.position (x: inPoint.x.pxValue, y: inPoint.y.pxValue)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @inlinable func frame (width inWidth : CanariLength,
                         height inHeight : CanariLength,
                         alignment: Alignment = .center) -> some View {
    self.frame (width: inWidth.pxValue, height: inHeight.pxValue, alignment: alignment)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func frame (size inSize : CanariSize,
              alignment: Alignment = .center) -> some View {
    self.frame (width: inSize.width.pxValue, height: inSize.height.pxValue, alignment: alignment)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
