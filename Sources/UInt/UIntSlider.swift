//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 01/04/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct UIntSlider : View {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @Binding private var mValue : UInt
  @State private var mTemporaryValue : Double
  private let mSuffix : String
  private let mMin : UInt
  private let mMax : UInt

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (value inValue : Binding <UInt>,
               suffix inSuffix : String,
               min : UInt,
               max : UInt) {
    self._mValue = inValue
    self.mTemporaryValue = Double (inValue.wrappedValue)
    self.mSuffix = inSuffix
    self.mMin = min
    self.mMax = max
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @ViewBuilder public var body : some View {
    HStack {
      Text("\(self.mValue)\(self.mSuffix)").frame (width: 32)
      Stepper (
        value: self.$mValue,
        in: UInt (self.mMin) ... UInt (self.mMax),
        step: 1
      ) {
        EmptyView ()
      }.controlSize (.small)
      Slider (value: self.$mTemporaryValue, in: Double (self.mMin) ... Double (self.mMax)) {
        EmptyView ()
      } minimumValueLabel: {
        Text ("\(self.mMin)\(self.mSuffix)")
      } maximumValueLabel: {
        Text ("\(self.mMax)\(self.mSuffix)")
      }
    }
    .onChange (of: self.mTemporaryValue) { _, _ in
      if self.mValue != UInt (self.mTemporaryValue) {
        self.mValue = UInt (self.mTemporaryValue)
      }
    }
    .onChange (of: self.mValue) { _, _ in
      if self.mValue != UInt (self.mTemporaryValue) {
         self.mTemporaryValue = Double (self.mValue)
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------

