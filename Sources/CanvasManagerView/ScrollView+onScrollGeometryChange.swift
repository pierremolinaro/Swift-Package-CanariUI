//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 01/03/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public extension ScrollView {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @ViewBuilder func onScrollPositionChange (_ inScrollPositionBinding : Binding <CanariPoint>,
                                            _ inContentZoom : Double) -> some View {
    self.onScrollGeometryChange (
      for: CGPoint.self,
      of: { (value : ScrollGeometry) in
        CGPoint (
          x: value.contentOffset.x + value.contentInsets.leading,
          y: value.contentOffset.y + value.contentInsets.top
        )
      },
      action: { oldOffset, newOffset in
        if oldOffset != newOffset {
          inScrollPositionBinding.wrappedValue = CanariPoint (px: newOffset) / inContentZoom
        }
      }
    )
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
