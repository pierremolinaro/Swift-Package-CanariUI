//  Created by Pierre Molinaro on 01/04/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct UIntField : View {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @Binding private var mValue : UInt
  @State private var mTemporaryValue : UInt
  private let mMin : UInt
  private let mMax : UInt

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (value inValue : Binding <UInt>,
               min : UInt,
               max : UInt) {
    self._mValue = inValue
    self.mTemporaryValue = inValue.wrappedValue
    self.mMin = min
    self.mMax = max
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private var isValid : Bool { (self.mTemporaryValue >= self.mMin) && (self.mTemporaryValue <= self.mMax) }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @ViewBuilder public var body : some View {
    TextField ("",
      value: self.$mTemporaryValue,
      format: .number.precision (.fractionLength (0))
    )
    .overlay (RoundedRectangle (cornerRadius: 6, style: .continuous).fill (self.isValid ? .clear : .red.opacity(0.35)))
    .onChange (of: self.mTemporaryValue) { _, _ in
      if self.isValid {
        self.mValue = self.mTemporaryValue
      }
    }
    .onChange (of: self.mValue, initial: true) { _, _ in
      if self.mTemporaryValue != self.mValue {
        self.mTemporaryValue = self.mValue
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
