//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 29/03/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

struct AnchoredPosition : Layout {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private let mLocationX : CGFloat
  private let mLocationY : CGFloat
  private let mAnchor : UnitPoint

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  init (location inLocation : CanariPoint, anchor inAnchor : UnitPoint) {
    self.mLocationX = inLocation.x.pxValue
    self.mLocationY = inLocation.y.pxValue
    self.mAnchor = inAnchor
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  init (x inX : CanariLength, y inY : CanariLength, anchor inAnchor : UnitPoint) {
    self.mLocationX = inX.pxValue
    self.mLocationY = inY.pxValue
    self.mAnchor = inAnchor
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func sizeThatFits (proposal: ProposedViewSize,
                     subviews: Subviews,
                     cache: inout ()) -> CGSize {
    return proposal.replacingUnspecifiedDimensions ()
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func placeSubviews (in bounds: CGRect,
                      proposal: ProposedViewSize,
                      subviews: Subviews,
                      cache: inout ()) {
    let locationInBounds = CGPoint(
      x: self.mLocationX + bounds.origin.x,
      y: self.mLocationY + bounds.origin.y
    )
    for view in subviews {
      view.place (
        at: locationInBounds,
        anchor: self.mAnchor,
        proposal: proposal
      )
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
