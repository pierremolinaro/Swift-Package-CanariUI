//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 07/06/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct Set_CanariAngleEditor : View {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @State private var mDoubleValue : Double?
  private let mAngleArray : [CanariAngle]
  private let mWidth : CGFloat
  private let mSetter : (CanariAngle) -> Void

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (angleSet inLengthSet : Set <CanariAngle>,
               setter inSetter: @escaping (CanariAngle) -> Void,
               width inWidth : CGFloat) {
    self.mAngleArray = Array (inLengthSet).sorted ()
    if inLengthSet.count == 1, let v = inLengthSet.first {
      self.mDoubleValue = v.value (in: .degrees)
    }else{
      self.mDoubleValue = nil
    }
    self.mWidth = inWidth
    self.mSetter = inSetter
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var body : some View {
    HStack (spacing: 0) {
   //   Slider (value: self.$mV, in: 0.0 ... 360.0, step: 1.0)
      TextField (
        "",
        value: self.$mDoubleValue,
        format: .number.precision (.fractionLength (3)),
        prompt: Text ("Multiple values")
      )
      .onSubmit {
        if let v = self.mDoubleValue {
          self.mSetter (CanariAngle (v, in: .degrees))
        }
      }
      .labelsHidden ()
      .frame (width: self.mWidth)
      .onChange (of: self.mAngleArray) {
        if self.mAngleArray.count == 1, let v = self.mAngleArray.first {
          self.mDoubleValue = v.value (in: .degrees)
        }else{
          self.mDoubleValue = nil
        }
      }
      Text (" ° ")
      Stepper {
        EmptyView ()
      } onIncrement: {
        self.mSetter (CanariAngle (self.mDoubleValue!, in: .degrees) + .degrees (10))
      } onDecrement: {
        self.mSetter (CanariAngle (self.mDoubleValue!, in: .degrees) - .degrees (10))
      }.help ("10°").isHidden (self.mDoubleValue == nil).controlSize (.small)
      .overlay {
        if self.mAngleArray.count > 1 {
          Menu ("") {
            ForEach (self.mAngleArray, id: \.self) { angle in
              Button (angle.string (in: .degrees, fractionDigits: 3)) { self.mSetter (angle) }
            }
          }.buttonStyle (.borderless)
        }
      }
      Stepper {
        EmptyView ()
      } onIncrement: {
        self.mSetter (CanariAngle (self.mDoubleValue!, in: .degrees) + .degrees (1))
      } onDecrement: {
        self.mSetter (CanariAngle (self.mDoubleValue!, in: .degrees) - .degrees (1))
      }.help ("1°").isHidden (self.mDoubleValue == nil).controlSize (.small)
      Stepper {
        EmptyView ()
      } onIncrement: {
        self.mSetter (CanariAngle (self.mDoubleValue!, in: .degrees) + .degrees (0.1))
      } onDecrement: {
        self.mSetter (CanariAngle (self.mDoubleValue!, in: .degrees) - .degrees (0.1))
      }.help ("0.1°").isHidden (self.mDoubleValue == nil).controlSize (.small)
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
