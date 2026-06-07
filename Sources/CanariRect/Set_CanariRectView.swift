//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 06/06/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct Set_CanariRectView : View {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private let mRectSet : Set <CanariRect>
  private let mUnit : CanariLength.Unit
  private let mFractionDigits : Int

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (rectSet inCanariRectSet : Set <CanariRect>,
               unit inUnit : CanariLength.Unit = .cm,
               fractionDigits inFractionDigits : Int = 2) {
    self.mRectSet = inCanariRectSet
    self.mUnit = inUnit
    self.mFractionDigits = inFractionDigits
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var body : some View {
    LabeledContent (
      content: {
        Opt_Text (self.minX?.string (in: self.mUnit, fractionDigits: self.mFractionDigits))
      },
      label: { Text ("Left") }
    )
    LabeledContent (
      content: {
        Opt_Text (self.minY?.string (in: self.mUnit, fractionDigits: self.mFractionDigits))
      },
      label: { Text ("Bottom") }
    )
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

  private var minX : CanariLength? {
    var result : CanariLength? = nil
    for rect in self.mRectSet {
      if let r = result {
        if rect.minX != r {
          return nil
        }
      }else{
        result = rect.minX
      }
    }
    return result
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private var minY : CanariLength? {
    var result : CanariLength? = nil
    for rect in self.mRectSet {
      if let r = result {
        if rect.minY != r {
          return nil
        }
      }else{
        result = rect.minY
      }
    }
    return result
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private var width : CanariLength? {
    var result : CanariLength? = nil
    for rect in self.mRectSet {
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
    for rect in self.mRectSet {
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
