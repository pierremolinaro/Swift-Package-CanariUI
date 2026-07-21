//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 19/09/2025.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct EditorOfCanariLengthSet : View {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @State private var mDoubleValue : Double?
  private let mLengthArray : [CanariLength]
  private let mUnit : CanariLength.DisplayUnit
  private let mFractionDigits : Int
  private let mWidth : CGFloat
  private let mSetter : (CanariLength) -> Void

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (lengthSet inLengthSet : Set <CanariLength>,
               setter inSetter: @escaping (CanariLength) -> Void,
               displayUnit inDisplayUnit : CanariLength.DisplayUnit,
               fractionDigits inFractionDigits : Int,
               width inWidth : CGFloat) {
    self.mLengthArray = Array (inLengthSet).sorted ()
    if inLengthSet.count == 1, let v = inLengthSet.first {
      self.mDoubleValue = v.value (in: inDisplayUnit.unit)
    }else{
      self.mDoubleValue = nil
    }
    self.mUnit = inDisplayUnit
    self.mFractionDigits = inFractionDigits
    self.mWidth = inWidth
    self.mSetter = inSetter
  }

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
          self.mSetter (CanariLength (v, in: self.mUnit.unit))
        }
      }
      .labelsHidden ()
      .frame (width: self.mWidth)
      .onChange (of: self.mLengthArray) {
        if self.mLengthArray.count == 1, let v = self.mLengthArray.first {
          self.mDoubleValue = v.value (in: self.mUnit.unit)
        }else{
          self.mDoubleValue = nil
        }
      }
      Text (" " + self.mUnit.string)
      Stepper {
        EmptyView ()
      } onIncrement: {
        self.mSetter (CanariLength (self.mDoubleValue!, in: self.mUnit.unit) + self.mUnit.length (.d1))
      } onDecrement: {
        self.mSetter (CanariLength (self.mDoubleValue!, in: self.mUnit.unit) - self.mUnit.length (.d1))
      }
      .help (self.mUnit.name (.d1)).hiddenWhen (self.mDoubleValue == nil).controlSize (.small)
      .overlay {
        if self.mLengthArray.count > 1 {
          Menu ("") {
            ForEach (self.mLengthArray, id: \.self) { length in
              Button (length.string (in: self.mUnit.unit, fractionDigits: self.mFractionDigits)) { self.mSetter (length) }
            }
          }.buttonStyle (.borderless)
        }
      }
      Stepper {
        EmptyView ()
      } onIncrement: {
        self.mSetter (CanariLength (self.mDoubleValue!, in: self.mUnit.unit) + self.mUnit.length (.d10))
      } onDecrement: {
        self.mSetter (CanariLength (self.mDoubleValue!, in: self.mUnit.unit) - self.mUnit.length (.d10))
      }
      .help (self.mUnit.name (.d10)).hiddenWhen (self.mDoubleValue == nil).controlSize (.small)
      Stepper {
        EmptyView ()
      } onIncrement: {
        self.mSetter (CanariLength (self.mDoubleValue!, in: self.mUnit.unit) + self.mUnit.length (.d100))
      } onDecrement: {
        self.mSetter (CanariLength (self.mDoubleValue!, in: self.mUnit.unit) - self.mUnit.length (.d100))
      }
      .help (self.mUnit.name (.d100)).hiddenWhen (self.mDoubleValue == nil).controlSize (.small)
      .labelsHidden ()
      Stepper {
        EmptyView ()
      } onIncrement: {
        self.mSetter (CanariLength (self.mDoubleValue!, in: self.mUnit.unit) + self.mUnit.length (.d1000))
      } onDecrement: {
        self.mSetter (CanariLength (self.mDoubleValue!, in: self.mUnit.unit) - self.mUnit.length  (.d1000))
      }
      .help (self.mUnit.name (.d1000)).hiddenWhen (self.mDoubleValue == nil).controlSize (.small)
      .labelsHidden ()
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
