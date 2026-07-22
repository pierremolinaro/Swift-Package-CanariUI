//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 09/05/2024.
//--------------------------------------------------------------------------------------------------

import Foundation

//--------------------------------------------------------------------------------------------------
// struct CanariVolume
//--------------------------------------------------------------------------------------------------

public struct CanariVolume : Hashable, Comparable, Sendable {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public let cu3Value : Int128

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (_ inValue : Double, in inLengthUnit : CanariVolume.Unit) {
    self.cu3Value = Int128 (inValue * Double (inLengthUnit.cu3Value))
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (_ inValue : Int128, in inLengthUnit : CanariVolume.Unit) {
    self.cu3Value = inValue * inLengthUnit.cu3Value
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  internal init (adding inA : CanariVolume, _ inB : CanariVolume) {
    self.cu3Value = inA.cu3Value + inB.cu3Value
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (_ inFactor : CanariVolume, multipliedByDouble inOperand : Double) {
    self.cu3Value = Int128 (Double (inFactor.cu3Value) * inOperand)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (_ inFactor : CanariVolume, multipliedByInt inOperand : Int128) {
    self.cu3Value = inFactor.cu3Value * inOperand
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var isZero : Bool { return self.cu3Value == 0 }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public static var zero : CanariVolume { return .cu3 (int: 0) }
  public static var max  : CanariVolume { CanariVolume (.max, in: .cu3) }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public static func cm3   (_ inValue : Int128) -> CanariVolume { CanariVolume (inValue, in: .cm3) }
  public static func mm3   (_ inValue : Int128) -> CanariVolume { CanariVolume (inValue, in: .mm3) }
  public static func µm3   (_ inValue : Int128) -> CanariVolume { CanariVolume (inValue, in: .µm3) }
  public static func inch3 (_ inValue : Int128) -> CanariVolume { CanariVolume (inValue, in: .inch3) }
  public static func mil3  (_ inValue : Int128) -> CanariVolume { CanariVolume (inValue, in: .mil3) }
  public static func px3   (_ inValue : Int128) -> CanariVolume { CanariVolume (inValue, in: .px3) }
  public static func cu3   (int inValue : Int128) -> CanariVolume { CanariVolume (inValue, in: .cu3) }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public static func cm3   (_ inValue : Double) -> CanariVolume { CanariVolume (inValue, in: .cm3) }
  public static func mm3   (_ inValue : Double) -> CanariVolume { CanariVolume (inValue, in: .mm3) }
  public static func µm3   (_ inValue : Double) -> CanariVolume { CanariVolume (inValue, in: .µm3) }
  public static func inch3 (_ inValue : Double) -> CanariVolume { CanariVolume (inValue, in: .inch3) }
  public static func mil3  (_ inValue : Double) -> CanariVolume { CanariVolume (inValue, in: .mil3) }
  public static func px3   (_ inValue : Double) -> CanariVolume { CanariVolume (inValue, in: .px3) }
  public static func cu3   (double inValue : Double) -> CanariVolume { CanariVolume (inValue, in: .cu3) }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func multipliedBy (double inValue : Double) -> CanariVolume {
    CanariVolume (self, multipliedByDouble: inValue)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func multipliedBy (int inValue : Int128) -> CanariVolume {
    CanariVolume (self, multipliedByInt: inValue)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var cm3Value : Double {
    return Double (self.cu3Value) / Double (Unit.cm3.cu3Value)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var mm3Value : Double {
    return Double (self.cu3Value) / Double (Unit.mm3.cu3Value)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var px3Value : CGFloat {
    return Double (self.cu3Value) / Double (Unit.px3.cu3Value)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func value (in inUnit : CanariVolume.Unit) -> Double {
    return Double (self.cu3Value) / Double (inUnit.cu3Value)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func string (in inUnit : CanariVolume.Unit, fractionDigits inCount : Int) -> String {
    self.value (in: inUnit).strf (inCount) + " " + inUnit.unitString
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
