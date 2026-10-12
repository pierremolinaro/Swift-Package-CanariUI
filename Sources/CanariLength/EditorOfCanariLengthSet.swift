//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 19/09/2025.
//--------------------------------------------------------------------------------------------------

import SwiftUI
import CanariGeometry

//--------------------------------------------------------------------------------------------------

public struct EditorOfCanariLengthSet : View {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @State private var mDoubleValue : Double?
  private let mLengthArray : [CanariLength]
  private let mUnit : CanariLength.DisplayUnit
  private let mFractionDigits : Int
  private let mWidth : CGFloat
  private let mSetter : (CanariLength) -> Void
  private let mIncrementer : (CanariLength) -> Void

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (lengthSet inLengthSet : Set <CanariLength>,
               setter inSetter : @escaping (CanariLength) -> Void,
               incrementer inIncrementer : @escaping (CanariLength) -> Void,
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
    self.mIncrementer = inIncrementer
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var body : some View {
    HStack (spacing: 0) {
    //--- TextField
      TextField (
        "",
        value: self.$mDoubleValue,
        format: .number.precision (.fractionLength (self.mFractionDigits)),
        prompt: Text (MULTIPLE_VALUES_MARK)
      )
      .labelsHidden ()
      .frame (width: self.mWidth)
      .onSubmit {
        if let v = self.mDoubleValue {
          self.mSetter (CanariLength (v, in: self.mUnit.unit))
        }
      }
      .onDisappear { // Triggered AFTER the view disappears
        if let v = self.mDoubleValue {
          self.mSetter (CanariLength (v, in: self.mUnit.unit))
        }
      }
      .overlay (alignment: Alignment (horizontal: .trailing, vertical: .bottom)) {
        Menu ("") {
          ForEach (self.mLengthArray, id: \.self) { length in
            Button (length.string (in: self.mUnit.unit, fractionDigits: self.mFractionDigits)) { self.mSetter (length) }
          }
        }.buttonStyle (.borderless).hiddenWhen (self.mLengthArray.count <= 1)
      }
    //--- Unit
      Text (" " + self.mUnit.string)
    //--- Increment / decrement d1
      Stepper {
        EmptyView ()
      } onIncrement: {
        self.mIncrementer (self.mUnit.length (.d1))
      } onDecrement: {
        self.mIncrementer (-self.mUnit.length (.d1))
      }
      .help (self.mUnit.name (.d1)).controlSize (.small)
    //--- Increment / decrement d10
      Stepper {
        EmptyView ()
      } onIncrement: {
        self.mIncrementer (self.mUnit.length (.d10))
      } onDecrement: {
        self.mIncrementer (-self.mUnit.length (.d10))
      }
      .help (self.mUnit.name (.d10)).controlSize (.small)
    //--- Increment / decrement d100
      Stepper {
        EmptyView ()
      } onIncrement: {
        self.mIncrementer (self.mUnit.length (.d100))
      } onDecrement: {
        self.mIncrementer (-self.mUnit.length (.d100))
      }
      .help (self.mUnit.name (.d100)).controlSize (.small)
      .labelsHidden ()
    //--- Increment / decrement d1000
      Stepper {
        EmptyView ()
      } onIncrement: {
        self.mIncrementer (self.mUnit.length (.d1000))
      } onDecrement: {
        self.mIncrementer (-self.mUnit.length  (.d1000))
      }
      .help (self.mUnit.name (.d1000)).controlSize (.small)
      .labelsHidden ()
    }
    .onChange (of: self.mLengthArray) {
      if self.mLengthArray.count == 1, let v = self.mLengthArray.first {
        self.mDoubleValue = v.value (in: self.mUnit.unit)
      }else{
        self.mDoubleValue = nil
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
