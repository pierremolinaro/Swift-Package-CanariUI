//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 06/06/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct Set_CanariSizeView : View {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private let mSizeSet : Set <CanariSize>
  private let mUnit : CanariLength.Unit
  private let mFractionDigits : Int

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (sizeSet inCanariSize : Set <CanariSize>,
               unit inUnit : CanariLength.Unit = .cm,
               fractionDigits inFractionDigits : Int = 2) {
    self.mSizeSet = inCanariSize
    self.mUnit = inUnit
    self.mFractionDigits = inFractionDigits
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var body : some View {
    LabeledContent (
      content: {
        Opt_Text (self.width?.string (in: self.mUnit, fractionDigits: self.mFractionDigits))
      },
      label: { Text ("Width") }
    )
    LabeledContent (
      content: {
        Opt_Text (self.height?.string (in: self.mUnit, fractionDigits: self.mFractionDigits))
      },
      label: { Text ("Height") }
    )
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private var width : CanariLength? {
    var result : CanariLength? = nil
    for rect in self.mSizeSet {
      if let r = result {
        if rect.width != r {
          return nil
        }
      }else{
        result = rect.width
      }
    }
    return result
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private var height : CanariLength? {
    var result : CanariLength? = nil
    for rect in self.mSizeSet {
      if let r = result {
        if rect.height != r {
          return nil
        }
      }else{
        result = rect.height
      }
    }
    return result
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
