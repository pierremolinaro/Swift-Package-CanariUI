//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 19/09/2025.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

struct CanariLengthEditor : View {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @State private var mDoubleValue : Double
  @Binding private var mCanariLength : CanariLength
  private let mUnit : CanariLength.Unit
  private let mFractionDigits : Int
  private let mWidth : CGFloat?

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  init (value inCanariValue : Binding <CanariLength>,
        unit inUnit : CanariLength.Unit = .cm,
        fractionDigits inFractionDigits : Int = 2,
        width inWidth : CGFloat? = nil) {
    self._mCanariLength = inCanariValue
    self.mDoubleValue = inCanariValue.wrappedValue.value (in: inUnit)
    self.mUnit = inUnit
    self.mFractionDigits = inFractionDigits
    self.mWidth = inWidth
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  var body : some View {
    HStack (spacing: 4) {
      if let w = self.mWidth {
        self.buildWithFixedWidth (w)
      }else{
        self.buildScaledToFit ()
      }
      Text (" " + self.mUnit.unitString)
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @ViewBuilder func buildWithFixedWidth (_ inWidth : CGFloat) -> some View  {
    TextField (
      "",
      value: self.$mDoubleValue,
      format: .number.precision (.fractionLength (self.mFractionDigits))
    )
    .labelsHidden ()
    .frame (width: inWidth)
    .onChange (of: self.mDoubleValue) { oldValue, newValue in
      let newValue = CanariLength (self.mDoubleValue, in: self.mUnit)
      if self.mCanariLength != newValue {
        self.mCanariLength = newValue
      }
    }
    .onChange (of: self.mCanariLength, initial: true) { oldValue, newValue in
      if oldValue != newValue {
        self.mDoubleValue = newValue.value (in: self.mUnit)
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @ViewBuilder func buildScaledToFit () -> some View  {
    TextField (
      "",
      value: self.$mDoubleValue,
      format: .number.precision (.fractionLength (self.mFractionDigits))
    )
    .scaledToFit ()
    .labelsHidden ()
    .onChange (of: self.mDoubleValue) { oldValue, newValue in
      let newValue = CanariLength (newValue, in: self.mUnit)
      if self.mCanariLength != newValue {
        self.mCanariLength = newValue
      }
    }
    .onChange (of: self.mCanariLength, initial: true) { oldValue, newValue in
      if oldValue != newValue {
        self.mDoubleValue = newValue.value (in: self.mUnit)
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
