//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 09/06/2026.
//--------------------------------------------------------------------------------------------------

import AppKit

//--------------------------------------------------------------------------------------------------

public struct CanariOrientedOrigin : Hashable, CustomStringConvertible, Sendable, Equatable {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var mOrigin : CanariPoint
  public var mAngle : CanariAngle
  public var mScale : Double

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (_ inOrigin : CanariPoint, _ inAngle : CanariAngle, _ inScale : Double) {
    self.mOrigin = inOrigin
    self.mAngle = inAngle
    self.mScale = inScale
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var description : String { "(\(mOrigin), \(mAngle), \(self.mScale))" }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Local to canvas
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var localToCanvasAffinity : CanariAffinity {
    CanariAffinity (translationByX: self.mOrigin.x, byY: self.mOrigin.y)
    .rotating (self.mAngle)
    .scaling (self.mScale)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func localToCanvas (x inX : CanariLength = .zero, y inY : CanariLength = .zero) -> CanariPoint {
    return CanariPoint (x: inX, y: inY).transformed (by: self.localToCanvasAffinity)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func localToCanvas (_ inPoint : CanariPoint) -> CanariPoint {
    return inPoint.transformed (by: self.localToCanvasAffinity)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func localToCanvas (_ inLocalRect : CanariRect) -> CanariPath {
    let path = CanariPath (rect: inLocalRect)
    return path.transformed (by: self.localToCanvasAffinity)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func localToCanvas (_ inPointSet : [CanariPoint]) -> Set <CanariPoint> {
    var result = Set <CanariPoint> ()
    for p in inPointSet {
      result.insert (p.transformed (by: self.localToCanvasAffinity))
    }
    return result
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func localToCanvas (_ inPath : CanariPath) -> CanariPath {
    return inPath.transformed (by: self.localToCanvasAffinity)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Canvas to local
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var canvasToLocalAffinity : CanariAffinity {
    CanariAffinity (scale: 1.0 / self.mScale)
      .rotating (-self.mAngle)
      .translating (x: -self.mOrigin.x, y: -self.mOrigin.y)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func canvasToLocal (_ inCanvasPoint : CanariPoint) -> CanariPoint {
    return inCanvasPoint.transformed (by: self.canvasToLocalAffinity)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func canvasToLocal (_ inCanvasPath : CanariPath) -> CanariPath {
    return inCanvasPath.transformed (by: self.canvasToLocalAffinity)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

//  public mutating func translate (x inX : CanariLength = .zero, y inY : CanariLength = .zero) {
//    self.mOrigin.x += inX
//    self.mOrigin.y += inY
//  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

//  public mutating func translate (_ inPoint : CanariPoint) {
//    self.mOrigin += inPoint
//  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public mutating func rotate (_ inAngle : CanariAngle) {
    self.mAngle += inAngle
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
