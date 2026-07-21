//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 19/09/2025.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct EditorOfScaleSet : View {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @State private var mDoubleValue : Double?
  @State private var mFactor = Factor.sqr4
  private let mValueArray : [Double]
  private let mFractionDigits = 3
  private let mSetter : (Double) -> Void

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (valueSet inValueSet : Set <Double>,
               setter inSetter: @escaping (Double) -> Void) {
    self.mValueArray = Array (inValueSet).sorted ()
    if inValueSet.count == 1, let v = inValueSet.first {
      self.mDoubleValue = v
    }else{
      self.mDoubleValue = nil
    }
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
          self.mSetter (v)
        }
      }
      .labelsHidden ()
      .frame (width: 48.0)
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
        self.mSetter (self.mDoubleValue! * self.mFactor.value)
      } onDecrement: {
        self.mSetter (self.mDoubleValue! / self.mFactor.value)
      }
      .help (self.mFactor.value.str3f).hiddenWhen (self.mDoubleValue == nil).controlSize (.small)
      .overlay {
        if self.mValueArray.count > 1 {
          Menu ("") {
            ForEach (self.mValueArray, id: \.self) { scale in
              Button ("\(scale)") { self.mSetter (scale) }
            }
          }.buttonStyle (.borderless)
        }
      }
      Picker (selection: self.$mFactor) {
        ForEach (Factor.allCases, id: \.self) { grid in
          Text (grid.description).tag (grid)
        }
      } label: {
         HStack (spacing: 0) { Image (systemName: "multiply") ; Image (systemName: "divide") }
      }

    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------

fileprivate enum Factor : Int, CaseIterable, CustomStringConvertible {

  case sqr2  = 2
  case sqr3  = 3
  case sqr4  = 4
  case sqr5  = 5
  case sqr6  = 6
  case sqr7  = 7
  case sqr8  = 8
  case sqr9  = 9
  case sqr10 = 10

  var value : Double { pow (2.0, 1.0 / Double (self.rawValue)) }

  var description : String { self.value.str3f + " (\(self.rawValue))" }

}

//--------------------------------------------------------------------------------------------------
