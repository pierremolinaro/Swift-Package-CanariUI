//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 09/06/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct CanariScaledOrientedAnchor : Sendable, CanariShapeAnchorProtocol {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  var mPoint : CanariPoint {
    didSet {
      if self.mPoint != oldValue {
        self.computeAffinities ()
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  var mAngle : CanariAngle {
    didSet {
      if self.mAngle != oldValue {
        self.computeAffinities ()
        let x = self.mOriginCenteredGlobalOutlineAndBoundingRect.rotated (by: self.mAngle - oldValue)
        self.mOriginCenteredGlobalOutlineAndBoundingRect = x
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  var mScale : Double {
    didSet {
      if self.mScale != oldValue {
        self.computeAffinities ()
        let r = self.mOriginCenteredGlobalOutlineAndBoundingRect.scaled (by: self.mScale / oldValue)
        self.mOriginCenteredGlobalOutlineAndBoundingRect = r
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  var mHorizontalFlip : Bool {
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

  public init (origin inOrigin : CanariPoint = .zero,
               angle inAngle : CanariAngle = .zero,
               scale inScale : Double = 1.0,
               hFlip inHorizontalFlip : Bool = false) {
    self.mPoint = inOrigin
    self.mAngle = inAngle
    self.mScale = inScale
    self.mHorizontalFlip = inHorizontalFlip
    self.mOriginCenteredLocalOutline = CanariPath ()
    self.mOriginCenteredLocalBoundingRect = CanariRect ()
    self.mOriginCenteredGlobalOutlineAndBoundingRect = CanariPathWithBoundingRect ()
    self.computeAffinities ()
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (origin inOrigin : CanariPoint) {
    self.init (origin: inOrigin, angle: .zero, scale: 1.0, hFlip: false)
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
    let path = self.mOriginCenteredLocalOutline.transformed (using: affinity)
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

  public func localOutline (containsLocalPointForMouseGesture inLocalPoint : CanariPoint) -> Bool {
  //--- § À optimiser
    var originCenteredLocalOutline = self.mOriginCenteredLocalOutline
    let stroked = originCenteredLocalOutline.stroked (with: .px (1.0))
    originCenteredLocalOutline.unionInPlaceUsingNonZeroRule (stroked)
    return originCenteredLocalOutline.containsUsingNonZeroRule (inLocalPoint)
 //   return self.mOriginCenteredLocalOutline.contains (inLocalPoint)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: With global outline
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func withGlobalOutline (action inAction : (CanariPath) -> Void) {
    inAction (self.mOriginCenteredGlobalOutlineAndBoundingRect.path.translated (by: self.mPoint))
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func withGlobalOutlineInLocalCoordinates (action inAction : (CanariPath) -> Void) {
    let af = CanariAffinity ()
      .scaling (1.0 / self.mScale, horizontalFlip: self.mHorizontalFlip)
      .rotating (-self.mAngle)
    inAction (self.mOriginCenteredGlobalOutlineAndBoundingRect.path.transformed (using: af))
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func globalOutlineIntersects (mouseGestureGlobalRect inGlobalRect : CanariRect) -> Bool {
    let globalRect = inGlobalRect.moved (by: -self.mPoint)
  //--- § À optimiser
    var originCenteredGlobalOutline = self.mOriginCenteredGlobalOutlineAndBoundingRect.path
    let stroked = originCenteredGlobalOutline.stroked (with: .px (1.0))
    originCenteredGlobalOutline.unionInPlaceUsingNonZeroRule (stroked)
    return originCenteredGlobalOutline.intersectsUsingNonZeroRule (globalRect)
//    if self.mOriginCenteredGlobalOutlineAndBoundingRect.boundingRect.isEmpty {
//      return self.mOriginCenteredGlobalOutlineAndBoundingRect.path.intersectsLines (of: globalRect)
//    }else{
//      return self.mOriginCenteredGlobalOutlineAndBoundingRect.boundingRect.intersects (globalRect)
//              &&
//             self.mOriginCenteredGlobalOutlineAndBoundingRect.path.intersects (globalRect)
//    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var globalOutline : CanariPath {
    self.mOriginCenteredGlobalOutlineAndBoundingRect.path.translated (by: self.mPoint)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: With global bounding rect
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var globalBoundingRect : CanariRect {
    self.mOriginCenteredGlobalOutlineAndBoundingRect.boundingRect.moved (by: self.mPoint)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func withGlobalBoundingRectInLocalCoordinates (action inAction : (CanariPath) -> Void) {
    let af = CanariAffinity ()
      .scaling (1.0 / self.mScale, horizontalFlip: self.mHorizontalFlip)
      .rotating (-self.mAngle)
    inAction (CanariPath (rect: self.mOriginCenteredGlobalOutlineAndBoundingRect.boundingRect).transformed (using: af))
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Validate translation
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func validateTranslationWithinCanvas (_ ioTranslation : inout CanariPoint,
                                               _ inCanvasSize : CanariSize) {
    let r = self.mOriginCenteredGlobalOutlineAndBoundingRect.boundingRect.moved (by: self.mPoint)
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
                                   relativeTo inUnselectedShapeOutlines : [CanariPath]) {
    var idx = 0
    while !ioTranslation.isZero, idx < inUnselectedShapeOutlines.count {
      let intersects = inUnselectedShapeOutlines [idx].intersectsUsingNonZeroRule (self.globalOutline.translated (by: ioTranslation))
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

  public mutating func transformToGlobal (_ inGlobalAnchor : Self) {
    self.mPoint = inGlobalAnchor.localToGlobal (self.mPoint)
    self.mAngle += inGlobalAnchor.mAngle
    self.mScale *= inGlobalAnchor.mScale
    self.mHorizontalFlip = self.mHorizontalFlip != inGlobalAnchor.mHorizontalFlip
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func transforming (toGlobal inGlobalOrientedOrigin : Self) -> Self {
    var result = self
    result.mPoint = inGlobalOrientedOrigin.localToGlobal (self.mPoint)
    result.mAngle += inGlobalOrientedOrigin.mAngle
    result.mScale *= inGlobalOrientedOrigin.mScale
    result.mHorizontalFlip = result.mHorizontalFlip != inGlobalOrientedOrigin.mHorizontalFlip
    return result
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Local <--> global affinities
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private var mLocalToGlobalAffinity = CanariAffinity ()
  private var mGlobalToLocalAffinity = CanariAffinity ()

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private mutating func computeAffinities () {
    self.mLocalToGlobalAffinity = CanariAffinity ()
      .translating (self.mPoint)
      .rotating (self.mAngle)
      .scaling (self.mScale, horizontalFlip: self.mHorizontalFlip)
    self.mGlobalToLocalAffinity = CanariAffinity ()
      .scaling (1.0 / self.mScale, horizontalFlip: self.mHorizontalFlip)
      .rotating (-self.mAngle)
      .translating (-self.mPoint)
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
    return path.transformed (using: self.mLocalToGlobalAffinity)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func localToGlobal (_ inLocalPath : CanariPath) -> CanariPath {
    return inLocalPath.transformed (using: self.mLocalToGlobalAffinity)
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

  public func globalTranslationToLocalTranslation (_ inGlobalTranslation : CanariPoint) -> CanariPoint {
     let localTranslation = CanariAffinity (scale: 1.0 / self.mScale)
          .rotating (-self.mAngle)
          .transforming (inGlobalTranslation)
    return localTranslation
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func globalToLocal (_ inCanvasPoint : CanariPoint) -> CanariPoint {
    return inCanvasPoint.transformed (by: self.mGlobalToLocalAffinity)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func globalToLocal (_ inCanvasPath : CanariPath) -> CanariPath {
    return inCanvasPath.transformed (using: self.mGlobalToLocalAffinity)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Add translation
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public mutating func addLocalTranslation (_ inLocalTranslation : CanariPoint) {
    let affinity = CanariAffinity ()
      .rotating (self.mAngle)
      .scaling (self.mScale)
    let globalTranslation = inLocalTranslation.transformed(by: affinity)
    self.mPoint += globalTranslation
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public mutating func addGlobalTranslation (_ inGlobalTranslation : CanariPoint) {
    self.mPoint += inGlobalTranslation
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func withLocalCoordinates (context ioContext: inout GraphicsContext,
                                    drawingScale inDrawingScale : Double,
                                    action inAction : (inout GraphicsContext, Double) -> Void) {
    ioContext.translate (by: self.mPoint)
    ioContext.rotate (by: self.mAngle)
    ioContext.scale (by: self.mScale, horizontalFlip: self.mHorizontalFlip)
    let drawingScale = inDrawingScale * self.mScale
    inAction (&ioContext, drawingScale)
    ioContext.scale (by: 1.0 / self.mScale, horizontalFlip: self.mHorizontalFlip)
    ioContext.rotate (by: -self.mAngle)
    ioContext.translate (by: -self.mPoint)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public static func == (_ inLeft  : Self, _ inRight : Self) -> Bool {
       (inLeft.mPoint  == inRight.mPoint)
    && (inLeft.mAngle == inRight.mAngle)
    && (inLeft.mScale == inRight.mScale)
    && (inLeft.mHorizontalFlip == inRight.mHorizontalFlip)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @MainActor public static func anchorInspector <SHAPE_TYPES_DESCRIPTION : DocumentShapesDescriptionProtocol> (shapesUserInterface inShapesUserInterface : ShapesUserInterface <Self, SHAPE_TYPES_DESCRIPTION>) -> any View {
    return InspectorOfCanariScaledOrientedAnchor (shapesUserInterface: inShapesUserInterface)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
