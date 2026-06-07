//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 06/06/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct Opt_CanariPointView : View {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private let mPoint : CanariPoint?
  private let mUnit : CanariLength.Unit
  private let mFractionDigits : Int

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (point inCanariPoint : CanariPoint?,
               unit inUnit : CanariLength.Unit = .cm,
               fractionDigits inFractionDigits : Int = 2) {
    self.mPoint = inCanariPoint
    self.mUnit = inUnit
    self.mFractionDigits = inFractionDigits
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var body : some View {
    LabeledContent (
      content: {
        Opt_Text (self.mPoint?.x.string (in: self.mUnit, fractionDigits: self.mFractionDigits))
      },
      label: { Text ("X") }
    )
    LabeledContent (
      content: {
        Opt_Text (self.mPoint?.y.string (in: self.mUnit, fractionDigits: self.mFractionDigits))
      },
      label: { Text ("Y") }
    )
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
