//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 29/03/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct CanariRulerDisplayDescriptor {
  private let rulerSize : CanariSize
  private let topHorizontalRuler : CanariTrit
  private let bottomHorizontalRuler : CanariTrit
  private let leftVerticalRuler : CanariTrit
  private let rightVerticalRuler : CanariTrit

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (rulerSize inRulerSize : CanariSize,
               topHorizontalRuler inTopHorizontalRuler : CanariTrit,
               bottomHorizontalRuler inBottomHorizontalRuler : CanariTrit,
               leftVerticalRuler inLeftVerticalRuler : CanariTrit,
               rightVerticalRuler inRightVerticalRuler : CanariTrit) {
    self.rulerSize = inRulerSize
    self.topHorizontalRuler = inTopHorizontalRuler
    self.leftVerticalRuler = inLeftVerticalRuler
    self.bottomHorizontalRuler = inBottomHorizontalRuler
    self.rightVerticalRuler = inRightVerticalRuler
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var topHorizontalRulerHeight : CanariLength {
    (self.topHorizontalRuler == .zero) ? .zero : self.rulerSize.height
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var bottomHorizontalRulerHeight : CanariLength {
    (self.bottomHorizontalRuler == .zero) ? .zero : self.rulerSize.height
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var leftVerticalRulerWidth : CanariLength {
    (self.leftVerticalRuler == .zero) ? .zero : self.rulerSize.width
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var rightVerticalRulerWidth : CanariLength {
    (self.rightVerticalRuler == .zero) ? .zero : self.rulerSize.width
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------

