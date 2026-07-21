//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 19/09/2025.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct EditorOfCanariLengthSet : View {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @State private var mDoubleValue : Double?
  private let mLengthArray : [CanariLength]
  private let mUnit : Self.DisplayUnit
  private let mFractionDigits : Int
  private let mWidth : CGFloat
  private let mSetter : (CanariLength) -> Void

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (lengthSet inLengthSet : Set <CanariLength>,
               setter inSetter: @escaping (CanariLength) -> Void,
               unit inDisplayUnit : Self.DisplayUnit = .cm,
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

  public enum DisplayUnit {
    case cm
    case inch

    var unit : CanariLength.Unit {
      switch self {
      case .cm : return .cm
      case .inch : return .inch
      }
    }

    var string : String {
      switch self {
      case .cm : return "cm"
      case .inch : return "in"
      }
    }

    func length (_ inDivisor: Divisor) -> CanariLength {
      switch self {
      case .cm : return .cm (1) / inDivisor.rawValue
      case .inch : return .inch (1) / inDivisor.rawValue
      }
    }

    func name (_ inDivisor : Divisor) -> String {
      switch (self, inDivisor) {
      case (.cm, .d1) : return " 1 cm"
      case (.cm, .d10) : return " 1 mm"
      case (.cm, .d100) : return " 0.1 mm"
      case (.cm, .d1000) : return " 0.01 mm"
      case (.inch, .d1) : return " 1 in"
      case (.inch, .d10) : return " 100 mil"
      case (.inch, .d100) : return " 10 mil"
      case (.inch, .d1000) : return " 1 mil"
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  enum Divisor : Int {
    case d1 = 1
    case d10 = 10
    case d100 = 100
    case d1000 = 1000
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
