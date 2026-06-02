//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 09/05/2024.
//--------------------------------------------------------------------------------------------------

import Foundation

//--------------------------------------------------------------------------------------------------
// L'unité de longueur utilisée dans canari est le 1/90 µm [cu = Canari Unit]
// 1 µm = 90 cu
// 1 mm = 90 000 cu
// 1 cm = 900 000 cu
// 1 pouce = 2,54 cm = 2 286 000 cu
// 1 mil = 0,001 pouce = 2 286 cu
// Le pixel Cocoa est 1/72 pouce
// 1 px = 1/72 pouce = 31 750 cu
//--------------------------------------------------------------------------------------------------

private let CANARI_UNITS_PER_µM    = 90
private let CANARI_UNITS_PER_MIL   = 2_286
private let CANARI_UNITS_PER_PIXEL = 31_750
private let CANARI_UNITS_PER_MM    = CANARI_UNITS_PER_µM * 1000
private let CANARI_UNITS_PER_CM    = CANARI_UNITS_PER_MM * 10
private let CANARI_UNITS_PER_INCH  = CANARI_UNITS_PER_MIL * 1000

//--------------------------------------------------------------------------------------------------
// struct CanariLength
//--------------------------------------------------------------------------------------------------

public struct CanariLength : CustomStringConvertible, Hashable, Comparable, Sendable, Codable {

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

  public static func cm   (_ inValue : Int) -> CanariLength { return CanariLength (inValue, in: .cm) }
  public static func mm   (_ inValue : Int) -> CanariLength { return CanariLength (inValue, in: .mm) }
  public static func µm   (_ inValue : Int) -> CanariLength { return CanariLength (inValue, in: .µm) }
  public static func inch (_ inValue : Int) -> CanariLength { return CanariLength (inValue, in: .inch) }
  public static func mil  (_ inValue : Int) -> CanariLength { return CanariLength (inValue, in: .mil) }
  public static func px   (_ inValue : Int) -> CanariLength { return CanariLength (inValue, in: .px) }
  public static func cu   (_ inValue : Int) -> CanariLength { return CanariLength (inValue, in: .cu) }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public static func cm   (_ inValue : Double) -> CanariLength { return CanariLength (inValue, in: .cm) }
  public static func mm   (_ inValue : Double) -> CanariLength { return CanariLength (inValue, in: .mm) }
  public static func µm   (_ inValue : Double) -> CanariLength { return CanariLength (inValue, in: .µm) }
  public static func inch (_ inValue : Double) -> CanariLength { return CanariLength (inValue, in: .inch) }
  public static func mil  (_ inValue : Double) -> CanariLength { return CanariLength (inValue, in: .mil) }
  public static func px   (_ inValue : Double) -> CanariLength { return CanariLength (inValue, in: .px) }
  public static func cu   (_ inValue : Double) -> CanariLength { return CanariLength (inValue, in: .cu) }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (adding inA : CanariLength, _ inB : CanariLength) {
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

  public func multipliedBy (double inValue : Double) -> CanariLength {
    return CanariLength (self, multipliedByDouble: inValue)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func multipliedBy (int inValue : Int) -> CanariLength {
    return CanariLength (self, multipliedByInt: inValue)
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
    if let unit = inUnit {
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

  public static var zero : CanariLength { return .cu (0) }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var isZero : Bool { return self.cuValue == 0 }

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
    return unsafe "\(String (format: "%.*f", inCount, self.value (in: inUnit))) \(inUnit.unitString)"
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  /**
    A textual representation of this instance.
  */

  public var description : String { // CustomStringConvertible protocol
    return unsafe "\(String (format: "%.3f", self.value (in: .mm))) \(Unit.mm.unitString)"
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public enum Unit : Sendable {
    case mm
    case cm
    case inch
    case mil
    case µm
    case px // Cocoa point, Cocoa Pixel, 1/72 inch
    case cu // Canari Unit 1cu = 1/90 µm

    public func toCanariUnits () -> Int {
      switch self {
        case .mm   : return CANARI_UNITS_PER_MM
        case .cm   : return CANARI_UNITS_PER_CM
        case .inch : return CANARI_UNITS_PER_INCH
        case .mil  : return CANARI_UNITS_PER_MIL
        case .µm   : return CANARI_UNITS_PER_µM
        case .cu   : return 1
        case .px   : return CANARI_UNITS_PER_PIXEL
      }
    }

    public var unitString : String {
      switch self {
        case .mm   : return "mm"
        case .cm   : return "cm"
        case .inch : return "inch"
        case .mil  : return "mil"
        case .µm   : return "µm"
        case .cu   : return "cu"
        case .px   : return "px"
      }
    }

  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Codable
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (from inDecoder : any Decoder) throws { // Decodable
    let container = try inDecoder.singleValueContainer ()
    let string = try container.decode (String.self)
    if let v = Int (string) {
      self.cuValue = v
    }else {
      throw DecodingError.dataCorruptedError (in: container, debugDescription: "Invalid rectangle string")
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func encode (to inEncoder : any Encoder) throws { // Encodable
    var container = inEncoder.singleValueContainer ()
    try container.encode ("\(self.cuValue)")
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
