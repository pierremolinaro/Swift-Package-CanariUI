//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 09/06/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct CanariScaledOrientedOrigin : Sendable, Equatable {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var mOrigin : CanariPoint {
    didSet {
      if self.mOrigin != oldValue {
        self.computeAffinities ()
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var mAngle : CanariAngle {
    didSet {
      if self.mAngle != oldValue {
        self.computeAffinities ()
        self.mOriginCenteredGlobalOutlineAndBoundingRect = self.mOriginCenteredGlobalOutlineAndBoundingRect.rotated (by: self.mAngle - oldValue)
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var mScale : Double {
    didSet {
      if self.mScale != oldValue {
        self.computeAffinities ()
        self.mOriginCenteredGlobalOutlineAndBoundingRect = self.mOriginCenteredGlobalOutlineAndBoundingRect.scaled (by: self.mScale / oldValue)
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private var mOriginCenteredLocalOutline : CanariPath
  private var mOriginCenteredLocalBoundingRect : CanariRect
  private var mOriginCenteredGlobalOutlineAndBoundingRect : CanariPathWithBoundingRect

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (_ inOrigin : CanariPoint,
               _ inAngle : CanariAngle,
               _ inScale : Double) {
    self.mOrigin = inOrigin
    self.mAngle = inAngle
    self.mScale = inScale
    self.mOriginCenteredLocalOutline = .init ()
    self.mOriginCenteredLocalBoundingRect = .init ()
    self.mOriginCenteredGlobalOutlineAndBoundingRect = .init ()
    self.computeAffinities ()
  }


  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public mutating func setLocalOutline (_ inLocalOutLine : CanariPath) {
    self.mOriginCenteredLocalOutline = inLocalOutLine
    self.mOriginCenteredLocalBoundingRect = inLocalOutLine.boundingRect
    let affinity = CanariAffinity (rotation: self.mAngle).scaling (self.mScale)
    self.mOriginCenteredGlobalOutlineAndBoundingRect = CanariPathWithBoundingRect (inLocalOutLine.transformed (by: affinity))
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: With local bounding rect
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func withLocalBoundingRect (action inAction : (CanariRect) -> Void) {
    inAction (self.mOriginCenteredLocalBoundingRect)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: With local outline
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func withLocalOutline (action inAction : (CanariPath) -> Void) {
    inAction (self.mOriginCenteredLocalOutline)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func localOutline (containsLocalPoint inLocalPoint : CanariPoint) -> Bool {
    return self.mOriginCenteredLocalOutline.contains (inLocalPoint)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: With global outline
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func withGlobalOutline (action inAction : (CanariPath) -> Void) {
    inAction (self.mOriginCenteredGlobalOutlineAndBoundingRect.path.moved (by: self.mOrigin))
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func globalOutlineIntersects (globalRect inGlobalRect : CanariRect) -> Bool {
    let globalRect = inGlobalRect.moved (by: -self.mOrigin)
    return self.mOriginCenteredGlobalOutlineAndBoundingRect.boundingRect.intersects (globalRect)
            &&
           self.mOriginCenteredGlobalOutlineAndBoundingRect.path.intersects (globalRect)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: With global bounding rect
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var globalBoundingRect : CanariRect {
    self.mOriginCenteredGlobalOutlineAndBoundingRect.boundingRect.moved (by: self.mOrigin)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: With global bounding rect
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public mutating func transformToGlobal (_ inGlobalOrientedOrigin : borrowing CanariScaledOrientedOrigin) {
    self.mOrigin = inGlobalOrientedOrigin.localToGlobal (self.mOrigin)
    self.mAngle += inGlobalOrientedOrigin.mAngle
    self.mScale *= inGlobalOrientedOrigin.mScale
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

//  public func localToGlobal (_ inPath : CanariPath) -> CanariPath {
//    return inPath.transformed (by: self.mLocalToGlobalAffinity)
//  }

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
