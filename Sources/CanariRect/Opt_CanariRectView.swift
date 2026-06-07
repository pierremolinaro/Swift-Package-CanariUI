//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 06/06/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct Opt_CanariRectView : View {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private let mRect : CanariRect?
  private let mUnit : CanariLength.Unit
  private let mFractionDigits : Int

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (rect inCanariRect : CanariRect?,
               unit inUnit : CanariLength.Unit = .cm,
               fractionDigits inFractionDigits : Int = 2) {
    self.mRect = inCanariRect
    self.mUnit = inUnit
    self.mFractionDigits = inFractionDigits
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var body : some View {
    LabeledContent (
      content: {
        Opt_Text (self.mRect?.minX.string (in: self.mUnit, fractionDigits: self.mFractionDigits))
      },
      label: { Text ("Left") }
    )
    LabeledContent (
      content: {
        Opt_Text (self.mRect?.minY.string (in: self.mUnit, fractionDigits: self.mFractionDigits))
      },
      label: { Text ("Bottom") }
    )
    LabeledContent (
      content: {
        Opt_Text (self.mRect?.width.string (in: self.mUnit, fractionDigits: self.mFractionDigits))
      },
      label: { Text ("Width") }
    )
    LabeledContent (
      content: {
        Opt_Text (self.mRect?.height.string (in: self.mUnit, fractionDigits: self.mFractionDigits))
      },
      label: { Text ("Height") }
    )
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
