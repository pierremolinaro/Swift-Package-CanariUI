//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 09/06/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI
import Synchronization

//--------------------------------------------------------------------------------------------------

fileprivate nonisolated let gLocalBoundingRectCache = Mutex <[UUID : CanariRect]> ([:])
fileprivate nonisolated let gGlobalOutlineCache = Mutex <[UUID : CanariPath]> ([:])
fileprivate nonisolated let gGlobalBoundingRectCache = Mutex <[UUID : CanariRect]> ([:])

//--------------------------------------------------------------------------------------------------

public struct CanariScaledOrientedOrigin : CustomStringConvertible, Sendable, Equatable {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var mOrigin : CanariPoint {
    didSet {
      if self.mOrigin != oldValue {
        gLocalBoundingRectCache.withLock { $0 [self.id] = nil }
        gGlobalOutlineCache.withLock { $0 [self.id] = nil }
        gGlobalBoundingRectCache.withLock { $0 [self.id] = nil }
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var mAngle : CanariAngle {
    didSet {
      if self.mAngle != oldValue {
        gLocalBoundingRectCache.withLock { $0 [self.id] = nil }
        gGlobalOutlineCache.withLock { $0 [self.id] = nil }
        gGlobalBoundingRectCache.withLock { $0 [self.id] = nil }
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var mScale : Double {
    didSet {
      if self.mScale != oldValue {
        gLocalBoundingRectCache.withLock { $0 [self.id] = nil }
        gGlobalOutlineCache.withLock { $0 [self.id] = nil }
        gGlobalBoundingRectCache.withLock { $0 [self.id] = nil }
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private var mLocalOutline : CanariPath
  private let id : UUID

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (_ inOrigin : CanariPoint,
               _ inAngle : CanariAngle,
               _ inScale : Double) {
    self.mOrigin = inOrigin
    self.mAngle = inAngle
    self.mScale = inScale
    self.mLocalOutline = CanariPath ()
    self.id = UUID ()
  }

//  isolated deinit { }
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var localOutline : CanariPath { self.mLocalOutline }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public mutating func setLocalOutline (_ inLocalOutLine : CanariPath) {
    self.mLocalOutline = inLocalOutLine
    gLocalBoundingRectCache.withLock { $0 [self.id] = nil }
    gGlobalOutlineCache.withLock { $0 [self.id] = nil }
    gGlobalBoundingRectCache.withLock { $0 [self.id] = nil }

  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var localBoundingRect : CanariRect {
    if let r = gLocalBoundingRectCache.withLock ({ $0 [self.id] }) {
      return r
    }else{
      let r = self.localToGlobal (self.localOutline).boundingRect
      gLocalBoundingRectCache.withLock { $0 [self.id] = r }
      return r
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var globalOutline : CanariPath {
    if let path = gGlobalOutlineCache.withLock ({ $0 [self.id] }) {
      return path
    }else{
      let path = self.localToGlobal (self.localOutline)
      gGlobalOutlineCache.withLock { $0 [self.id] = path }
      return path
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var globalBoundingRect : CanariRect {
    if let r = gGlobalBoundingRectCache.withLock ({ $0 [self.id] }) {
      return r
    }else{
      let r = self.localToGlobal (self.localOutline).boundingRect
      gGlobalBoundingRectCache.withLock { $0 [self.id] = r }
      return r
    }
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
