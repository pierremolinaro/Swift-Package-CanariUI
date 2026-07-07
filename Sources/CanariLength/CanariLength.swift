//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 09/05/2024.
//--------------------------------------------------------------------------------------------------

import Foundation

//--------------------------------------------------------------------------------------------------
// struct CanariLength
//--------------------------------------------------------------------------------------------------

public struct CanariLength : Hashable, Comparable, Sendable {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public let cuValue : Int

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (_ inValue : Double, in inLengthUnit : CanariLength.Unit) {
    self.cuValue = Int (inValue * Double (inLengthUnit.toCanariUnits ()))
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (_ inValue : Int, in inLengthUnit : CanariLength.Unit) {
    self.cuValue = inValue * inLengthUnit.toCanariUnits ()
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
    return Double (self.cuValue) / Double (Unit.cm.toCanariUnits ())
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var mmValue : Double {
    return Double (self.cuValue) / Double (Unit.mm.toCanariUnits ())
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var pxValue : CGFloat {
    return Double (self.cuValue) / Double (Unit.px.toCanariUnits ())
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func value (in inUnit : CanariLength.Unit) -> Double {
    return Double (self.cuValue) / Double (inUnit.toCanariUnits ())
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func aligning (to inUnit : CanariLength?) -> CanariLength {
    if let unit = inUnit, !unit.isZero {
      return .cu ((self.cuValue + unit.cuValue / 2) / unit.cuValue) * unit.cuValue
    }else{
      return self
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func isAligned (_ inUnit : CanariLength) -> Bool {
    return (self.cuValue % inUnit.cuValue) == 0
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

//  public static func hypot (_ inLeft : CanariLength, _ inRight : CanariLength) -> CanariLength {
//    let left  = inLeft.mmValue
//    let right = inRight.mmValue
//    let v = sqrt (left * left + right * right)
//    return .mm (v)
//  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

//  public static func atan2 (dy inDy : CanariLength, dx inDx : CanariLength) -> CanariAngle {
//    let dyMM = inDy.mmValue
//    let dxMM = inDx.mmValue
//    return .radians (Darwin.atan2 (dyMM, dxMM))
//  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func string (in inUnit : CanariLength.Unit, fractionDigits inCount : Int = 3) -> String {
    unsafe "\(String (format: "%.*f", inCount, self.value (in: inUnit))) \(inUnit.unitString)"
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
