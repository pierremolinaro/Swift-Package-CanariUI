//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 09/06/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI
import Synchronization

//--------------------------------------------------------------------------------------------------

public struct CanariScaledOrientedOrigin : CustomStringConvertible, Sendable, Equatable {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private let mLocalBoundingRectCache : CanariComputationCache <CanariRect>
  private let mGlobalOutlineAndBoundingRectCache : CanariComputationCache <CanariPathWithBoundingRect>
  private var mLocalOutline : CanariPath

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var mOrigin : CanariPoint {
    didSet {
      if self.mOrigin != oldValue {
        self.computeAffinities ()
        self.launchGlobalOutlineAndBoundingRectComputation ()
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var mAngle : CanariAngle {
    didSet {
      if self.mAngle != oldValue {
        self.computeAffinities ()
        self.launchGlobalOutlineAndBoundingRectComputation ()
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var mScale : Double {
    didSet {
      if self.mScale != oldValue {
        self.computeAffinities ()
        self.launchGlobalOutlineAndBoundingRectComputation ()
      }
    }
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

  public var description : String { "(\(mOrigin), \(mAngle), \(self.mScale))" }

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

  public mutating func updateFromOrientedOrigin (_ inOrientedOrigin : CanariScaledOrientedOrigin) {
    self.mOrigin = inOrientedOrigin.localToGlobal (self.mOrigin)
    self.mAngle += inOrientedOrigin.mAngle
    self.mScale *= inOrientedOrigin.mScale
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------

fileprivate final class CanariComputationCache <CachedResult : Equatable & Sendable> : Sendable {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private enum InternalState : Equatable {
    case computing
    case waiting
    case computed (CachedResult)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private let mState : Mutex <InternalState>
  private let mCriticalSection = DispatchSemaphore (value: 1)
  private let mWaitingStateSemaphore = DispatchSemaphore (value: 0)
  private let mDefaultResult : CachedResult

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  init (defaultResult inDefaultResult : CachedResult) {
    self.mDefaultResult = inDefaultResult
    self.mState = Mutex <InternalState> (.computed (inDefaultResult))
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func launchComputing (withComputeFunction inComputeFunction : @escaping @Sendable () -> CachedResult) {
    self.mState.withLock {
      $0 = .computing
      Task.detached {
        enterTracing ("computed.cache.run") ; defer { exitTracing ("computed.cache.run") }
        let result = inComputeFunction ()
        self.mState.withLock {
          if $0 == .waiting {
            self.mWaitingStateSemaphore.signal ()
          }
          $0 = .computed (result)
        }
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func getComputedResult () -> CachedResult {
    enterTracing ("computed.cache.get") ; defer { exitTracing ("computed.cache.get") }
    self.mCriticalSection.wait ()
    var isWaiting = true
    var result = self.mDefaultResult
    while isWaiting {
      self.mState.withLock {
        switch $0 {
        case .computing :
          isWaiting = true
          $0 = .waiting
        case .waiting :
          ()
        case .computed (let r) :
          isWaiting = false
          result = r
        }
      }
      if isWaiting {
        self.mWaitingStateSemaphore.wait ()
      }
    }
    self.mCriticalSection.signal ()
    return result
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------

extension CanariComputationCache : Equatable {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  static func == (lhs: borrowing CanariComputationCache,
                  rhs: borrowing CanariComputationCache) -> Bool {
    true
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

