//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 09/05/2024.
//--------------------------------------------------------------------------------------------------

import Foundation

//--------------------------------------------------------------------------------------------------
// struct CanariVolume
//--------------------------------------------------------------------------------------------------

public struct CanariVolume : Hashable, Comparable, Sendable {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public let pt3Value : Double

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (pt3 inValue : Double) {
    self.pt3Value = inValue // Double (inLengthUnit.pt3Value))
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (_ inValue : Double, in inLengthUnit : CanariVolumeUnit) {
    self.pt3Value = inValue * inLengthUnit.pt3Value
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

//  public init (_ inValue : Int128, in inLengthUnit : CanariVolumeUnit) {
//    self.pt3Value = inValue * inLengthUnit.pt3Value
//  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  internal init (adding inA : CanariVolume, _ inB : CanariVolume) {
    self.pt3Value = inA.pt3Value + inB.pt3Value
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (_ inFactor : CanariVolume, multipliedByDouble inOperand : Double) {
    self.pt3Value = inFactor.pt3Value * inOperand
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

//  public init (_ inFactor : CanariVolume, multipliedByInt inOperand : Int128) {
//    self.pt3Value = inFactor.pt3Value * inOperand
//  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var isZero : Bool { return self.pt3Value == 0 }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public static var zero : CanariVolume { return CanariVolume (pt3: 0) }
//  public static var zero : CanariVolume { return .cu3 (int: 0) }
///  public static var max  : CanariVolume { CanariVolume (pt3: .max / 2) }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

//  public static func cm3   (_ inValue : Int128) -> CanariVolume { CanariVolume (inValue, in: .cm3) }
//  public static func mm3   (_ inValue : Int128) -> CanariVolume { CanariVolume (inValue, in: .mm3) }
//  public static func µm3   (_ inValue : Int128) -> CanariVolume { CanariVolume (inValue, in: .µm3) }
//  public static func inch3 (_ inValue : Int128) -> CanariVolume { CanariVolume (inValue, in: .inch3) }
//  public static func mil3  (_ inValue : Int128) -> CanariVolume { CanariVolume (inValue, in: .mil3) }
//  public static func pt3   (_ inValue : Int128) -> CanariVolume { CanariVolume (inValue, in: .pt3) }
//  public static func cu3   (int inValue : Int128) -> CanariVolume { CanariVolume (pt3: Double (inValue, in: .cu3) }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public static func cm3   (_ inValue : Double) -> CanariVolume { CanariVolume (inValue, in: .cm3) }
  public static func mm3   (_ inValue : Double) -> CanariVolume { CanariVolume (inValue, in: .mm3) }
  public static func µm3   (_ inValue : Double) -> CanariVolume { CanariVolume (inValue, in: .µm3) }
  public static func inch3 (_ inValue : Double) -> CanariVolume { CanariVolume (inValue, in: .inch3) }
  public static func mil3  (_ inValue : Double) -> CanariVolume { CanariVolume (inValue, in: .mil3) }
  public static func pt3   (_ inValue : Double) -> CanariVolume { CanariVolume (pt3: inValue) }
//  public static func cu3   (double inValue : Double) -> CanariVolume { CanariVolume (inValue, in: .cu3) }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func multipliedBy (double inValue : Double) -> CanariVolume {
    CanariVolume (self, multipliedByDouble: inValue)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

//  public func multipliedBy (int inValue : Int128) -> CanariVolume {
//    CanariVolume (self, multipliedByInt: inValue)
//  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var cm3Value : Double {
    self.pt3Value / CanariVolumeUnit.cm3.pt3Value
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var mm3Value : Double {
    self.pt3Value / CanariVolumeUnit.mm3.pt3Value
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func value (in inUnit : CanariVolumeUnit) -> Double {
    return Double (self.pt3Value) / Double (inUnit.pt3Value)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func string (in inUnit : CanariVolumeUnit, fractionDigits inCount : Int) -> String {
    self.value (in: inUnit).strf (inCount) + " " + inUnit.unitString
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
