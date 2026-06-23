//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 19/09/2025.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

struct EditorOfCanariLengthSet : View {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @State private var mDoubleValue : Double?
  private let mLengthArray : [CanariLength]
  private let mUnit : CanariLength.Unit
  private let mFractionDigits : Int
  private let mWidth : CGFloat
  private let mDisplayUnit : Bool
  private let mSetter : (CanariLength) -> Void

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  init (lengthSet inLengthSet : Set <CanariLength>,
        setter inSetter: @escaping (CanariLength) -> Void,
        unit inUnit : CanariLength.Unit = .cm,
        fractionDigits inFractionDigits : Int = 2,
        width inWidth : CGFloat,
        displayUnit inDisplayUnit : Bool) {
    self.mLengthArray = Array (inLengthSet).sorted ()
    if inLengthSet.count == 1, let v = inLengthSet.first {
      self.mDoubleValue = v.value (in: inUnit)
    }else{
      self.mDoubleValue = nil
    }
    self.mUnit = inUnit
    self.mFractionDigits = inFractionDigits
    self.mWidth = inWidth
    self.mSetter = inSetter
    self.mDisplayUnit = inDisplayUnit
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  var body : some View {
    HStack (spacing: 0) {
      TextField (
        "",
        value: self.$mDoubleValue,
        format: .number.precision (.fractionLength (self.mFractionDigits)),
        prompt: Text (MULTIPLE_VALUES_MARK)
      )
      .onSubmit {
        if let v = self.mDoubleValue {
          self.mSetter (CanariLength (v, in: self.mUnit))
        }
      }
      .labelsHidden ()
      .frame (width: self.mWidth)
      .onChange (of: self.mLengthArray) {
        if self.mLengthArray.count == 1, let v = self.mLengthArray.first {
          self.mDoubleValue = v.value (in: self.mUnit)
        }else{
          self.mDoubleValue = nil
        }
      }
      if self.mDisplayUnit {
        Text (" " + self.mUnit.unitString)
      }
      Stepper {
        EmptyView ()
      } onIncrement: {
        self.mSetter (CanariLength (self.mDoubleValue!, in: self.mUnit) + self.mUnit.length)
      } onDecrement: {
        self.mSetter (CanariLength (self.mDoubleValue!, in: self.mUnit) - self.mUnit.length)
      }.help (self.mUnit.unitString).hiddenWhen (self.mDoubleValue == nil).controlSize (.small)
      .overlay {
        if self.mLengthArray.count > 1 {
          Menu ("") {
            ForEach (self.mLengthArray, id: \.self) { length in
              Button (length.string (in: self.mUnit, fractionDigits: self.mFractionDigits)) { self.mSetter (length) }
            }
          }.buttonStyle (.borderless)
        }
      }
      Stepper {
        EmptyView ()
      } onIncrement: {
        self.mSetter (CanariLength (self.mDoubleValue!, in: self.mUnit) + self.mUnit.length / 10.0)
      } onDecrement: {
        self.mSetter (CanariLength (self.mDoubleValue!, in: self.mUnit) - self.mUnit.length / 10.0)
      }.help (self.mUnit.unitString + "/10").hiddenWhen (self.mDoubleValue == nil).controlSize (.small)
      Stepper {
        EmptyView ()
      } onIncrement: {
        self.mSetter (CanariLength (self.mDoubleValue!, in: self.mUnit) + self.mUnit.length / 100.0)
      } onDecrement: {
        self.mSetter (CanariLength (self.mDoubleValue!, in: self.mUnit) - self.mUnit.length / 100.0)
      }.help (self.mUnit.unitString + "/100").hiddenWhen (self.mDoubleValue == nil).controlSize (.small)
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
