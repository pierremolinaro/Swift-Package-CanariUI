//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 06/06/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct Opt_CanariSizeView : View {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private let mSize : CanariSize?
  private let mUnit : CanariLength.Unit
  private let mFractionDigits : Int

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (size inCanariSize : CanariSize?,
               unit inUnit : CanariLength.Unit = .cm,
               fractionDigits inFractionDigits : Int = 2) {
    self.mSize = inCanariSize
    self.mUnit = inUnit
    self.mFractionDigits = inFractionDigits
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var body : some View {
    LabeledContent (
      content: {
        Opt_Text (self.mSize?.width.string (in: self.mUnit, fractionDigits: self.mFractionDigits))
      },
      label: { Text ("Width") }
    )
    LabeledContent (
      content: {
        Opt_Text (self.mSize?.height.string (in: self.mUnit, fractionDigits: self.mFractionDigits))
      },
      label: { Text ("Height") }
    )
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
