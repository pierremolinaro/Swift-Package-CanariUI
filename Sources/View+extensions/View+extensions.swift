//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 21/02/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public extension View {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @inlinable func position (x inX : CanariLength = .zero,
                            y inY : CanariLength = .zero,
                            scale inScale : Double = 1.0) -> some View {
    self.position (x: inX.ptValue * inScale, y: inY.ptValue * inScale)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @inlinable func position (p inPoint : CanariPoint) -> some View {
    self.position (x: inPoint.x.ptValue, y: inPoint.y.ptValue)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @inlinable func frame (width inWidth : CanariLength,
                         height inHeight : CanariLength,
                         alignment: Alignment = .center) -> some View {
    self.frame (width: inWidth.ptValue, height: inHeight.ptValue, alignment: alignment)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func frame (size inSize : CanariSize,
              alignment: Alignment = .center) -> some View {
    self.frame (width: inSize.width.ptValue, height: inSize.height.ptValue, alignment: alignment)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
