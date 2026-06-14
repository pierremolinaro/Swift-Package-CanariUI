//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 09/06/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct CanariScaledOrientedOrigin : CustomStringConvertible, Sendable, Equatable {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var mOrigin : CanariPoint {
    didSet {
      if self.mOrigin != oldValue {
        self.mGlobalOutlineAndBoundingRect = CanariPathWithBoundingRect (self.localToGlobal (self.mLocalOutlineAndBoundingRect.path))
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var mAngle : CanariAngle {
    didSet {
      if self.mAngle != oldValue {
        self.mGlobalOutlineAndBoundingRect = CanariPathWithBoundingRect (self.localToGlobal (self.mLocalOutlineAndBoundingRect.path))
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var mScale : Double {
    didSet {
      if self.mScale != oldValue {
        self.mGlobalOutlineAndBoundingRect = CanariPathWithBoundingRect (self.localToGlobal (self.mLocalOutlineAndBoundingRect.path))
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private var mLocalOutlineAndBoundingRect : CanariPathWithBoundingRect
  private var mGlobalOutlineAndBoundingRect : CanariPathWithBoundingRect

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (_ inOrigin : CanariPoint,
               _ inAngle : CanariAngle,
               _ inScale : Double) {
    self.mOrigin = inOrigin
    self.mAngle = inAngle
    self.mScale = inScale
    self.mLocalOutlineAndBoundingRect = CanariPathWithBoundingRect (CanariPath ())
    self.mGlobalOutlineAndBoundingRect = CanariPathWithBoundingRect (CanariPath ())
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var localOutline : CanariPath { self.mLocalOutlineAndBoundingRect.path }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public mutating func setLocalOutline (_ inLocalOutLine : CanariPath) {
    self.mLocalOutlineAndBoundingRect = CanariPathWithBoundingRect (inLocalOutLine)
    self.mGlobalOutlineAndBoundingRect = CanariPathWithBoundingRect (self.localToGlobal (self.mLocalOutlineAndBoundingRect.path))
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var localBoundingRect : CanariRect {
    self.mLocalOutlineAndBoundingRect.boundingRect
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var globalOutline : CanariPath {
    self.mGlobalOutlineAndBoundingRect.path
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var globalBoundingRect : CanariRect {
    self.mGlobalOutlineAndBoundingRect.boundingRect
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var description : String { "(\(mOrigin), \(mAngle), \(self.mScale))" }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Local to global
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private var localToGlobalAffinity : CanariAffinity {
    CanariAffinity (translationByX: self.mOrigin.x, byY: self.mOrigin.y)
    .rotating (self.mAngle)
    .scaling (self.mScale)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func localToGlobal (x inX : CanariLength = .zero, y inY : CanariLength = .zero) -> CanariPoint {
    return CanariPoint (x: inX, y: inY).transformed (by: self.localToGlobalAffinity)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func localToGlobal (_ inPoint : CanariPoint) -> CanariPoint {
    return inPoint.transformed (by: self.localToGlobalAffinity)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func localToGlobal (_ inLocalRect : CanariRect) -> CanariPath {
    let path = CanariPath (rect: inLocalRect)
    return path.transformed (by: self.localToGlobalAffinity)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func localToGlobal (_ inPointSet : [CanariPoint]) -> Set <CanariPoint> {
    var result = Set <CanariPoint> ()
    for p in inPointSet {
      result.insert (p.transformed (by: self.localToGlobalAffinity))
    }
    return result
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func localToGlobal (_ inPath : CanariPath) -> CanariPath {
    return inPath.transformed (by: self.localToGlobalAffinity)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Canvas to local
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private var globalToLocalAffinity : CanariAffinity {
    CanariAffinity (scale: 1.0 / self.mScale)
      .rotating (-self.mAngle)
      .translating (x: -self.mOrigin.x, y: -self.mOrigin.y)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func globalToLocal (_ inCanvasPoint : CanariPoint) -> CanariPoint {
    return inCanvasPoint.transformed (by: self.globalToLocalAffinity)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func globalToLocal (_ inCanvasPath : CanariPath) -> CanariPath {
    return inCanvasPath.transformed (by: self.globalToLocalAffinity)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public mutating func updateFromOrientedOrigin (_ inOrientedOrigin : CanariScaledOrientedOrigin) {
    self.mOrigin = inOrientedOrigin.localToGlobal (self.mOrigin)
    self.mAngle += inOrientedOrigin.mAngle
    self.mScale *= inOrientedOrigin.mScale
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
