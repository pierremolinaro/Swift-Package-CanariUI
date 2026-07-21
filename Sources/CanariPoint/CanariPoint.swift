//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 11/05/2024.
//--------------------------------------------------------------------------------------------------

import AppKit

//--------------------------------------------------------------------------------------------------
//  struct CanariPoint
//--------------------------------------------------------------------------------------------------

public struct CanariPoint : Hashable, CustomStringConvertible, Sendable, Equatable {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var x : CanariLength
  public var y : CanariLength

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (x inX : CanariLength = .zero, y inY : CanariLength = .zero) {
    self.x = inX
    self.y = inY
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (length inLength : CanariLength, angle inAngle : CanariAngle) {
    self.x = inLength * cos (inAngle)
    self.y = inLength * sin (inAngle)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (px inPoint : NSPoint, aligned inUnit : CanariLength? = nil) {
    if let unit = inUnit {
      self.x = .px (inPoint.x).aligning (to: unit)
      self.y = .px (inPoint.y).aligning (to: unit)
    }else{
      self.x = .px (inPoint.x)
      self.y = .px (inPoint.y)
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public static var zero : CanariPoint { CanariPoint () }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var isZero : Bool { self.x.isZero && self.y.isZero }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var xMirrored : CanariPoint {
    return CanariPoint (x: -self.x, y: self.y)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var yMirrored : CanariPoint {
    return CanariPoint (x: self.x, y: -self.y)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func scaled (byX inScaleX : Double, byY inScaleY : Double) -> CanariPoint {
    CanariPoint (x: self.x * inScaleX, y: self.y * inScaleY)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func scaled (by inScale : Double) -> CanariPoint {
    CanariPoint (x: self.x * inScale, y: self.y * inScale)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var µmAligned : CanariPoint {
    CanariPoint (x: self.x.µmAligned, y: self.y.µmAligned)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func aligning (to inUnit : CanariLength?) -> CanariPoint {
    CanariPoint (x: self.x.aligning (to: inUnit), y: self.y.aligning (to: inUnit))
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func isAligned (_ inUnit : CanariLength) -> Bool {
    self.x.isAligned (inUnit) && self.y.isAligned (inUnit)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func moved (angle inAngle : CanariAngle = .zero,
                     x inDx : CanariLength = .zero,
                     y inDy : CanariLength = .zero) -> CanariPoint {
    return CanariPoint (
      x: self.x * cos (inAngle) - self.y * sin (inAngle) + inDx,
      y: self.x * sin (inAngle) + self.y * cos (inAngle) + inDy
    )
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func transformed (by inAffinity : CanariAffinity) -> CanariPoint {
    return inAffinity.transforming (self)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func distance (to inPoint : CanariPoint) -> CanariLength {
    let dx = self.x.cuValue - inPoint.x.cuValue
    let dy = self.y.cuValue - inPoint.y.cuValue
    return .cu (sqrt (Double (dx * dx + dy * dy)))
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func squareOfCuDistance (to inPoint : CanariPoint) -> UInt {
    let dx = self.x.cuValue - inPoint.x.cuValue
    let dy = self.y.cuValue - inPoint.y.cuValue
    return UInt (dx * dx + dy * dy)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var pxValue : CGPoint {
    return CGPoint (x: self.x.pxValue, y: self.y.pxValue)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var cmString : String {
    self.x.cmValue.str3f + " cm, " + self.y.cmValue.str3f + " cm"
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var mmString : String {
    self.x.mmValue.str3f + " mm, " + self.y.mmValue.str3f + " mm"
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func string (in inUnit : CanariLength.Unit, fractionDigits inCount : Int) -> String {
    "\(self.x.string (in: inUnit, fractionDigits: inCount)) x \(self.y.string (in: inUnit, fractionDigits: inCount))"
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var burningKitCode : String {
    "Point (x: .mm (" + self.x.mmValue.str3f + "), y : .mm (" + self.y.mmValue.str3f + "))"
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  /**
    A textual representation of this instance.
  */

  public var description : String { // CustomStringConvertible protocol
    return "x: \(self.x), y: \(self.y)"
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func angle (to inPoint : CanariPoint) -> CanariAngle {
    let dyMM = Double (inPoint.y.cuValue - self.y.cuValue)
    let dxMM = Double (inPoint.x.cuValue - self.x.cuValue)
    return .radians (Darwin.atan2 (dyMM, dxMM))
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

//  public static func distance (_ inLeft : CanariPoint, _ inRight : CanariPoint) -> CanariLength {
//    let dx = Double ((inLeft.x - inRight.x).cuValue)
//    let dy = Double ((inLeft.y - inRight.y).cuValue)
//    return .cu (sqrt (dx * dx + dy * dy))
//  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
