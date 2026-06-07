//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 09/05/2024.
//--------------------------------------------------------------------------------------------------

import Foundation

//--------------------------------------------------------------------------------------------------
// struct CanariAngle
//--------------------------------------------------------------------------------------------------

public struct CanariAngle : Hashable, Comparable, CustomStringConvertible, Codable {

  public let radians : Double // -π ... π

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (fromPoint inStartPoint : CanariPoint, toPoint inTargetPoint : CanariPoint) {
    let dyMM = (inTargetPoint.y - inStartPoint.y).pxValue
    let dxMM = (inTargetPoint.x - inStartPoint.x).pxValue
    self.radians = Darwin.atan2 (dyMM, dxMM)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (_ inValue : Double, in inAngleUnit : CanariAngle.Unit) {
    self.radians = radiansNormalized (inValue * inAngleUnit.radians ())
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (adding inFirst : CanariAngle, _ inSecond : CanariAngle) {
    self.radians = radiansNormalized (inFirst.radians + inSecond.radians)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (_ inAngle : CanariAngle, multiplyBy inValue : Double) {
    self.radians = radiansNormalized (inAngle.radians * inValue)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public static func < (inLeft : CanariAngle, inRight : CanariAngle) -> Bool { // Comparable protocol
    return inLeft.radians < inRight.radians
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public static func degrees (_ inValue : Double) -> CanariAngle { return CanariAngle (inValue, in: .degrees) }
  public static func radians (_ inValue : Double) -> CanariAngle { return CanariAngle (inValue, in: .radians) }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var degrees : Double {
    self.radians / CanariAngle.Unit.degrees.radians ()
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func value (in inUnit : CanariAngle.Unit) -> Double {
    self.radians / inUnit.radians ()
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var isZero : Bool { return self.radians == 0.0 }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public static var zero : CanariAngle { return CanariAngle (0, in: .degrees) }

  public static var degrees90 : CanariAngle { return CanariAngle (90, in: .degrees) }

  public static var degrees180 : CanariAngle { return CanariAngle (180, in: .degrees) }

  public static var degrees270 : CanariAngle { return CanariAngle (270, in: .degrees) }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func sinus () -> Double {
    return sin (self.radians)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func cosinus () -> Double {
    return cos (self.radians)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func string (in inUnit : CanariAngle.Unit, fractionDigits inCount : Int = 3) -> String {
    return unsafe "\(String (format: "%.*f", inCount, self.value (in: inUnit)))\(inUnit.unitString)"
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  /**
    A textual representation of this instance.
  */

  public var description : String { // CustomStringConvertible protocol
    return unsafe "\(String (format: "%.3f", self.degrees))\(Unit.degrees.unitString)"
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public enum Unit {
    case degrees
    case grade
    case radians

    public func radians () -> Double {
      switch self {
        case .degrees : return .pi / 180
        case .grade  : return .pi / 200.0
        case .radians : return 1.0
      }
    }

    public var unitString : String {
      switch self {
        case .degrees : return "°"
        case .grade  : return "gr"
        case .radians : return "rd"
      }
    }

  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------

fileprivate func radiansNormalized (_ inRadians : Double) -> Double {
  let twoPi = 2.0 * .pi
  var radians = inRadians
  while radians <= -.pi {
    radians += twoPi
  }
  while radians > .pi {
    radians -= twoPi
  }
  return radians
}

//--------------------------------------------------------------------------------------------------
