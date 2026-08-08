//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 29/03/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct CanariAnchoredLayout : Layout {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private let mLocationX : CGFloat
  private let mLocationY : CGFloat
  private let mAnchor : UnitPoint

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (location inLocation : CanariPoint,
               anchor inAnchor : UnitPoint) {
    self.mLocationX = inLocation.x.pxValue
    self.mLocationY = inLocation.y.pxValue
    self.mAnchor = inAnchor
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (x inX : CanariLength,
               y inY : CanariLength,
               anchor inAnchor : UnitPoint) {
    self.mLocationX = inX.pxValue
    self.mLocationY = inY.pxValue
    self.mAnchor = inAnchor
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func sizeThatFits (proposal inProposal : ProposedViewSize,
                            subviews: Subviews,
                            cache: inout ()) -> CGSize {
    return inProposal.replacingUnspecifiedDimensions ()
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func placeSubviews (in inBounds : CGRect,
                             proposal inProposal : ProposedViewSize,
                             subviews inSubviews : Subviews,
                             cache: inout ()) {
    let locationInBounds = CGPoint (
      x: self.mLocationX + inBounds.origin.x,
      y: self.mLocationY + inBounds.origin.y
    )
    for view in inSubviews {
      view.place (
        at: locationInBounds,
        anchor: self.mAnchor,
        proposal: inProposal
      )
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
