//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 15/11/2024.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct CanariPointView : View {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private let mPoint : CanariPoint
  private let mUnit : CanariLength.Unit
  private let mFractionDigits : Int

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (point inCanariPoint : CanariPoint,
               unit inUnit : CanariLength.Unit = .cm,
               fractionDigits inFractionDigits : Int) {
    self.mPoint = inCanariPoint
    self.mUnit = inUnit
    self.mFractionDigits = inFractionDigits
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var body : some View {
    LabeledContent (
      content: {
        Text (self.mPoint.x.string (in: self.mUnit, fractionDigits: self.mFractionDigits))
      },
      label: { Text ("X") }
    )
    LabeledContent (
      content: {
        Text (self.mPoint.y.string (in: self.mUnit, fractionDigits: self.mFractionDigits))
      },
      label: { Text ("Y") }
    )
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
