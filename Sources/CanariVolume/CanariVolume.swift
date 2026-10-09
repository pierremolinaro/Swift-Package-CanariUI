//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 09/05/2024.
//--------------------------------------------------------------------------------------------------

import Foundation

//--------------------------------------------------------------------------------------------------
// struct CanariVolume
//--------------------------------------------------------------------------------------------------

public struct CanariVolume : Hashable, Comparable, Sendable {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  internal let cu3Value : Int128

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (cu3 inValue : Int128) {
    self.cu3Value = inValue
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (_ inValue : Double, in inLengthUnit : CanariVolumeUnit) {
    self.cu3Value = Int128 (inValue * Double (inLengthUnit.cu3Value))
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (_ inValue : Int128, in inLengthUnit : CanariVolumeUnit) {
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

  public var isZero     : Bool { self.cu3Value == 0 }
  public var isPositive : Bool { self.cu3Value >  0 }
  public var isNegative : Bool { self.cu3Value <  0 }
  public var isPositiveOrZero : Bool { self.cu3Value >= 0 }
  public var isNegativeOrZero : Bool { self.cu3Value <= 0 }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public static var zero : CanariVolume { CanariVolume (cu3: 0) }
  public static var max  : CanariVolume { CanariVolume (cu3: .max) }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public static func cm3   (_ inValue : Int128) -> CanariVolume { CanariVolume (inValue, in: .cm3) }
  public static func mm3   (_ inValue : Int128) -> CanariVolume { CanariVolume (inValue, in: .mm3) }
  public static func µm3   (_ inValue : Int128) -> CanariVolume { CanariVolume (inValue, in: .µm3) }
  public static func inch3 (_ inValue : Int128) -> CanariVolume { CanariVolume (inValue, in: .inch3) }
  public static func mil3  (_ inValue : Int128) -> CanariVolume { CanariVolume (inValue, in: .mil3) }
  public static func pt3   (_ inValue : Int128) -> CanariVolume { CanariVolume (inValue, in: .pt3) }
  public static func cu3   (_ inValue : Int128) -> CanariVolume { CanariVolume (cu3: inValue) }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public static func cm3   (_ inValue : Double) -> CanariVolume { CanariVolume (inValue, in: .cm3) }
  public static func mm3   (_ inValue : Double) -> CanariVolume { CanariVolume (inValue, in: .mm3) }
  public static func µm3   (_ inValue : Double) -> CanariVolume { CanariVolume (inValue, in: .µm3) }
  public static func inch3 (_ inValue : Double) -> CanariVolume { CanariVolume (inValue, in: .inch3) }
  public static func mil3  (_ inValue : Double) -> CanariVolume { CanariVolume (inValue, in: .mil3) }
  public static func pt3   (_ inValue : Double) -> CanariVolume { CanariVolume (inValue, in: .pt3) }
  public static func cu3   (_ inValue : Double) -> CanariVolume { CanariVolume (cu3: Int128 (inValue)) }

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
    return Double (self.cu3Value) / Double (CanariVolumeUnit.cm3.cu3Value)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var mm3Value : Double {
    return Double (self.cu3Value) / Double (CanariVolumeUnit.mm3.cu3Value)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var pt3Value : CGFloat {
    return Double (self.cu3Value) / Double (CanariVolumeUnit.pt3.cu3Value)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func value (in inUnit : CanariVolumeUnit) -> Double {
    return Double (self.cu3Value) / Double (inUnit.cu3Value)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func string (in inUnit : CanariVolumeUnit, fractionDigits inCount : Int) -> String {
    self.value (in: inUnit).strf (inCount) + " " + inUnit.unitString
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
