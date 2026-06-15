//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 19/09/2025.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct Set_DoubleEditor : View {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @State private var mDoubleValue : Double?
  private let mValueArray : [Double]
  private let mFractionDigits : Int
  private let mWidth : CGFloat
  private let mSetter : (Double) -> Void

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (valueSet inValueSet : Set <Double>,
               setter inSetter: @escaping (Double) -> Void,
               fractionDigits inFractionDigits : Int = 3,
               width inWidth : CGFloat) {
    self.mValueArray = Array (inValueSet).sorted ()
    if inValueSet.count == 1, let v = inValueSet.first {
      self.mDoubleValue = v
    }else{
      self.mDoubleValue = nil
    }
    self.mFractionDigits = inFractionDigits
    self.mWidth = inWidth
    self.mSetter = inSetter
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private var mFactor : Double { sqrt (sqrt (2.0)) }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var body : some View {
    HStack (spacing: 0) {
      TextField (
        "",
        value: self.$mDoubleValue,
        format: .number.precision (.fractionLength (self.mFractionDigits)),
        prompt: Text (MULTIPLE_VALUES_MARK)
      )
      .onSubmit {
        if let v = self.mDoubleValue {
          self.mSetter (v)
        }
      }
      .labelsHidden ()
      .frame (width: self.mWidth)
      .onChange (of: self.mValueArray) {
        if self.mValueArray.count == 1, let v = self.mValueArray.first {
          self.mDoubleValue = v
        }else{
          self.mDoubleValue = nil
        }
      }
      Text (" ")
      Stepper {
        EmptyView ()
      } onIncrement: {
        self.mSetter (self.mDoubleValue! * self.mFactor)
      } onDecrement: {
        self.mSetter (self.mDoubleValue! / self.mFactor)
      }.help ("\(self.mFactor)").isHidden (self.mDoubleValue == nil).controlSize (.small)
      .overlay {
        if self.mValueArray.count > 1 {
          Menu ("") {
            ForEach (self.mValueArray, id: \.self) { scale in
              Button ("\(scale)") { self.mSetter (scale) }
            }
          }.buttonStyle (.borderless)
        }
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
