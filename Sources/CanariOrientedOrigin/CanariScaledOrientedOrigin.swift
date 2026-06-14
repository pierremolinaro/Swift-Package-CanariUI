//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 09/06/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct CanariScaledOrientedOrigin : Sendable, Equatable {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private let mLocalBoundingRectCache : CanariComputationCache <CanariRect>
  private let mGlobalOutlineAndBoundingRectCache : CanariComputationCache <CanariPathWithBoundingRect>
  private var mLocalOutline : CanariPath
  private var mComputationsAreDelayed = false

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var mOrigin : CanariPoint {
    didSet {
      if self.mOrigin != oldValue, !self.mComputationsAreDelayed {
        self.computeAffinities ()
        self.launchGlobalOutlineAndBoundingRectComputation ()
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var mAngle : CanariAngle {
    didSet {
      if self.mAngle != oldValue, !self.mComputationsAreDelayed {
        self.computeAffinities ()
        self.launchGlobalOutlineAndBoundingRectComputation ()
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var mScale : Double {
    didSet {
      if self.mScale != oldValue, !self.mComputationsAreDelayed {
        self.computeAffinities ()
        self.launchGlobalOutlineAndBoundingRectComputation ()
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public mutating func updateFromOrientedOrigin (_ inOrientedOrigin : borrowing CanariScaledOrientedOrigin) {
    self.mComputationsAreDelayed = true
    self.mOrigin = inOrientedOrigin.localToGlobal (self.mOrigin)
    self.mAngle += inOrientedOrigin.mAngle
    self.mScale *= inOrientedOrigin.mScale
    self.mComputationsAreDelayed = false
    self.computeAffinities ()
    self.launchGlobalOutlineAndBoundingRectComputation ()
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (_ inOrigin : CanariPoint,
               _ inAngle : CanariAngle,
               _ inScale : Double) {
    self.mOrigin = inOrigin
    self.mAngle = inAngle
    self.mScale = inScale
    self.mLocalOutline = CanariPath ()
    self.mGlobalOutlineAndBoundingRectCache = .init (defaultResult: CanariPathWithBoundingRect ())
    self.mLocalBoundingRectCache = .init (defaultResult: CanariRect ())
    self.computeAffinities ()
  }


  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (_ inOrientedOrigin : borrowing CanariScaledOrientedOrigin) {
    self.mOrigin = inOrientedOrigin.mOrigin
    self.mAngle = inOrientedOrigin.mAngle
    self.mScale = inOrientedOrigin.mScale
    self.mLocalOutline = CanariPath ()
    self.mComputationsAreDelayed = false
    self.mGlobalOutlineAndBoundingRectCache = .init (defaultResult: CanariPathWithBoundingRect ())
    self.mLocalBoundingRectCache = .init (defaultResult: CanariRect ())
  //---
    self.computeAffinities ()
    self.setLocalOutline (inOrientedOrigin.mLocalOutline)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var localOutline : CanariPath { self.mLocalOutline }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public mutating func setLocalOutline (_ inLocalOutLine : CanariPath) {
    self.mLocalOutline = inLocalOutLine
    self.mLocalBoundingRectCache.launchComputing { inLocalOutLine.boundingRect }
    let localToGlobalAffinity = self.mLocalToGlobalAffinity
    self.mGlobalOutlineAndBoundingRectCache.launchComputing {
      CanariPathWithBoundingRect (inLocalOutLine.transformed (by: localToGlobalAffinity))
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var localBoundingRect : CanariRect {
    self.mLocalBoundingRectCache.getComputedResult ()
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var globalOutline : CanariPath {
    self.mGlobalOutlineAndBoundingRectCache.getComputedResult().path
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var globalBoundingRect : CanariRect {
    self.mGlobalOutlineAndBoundingRectCache.getComputedResult().boundingRect
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Local <--> global affinities
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private var mLocalToGlobalAffinity = CanariAffinity ()
  private var mGlobalToLocalAffinity = CanariAffinity ()

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private mutating func computeAffinities () {
    self.mLocalToGlobalAffinity = CanariAffinity (translation: self.mOrigin)
      .rotating (self.mAngle)
      .scaling (self.mScale)
    self.mGlobalToLocalAffinity = CanariAffinity (scale: 1.0 / self.mScale)
      .rotating (-self.mAngle)
      .translating (-self.mOrigin)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Launch Global outline and bounding rect computations
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func launchGlobalOutlineAndBoundingRectComputation () {
    let localOutline = self.mLocalOutline
    let localToGlobalAffinity = self.mLocalToGlobalAffinity
    self.mGlobalOutlineAndBoundingRectCache.launchComputing {
      CanariPathWithBoundingRect (localOutline.transformed (by: localToGlobalAffinity))
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Local to global
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func localToGlobal (x inX : CanariLength = .zero, y inY : CanariLength = .zero) -> CanariPoint {
    return CanariPoint (x: inX, y: inY).transformed (by: self.mLocalToGlobalAffinity)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func localToGlobal (_ inPoint : CanariPoint) -> CanariPoint {
    return inPoint.transformed (by: self.mLocalToGlobalAffinity)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func localToGlobal (_ inLocalRect : CanariRect) -> CanariPath {
    let path = CanariPath (rect: inLocalRect)
    return path.transformed (by: self.mLocalToGlobalAffinity)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func localToGlobal (_ inPointSet : [CanariPoint]) -> Set <CanariPoint> {
    var result = Set <CanariPoint> ()
    for p in inPointSet {
      result.insert (p.transformed (by: self.mLocalToGlobalAffinity))
    }
    return result
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func localToGlobal (_ inPath : CanariPath) -> CanariPath {
    return inPath.transformed (by: self.mLocalToGlobalAffinity)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Global to local
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func globalToLocal (_ inCanvasPoint : CanariPoint) -> CanariPoint {
    return inCanvasPoint.transformed (by: self.mGlobalToLocalAffinity)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func globalToLocal (_ inCanvasPath : CanariPath) -> CanariPath {
    return inCanvasPath.transformed (by: self.mGlobalToLocalAffinity)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
