//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 21/08/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct UInt8Slider : View {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @Binding private var mValue : UInt8
  @State private var mTemporaryValue : Double
  private let mSuffix : String
  private let mMin : UInt8
  private let mMax : UInt8

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (value inValue : Binding <UInt8>,
               suffix inSuffix : String,
               min : UInt8,
               max : UInt8) {
    self._mValue = inValue
    self.mTemporaryValue = Double (inValue.wrappedValue)
    self.mSuffix = inSuffix
    self.mMin = min
    self.mMax = max
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @ViewBuilder public var body : some View {
    HStack {
      Text("\(self.mValue)\(self.mSuffix)").frame (width: 40)
      Stepper (
        value: self.$mValue,
        in: UInt8 (self.mMin) ... UInt8 (self.mMax),
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
      if self.mValue != UInt8 (self.mTemporaryValue) {
        self.mValue = UInt8 (self.mTemporaryValue)
      }
    }
    .onChange (of: self.mValue) { _, _ in
      if self.mValue != UInt8 (self.mTemporaryValue) {
         self.mTemporaryValue = Double (self.mValue)
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------

