//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 11/05/2024.
//--------------------------------------------------------------------------------------------------

import AppKit

//--------------------------------------------------------------------------------------------------
//  struct CanariPoint
//--------------------------------------------------------------------------------------------------

public struct CanariPoint : Hashable, CustomStringConvertible, Sendable {

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

  public var xMirrored : CanariPoint {
    return CanariPoint (x: -self.x, y: self.y)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var yMirrored : CanariPoint {
    return CanariPoint (x: self.x, y: -self.y)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func scaled (byX inScaleX : Double, byY inScaleY : Double) -> CanariPoint {
    return CanariPoint (x: self.x * inScaleX, y: self.y * inScaleY)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func scaled (by inScale : Double) -> CanariPoint {
    return CanariPoint (x: self.x * inScale, y: self.y * inScale)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func aligning (to inUnit : CanariLength?) -> CanariPoint {
    return CanariPoint (x: self.x.aligning (to: inUnit), y: self.y.aligning (to: inUnit))
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func isAligned (_ inUnit : CanariLength) -> Bool {
    return self.x.isAligned (inUnit) && self.y.isAligned (inUnit)
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

  func distance (to inPoint : CanariPoint) -> CanariLength {
    let dx = (self.x - inPoint.x).cuValue
    let dy = (self.y - inPoint.y).cuValue
    return .cu (sqrt (Double (dx * dx + dy * dy)))
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func squareOfDistance (to inPoint : CanariPoint) -> Double {
    let dx = (self.x - inPoint.x).pxValue
    let dy = (self.y - inPoint.y).pxValue
    return dx * dx + dy * dy
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var pxValue : NSPoint {
    return NSPoint (x: self.x.pxValue, y: self.y.pxValue)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var cmValue : String {
    unsafe String (format: "%.3f", self.x.cmValue) + ", " + String (format: "%.3f", self.y.cmValue)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var burningKitCode : String {
    unsafe "Point (x: .mm (" + String (format: "%.3f", self.x.mmValue) + "), y : .mm (" + String (format: "%.3f", self.y.mmValue) + "))"
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
    let dyMM = (inPoint.y - self.y).mmValue
    let dxMM = (inPoint.x - self.x).mmValue
    return .radians (Darwin.atan2 (dyMM, dxMM))
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public static func distance (_ inLeft : CanariPoint, _ inRight : CanariPoint) -> CanariLength {
    let dxMM = (inLeft.x - inRight.x).mmValue
    let dyMM = (inLeft.y - inRight.y).mmValue
    return .mm (sqrt (dxMM * dxMM + dyMM * dyMM))
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
