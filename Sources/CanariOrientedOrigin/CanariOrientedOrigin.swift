//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 09/06/2026.
//--------------------------------------------------------------------------------------------------

import AppKit

//--------------------------------------------------------------------------------------------------

public struct CanariOrientedOrigin : Hashable, CustomStringConvertible, Sendable, Equatable {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var mOrigin : CanariPoint
  public var mAngle : CanariAngle

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (_ inOrigin : CanariPoint, _ inAngle : CanariAngle) {
    self.mOrigin = inOrigin
    self.mAngle = inAngle
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var description : String { "(\(mOrigin), \(mAngle))" }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func localToCanvas (x inX : CanariLength = .zero, y inY : CanariLength = .zero) -> CanariPoint {
    let af = CanariAffinity (translationByX: self.mOrigin.x, byY: self.mOrigin.y).rotating (self.mAngle)
    return CanariPoint (x: inX, y: inY).transformed (by: af)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func localToCanvas (_ inPoint : CanariPoint) -> CanariPoint {
    let af = CanariAffinity (translationByX: self.mOrigin.x, byY: self.mOrigin.y).rotating (self.mAngle)
    return inPoint.transformed (by: af)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func localToCanvas (_ inLocalRect : CanariRect) -> CanariPath {
    let af = CanariAffinity (translationByX: self.mOrigin.x, byY: self.mOrigin.y).rotating (self.mAngle)
    let path = CanariPath (rect: inLocalRect)
    return path.transformed (by: af)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func localToCanvas (_ inPointSet : [CanariPoint]) -> Set <CanariPoint> {
    let af = CanariAffinity (translationByX: self.mOrigin.x, byY: self.mOrigin.y).rotating (self.mAngle)
    var result = Set <CanariPoint> ()
    for p in inPointSet {
      result.insert (p.transformed (by: af))
    }
    return result
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func localToCanvas (_ inPath : CanariPath) -> CanariPath {
    let af = CanariAffinity (translationByX: self.mOrigin.x, byY: self.mOrigin.y).rotating (self.mAngle)
    return inPath.transformed (by: af)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func canvasToLocal (_ inCanvasPoint : CanariPoint) -> CanariPoint {
    let af =  CanariAffinity (rotation: -self.mAngle).translating (x: -self.mOrigin.x, y: -self.mOrigin.y)
    return inCanvasPoint.transformed (by: af)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func canvasToLocal (_ inCanvasPath : CanariPath) -> CanariPath {
    let af =  CanariAffinity (rotation: -self.mAngle).translating (x: -self.mOrigin.x, y: -self.mOrigin.y)
    return inCanvasPath.transformed (by: af)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public mutating func translate (x inX : CanariLength = .zero, y inY : CanariLength = .zero) {
    self.mOrigin.x += inX
    self.mOrigin.y += inY
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public mutating func translate (_ inPoint : CanariPoint) {
    self.mOrigin += inPoint
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public mutating func rotate (_ inAngle : CanariAngle) {
    self.mAngle += inAngle
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
