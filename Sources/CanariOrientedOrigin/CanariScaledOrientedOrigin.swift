//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 09/06/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct CanariScaledOrientedOrigin : Sendable, Equatable, Codable, CustomStringConvertible {

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
        let x = self.mOriginCenteredGlobalOutlineAndBoundingRect.rotated (by: self.mAngle - oldValue)
        self.mOriginCenteredGlobalOutlineAndBoundingRect = x
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

  public var mHorizontalFlip : Bool {
    didSet {
      if self.mHorizontalFlip != oldValue {
        self.computeAffinities ()
        self.computeOriginCenteredGlobalOutlineAndBoundingRect ()
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
               _ inScale : Double,
               _ inHorizontalFlip : Bool) {
    self.mOrigin = inOrigin
    self.mAngle = inAngle
    self.mScale = inScale
    self.mHorizontalFlip = inHorizontalFlip
    self.mOriginCenteredLocalOutline = .init ()
    self.mOriginCenteredLocalBoundingRect = .init ()
    self.mOriginCenteredGlobalOutlineAndBoundingRect = .init ()
    self.computeAffinities ()
  }


  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public mutating func setLocalOutline (_ inLocalOutLine : CanariPath) {
    self.mOriginCenteredLocalOutline = inLocalOutLine
    self.mOriginCenteredLocalBoundingRect = inLocalOutLine.boundingRect
    self.computeOriginCenteredGlobalOutlineAndBoundingRect ()
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private mutating func computeOriginCenteredGlobalOutlineAndBoundingRect () {
    let affinity = CanariAffinity (rotation: self.mAngle)
          .scaling (self.mScale, horizontalFlip: self.mHorizontalFlip)
    let path = self.mOriginCenteredLocalOutline.transformed (by: affinity)
    self.mOriginCenteredGlobalOutlineAndBoundingRect = CanariPathWithBoundingRect (path: path)
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

  public func withGlobalOutlineInLocalCoordinates (action inAction : (CanariPath) -> Void) {
    let af = CanariAffinity ()
      .scaling (1.0 / self.mScale, horizontalFlip: self.mHorizontalFlip)
      .rotating (-self.mAngle)
    inAction (self.mOriginCenteredGlobalOutlineAndBoundingRect.path.transformed (by: af))
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func globalOutlineIntersects (globalRect inGlobalRect : CanariRect) -> Bool {
    let globalRect = inGlobalRect.moved (by: -self.mOrigin)
    return self.mOriginCenteredGlobalOutlineAndBoundingRect.boundingRect.intersects (globalRect)
            &&
           self.mOriginCenteredGlobalOutlineAndBoundingRect.path.intersects (globalRect)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var globalOutline : CanariPath {
    self.mOriginCenteredGlobalOutlineAndBoundingRect.path.moved (by: self.mOrigin)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: With global bounding rect
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var globalBoundingRect : CanariRect {
    self.mOriginCenteredGlobalOutlineAndBoundingRect.boundingRect.moved (by: self.mOrigin)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func withGlobalBoundingRectInLocalCoordinates (action inAction : (CanariPath) -> Void) {
    let af = CanariAffinity ()
      .scaling (1.0 / self.mScale, horizontalFlip: self.mHorizontalFlip)
      .rotating (-self.mAngle)
    inAction (CanariPath (rect: self.mOriginCenteredGlobalOutlineAndBoundingRect.boundingRect).transformed (by: af))
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Validate translation
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func validateTranslationWithinCanvas (_ ioTranslation : inout CanariPoint,
                                               _ inCanvasSize : CanariSize) {
    let r = self.mOriginCenteredGlobalOutlineAndBoundingRect.boundingRect.moved (by: self.mOrigin)
    let newTopRight = r.topRight + ioTranslation
    if newTopRight.x > inCanvasSize.width {
      ioTranslation.x -= newTopRight.x - inCanvasSize.width
    }
    if newTopRight.y > inCanvasSize.height {
      ioTranslation.y -= newTopRight.y - inCanvasSize.height
    }
    let newBottomLeft = r.bottomLeft + ioTranslation
    if newBottomLeft.x < .zero {
      ioTranslation.x -= newBottomLeft.x
    }
    if newBottomLeft.y < .zero {
      ioTranslation.y -= newBottomLeft.y
    }
  }

 // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func validateTranslation (_ ioTranslation : inout CanariPoint,
                                   relativeTo inUnselectedWidgetOutlines : [CanariPath]) {
    var idx = 0
    while !ioTranslation.isZero, idx < inUnselectedWidgetOutlines.count {
      let intersects = inUnselectedWidgetOutlines [idx].intersects (self.globalOutline.moved (by: ioTranslation))
      if intersects {
        ioTranslation *= 0.5
      }else{
        idx += 1
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: transformToGlobal
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public mutating func transformToGlobal (_ inGlobalOrientedOrigin : borrowing CanariScaledOrientedOrigin) {
    self.mOrigin = inGlobalOrientedOrigin.localToGlobal (self.mOrigin)
    self.mAngle += inGlobalOrientedOrigin.mAngle
    self.mScale *= inGlobalOrientedOrigin.mScale
    self.mHorizontalFlip = self.mHorizontalFlip != inGlobalOrientedOrigin.mHorizontalFlip
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Local <--> global affinities
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private var mLocalToGlobalAffinity = CanariAffinity ()
  private var mGlobalToLocalAffinity = CanariAffinity ()

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private mutating func computeAffinities () {
    self.mLocalToGlobalAffinity = CanariAffinity ()
      .translating (self.mOrigin)
      .rotating (self.mAngle)
      .scaling (self.mScale, horizontalFlip: self.mHorizontalFlip)
    self.mGlobalToLocalAffinity = CanariAffinity ()
      .scaling (1.0 / self.mScale, horizontalFlip: self.mHorizontalFlip)
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

  public func localToGlobal (_ inLocalPath : CanariPath) -> CanariPath {
    return inLocalPath.transformed (by: self.mLocalToGlobalAffinity)
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
  //MARK: Add location translation
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  mutating func addLocalTranslation (_ inLocalTranslation: CanariPoint) {
    let affinity = CanariAffinity ()
      .rotating (self.mAngle)
      .scaling (self.mScale)
    let globalTranslation = inLocalTranslation.transformed(by: affinity)
    self.mOrigin += globalTranslation
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Codable
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (from inDecoder : any Decoder) throws { // Decodable
    let container = try inDecoder.singleValueContainer ()
    let string = try container.decode (String.self)
    let components = string.split (separator: " ")
    if components.count == 5,
       let x = Int (components [0]),
       let y = Int (components [1]),
       let angle = Int (components [2]),
       let scale = Double (components [3]),
       let hFlip = Int (components [4]) {
      self.init (
        CanariPoint (x: .cu (x), y: .cu (y)),
        CanariAngle (Double (angle) / 1000.0, in: .degrees),
        scale,
        hFlip != 0
      )
    }else {
      throw DecodingError.dataCorruptedError (in: container, debugDescription: "Invalid oriented origin string")
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func encode (to inEncoder : any Encoder) throws { // Encodable
    var container = inEncoder.singleValueContainer ()
    let angle = Int ((self.mAngle.degrees * 1000.0).rounded ())
    try container.encode ("\(self.mOrigin.x.cuValue) \(self.mOrigin.y.cuValue) \(angle) \(self.mScale) \(self.mHorizontalFlip ? 1 : 0)")
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: CustomStringConvertible
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var description : String { "(\(self.mOrigin), \(self.mAngle), \(self.mScale), \(self.mHorizontalFlip))" }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
