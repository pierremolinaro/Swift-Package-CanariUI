//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 09/05/2024.
//--------------------------------------------------------------------------------------------------

import Foundation

//--------------------------------------------------------------------------------------------------
// struct CanariLength
//--------------------------------------------------------------------------------------------------

public struct CanariLength : Hashable, Comparable, Sendable {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  internal let cuValue : Int

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (_ inValue : Double, in inLengthUnit : CanariLength.Unit) {
    self.cuValue = Int (inValue * Double (inLengthUnit.cuValue))
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (_ inValue : Int, in inLengthUnit : CanariLength.Unit) {
    self.cuValue = inValue * inLengthUnit.cuValue
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  internal init (adding inA : CanariLength, _ inB : CanariLength) {
    self.cuValue = inA.cuValue + inB.cuValue
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (_ inFactor : CanariLength, multipliedByDouble inOperand : Double) {
    self.cuValue = Int (Double (inFactor.cuValue) * inOperand)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (_ inFactor : CanariLength, multipliedByInt inOperand : Int) {
    self.cuValue = inFactor.cuValue * inOperand
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var isZero : Bool { return self.cuValue == 0 }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public static var zero : CanariLength { return .cu (0) }
  public static var max  : CanariLength { CanariLength (.max, in: .cu) }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public static func cm   (_ inValue : Int) -> CanariLength { CanariLength (inValue, in: .cm) }
  public static func mm   (_ inValue : Int) -> CanariLength { CanariLength (inValue, in: .mm) }
  public static func µm   (_ inValue : Int) -> CanariLength { CanariLength (inValue, in: .µm) }
  public static func inch (_ inValue : Int) -> CanariLength { CanariLength (inValue, in: .inch) }
  public static func mil  (_ inValue : Int) -> CanariLength { CanariLength (inValue, in: .mil) }
  public static func px   (_ inValue : Int) -> CanariLength { CanariLength (inValue, in: .px) }
  public static func cu   (_ inValue : Int) -> CanariLength { CanariLength (inValue, in: .cu) }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public static func cm   (_ inValue : Double) -> CanariLength { CanariLength (inValue, in: .cm) }
  public static func mm   (_ inValue : Double) -> CanariLength { CanariLength (inValue, in: .mm) }
  public static func µm   (_ inValue : Double) -> CanariLength { CanariLength (inValue, in: .µm) }
  public static func inch (_ inValue : Double) -> CanariLength { CanariLength (inValue, in: .inch) }
  public static func mil  (_ inValue : Double) -> CanariLength { CanariLength (inValue, in: .mil) }
  public static func px   (_ inValue : Double) -> CanariLength { CanariLength (inValue, in: .px) }
  public static func cu   (_ inValue : Double) -> CanariLength { CanariLength (inValue, in: .cu) }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func multipliedBy (_ inValue : Double) -> CanariLength {
    CanariLength (self, multipliedByDouble: inValue)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func multipliedBy (_ inValue : Int) -> CanariLength {
    CanariLength (self, multipliedByInt: inValue)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var cmValue : Double {
    return Double (self.cuValue) / Double (Unit.cm.cuValue)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var mmValue : Double {
    return Double (self.cuValue) / Double (Unit.mm.cuValue)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var pxValue : CGFloat {
    return Double (self.cuValue) / Double (Unit.px.cuValue)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func value (in inUnit : CanariLength.Unit) -> Double {
    return Double (self.cuValue) / Double (inUnit.cuValue)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func aligning (to inUnit : CanariLength?) -> CanariLength {
    if let unit = inUnit, !unit.isZero {
      if self.cuValue > 0 {
        return .cu (((self.cuValue + unit.cuValue / 2) / unit.cuValue) * unit.cuValue)
      }else if self.cuValue < 0 {
        return -.cu (((-self.cuValue + unit.cuValue / 2) / unit.cuValue) * unit.cuValue)
      }else{
        return .zero
      }
    }else{
      return self
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var µmAligned : CanariLength {
    let µm = CanariLength.Unit.µm.cuValue
    if self.cuValue > 0 {
      return .cu (((self.cuValue + µm / 2) / µm) * µm)
    }else if self.cuValue < 0 {
      return -.cu (((-self.cuValue + µm / 2) / µm) * µm)
    }else{
      return .zero
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func isAligned (_ inUnit : CanariLength) -> Bool {
    return (self.cuValue % inUnit.cuValue) == 0
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func string (in inUnit : CanariLength.Unit, fractionDigits inCount : Int) -> String {
    self.value (in: inUnit).strf (inCount) + " " + inUnit.unitString
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
