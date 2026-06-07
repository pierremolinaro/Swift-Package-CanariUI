//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 06/06/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct Set_CanariPointView : View {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private let mPointSet : Set <CanariPoint>
  private let mUnit : CanariLength.Unit
  private let mFractionDigits : Int

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (pointSet inCanariPointSet : Set <CanariPoint>,
               unit inUnit : CanariLength.Unit = .cm,
               fractionDigits inFractionDigits : Int = 2) {
    self.mPointSet = inCanariPointSet
    self.mUnit = inUnit
    self.mFractionDigits = inFractionDigits
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var body : some View {
    LabeledContent (
      content: {
        Opt_Text (self.x?.string (in: self.mUnit, fractionDigits: self.mFractionDigits))
      },
      label: { Text ("X") }
    )
    LabeledContent (
      content: {
        Opt_Text (self.y?.string (in: self.mUnit, fractionDigits: self.mFractionDigits))
      },
      label: { Text ("Y") }
    )
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private var x : CanariLength? {
    var result : CanariLength? = nil
    for v in self.mPointSet {
      if let r = result {
        if v.x != r {
          return nil
        }
      }else{
        result = v.x
      }
    }
    return result
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private var y : CanariLength? {
    var result : CanariLength? = nil
    for v in self.mPointSet {
      if let r = result {
        if v.y != r {
          return nil
        }
      }else{
        result = v.y
      }
    }
    return result
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
