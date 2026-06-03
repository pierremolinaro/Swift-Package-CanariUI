//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 29/03/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct RulerDisplayDescriptor {
  private let rulerSize : CanariSize
  private let showTopHorizontalRuler : Bool
  private let showBottomHorizontalRuler : Bool
  private let showLeftVerticalRuler : Bool
  private let showRightVerticalRuler : Bool

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (rulerSize inRulerSize : CanariSize,
               showTopHorizontalRuler inShowTopHorizontalRuler : Bool,
               showBottomHorizontalRuler inShowBottomHorizontalRuler : Bool,
               showLeftVerticalRuler inShowLeftVerticalRuler : Bool,
               showRightVerticalRuler inShowRightVerticalRuler : Bool) {
    self.rulerSize = inRulerSize
    self.showTopHorizontalRuler = inShowTopHorizontalRuler
    self.showLeftVerticalRuler = inShowLeftVerticalRuler
    self.showBottomHorizontalRuler = inShowBottomHorizontalRuler
    self.showRightVerticalRuler = inShowRightVerticalRuler
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var topHorizontalRulerHeight : CanariLength {
    self.showTopHorizontalRuler ? self.rulerSize.height : .zero
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var bottomHorizontalRulerHeight : CanariLength {
    self.showBottomHorizontalRuler ? self.rulerSize.height : .zero
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var leftVerticalRulerWidth : CanariLength {
    self.showLeftVerticalRuler ? self.rulerSize.width : .zero
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var rightVerticalRulerWidth : CanariLength {
    self.showRightVerticalRuler ? self.rulerSize.width : .zero
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------

