//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 09/06/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct CanariXYAnchor : Sendable, CanariShapeAnchorProtocol {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  var mPoint : CanariPoint {
    didSet {
      if self.mPoint != oldValue {
        self.computeAffinities ()
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private var mOriginCenteredLocalOutline : CanariPath
  private var mOriginCenteredLocalBoundingRect : CanariRect
  private var mOriginCenteredGlobalOutlineAndBoundingRect : CanariPathWithBoundingRect

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init () {
    self.init (origin: .zero)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (origin inOrigin : CanariPoint) {
    self.mPoint = inOrigin
    self.mOriginCenteredLocalOutline = CanariPath ()
    self.mOriginCenteredLocalBoundingRect = CanariRect ()
    self.mOriginCenteredGlobalOutlineAndBoundingRect = CanariPathWithBoundingRect ()
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
//    let affinity = CanariAffinity (rotation: self.mAngle)
//    let path = self.mOriginCenteredLocalOutline.transformed (using: affinity)
    self.mOriginCenteredGlobalOutlineAndBoundingRect = CanariPathWithBoundingRect (path: self.mOriginCenteredLocalOutline)
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

//  public func localOutline (containsLocalPointForMouseGesture inLocalPoint : CanariPoint) -> Bool {
//  //--- § À optimiser
//    var originCenteredLocalOutline = self.mOriginCenteredLocalOutline
//    let stroked = originCenteredLocalOutline.stroked (with: .px (1.0))
//    originCenteredLocalOutline.unionInPlaceUsingNonZeroRule (stroked)
//    return originCenteredLocalOutline.containsUsingNonZeroRule (inLocalPoint)
//  }

  public func outlineContainsGlobalPointForMouseGesture (_ inGlobalPoint : CanariPoint) -> Bool {
    let localPoint = self.globalToLocal (inGlobalPoint)
    return self.mOriginCenteredLocalOutline.containsUsingNonZeroRule (localPoint)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: With global outline
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func withGlobalOutline (action inAction : (CanariPath) -> Void) {
    inAction (self.mOriginCenteredGlobalOutlineAndBoundingRect.path.translated (by: self.mPoint))
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func withGlobalOutlineInLocalCoordinates (action inAction : (CanariPath) -> Void) {
//    let af = CanariAffinity ().rotating (-self.mAngle)
    inAction (self.mOriginCenteredGlobalOutlineAndBoundingRect.path) // .transformed (using: af))
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func globalOutlineIntersects (mouseGestureGlobalRect inGlobalRect : CanariRect) -> Bool {
    let globalRect = inGlobalRect.moved (by: -self.mPoint)
  //--- § À optimiser
    var originCenteredGlobalOutline = self.mOriginCenteredGlobalOutlineAndBoundingRect.path
    let stroked = originCenteredGlobalOutline.stroked (with: .px (1.0))
    originCenteredGlobalOutline.unionInPlaceUsingNonZeroRule (stroked)
    return originCenteredGlobalOutline.intersectsUsingNonZeroRule (globalRect)
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
//    let af = CanariAffinity ()
//      .rotating (-self.mAngle)
    inAction (CanariPath (rect: self.mOriginCenteredGlobalOutlineAndBoundingRect.boundingRect)) // .transformed (using: af))
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
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func transforming (toGlobal inGlobalOrientedOrigin : Self) -> Self {
    var result = self
    result.mPoint = inGlobalOrientedOrigin.localToGlobal (self.mPoint)
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
    self.mGlobalToLocalAffinity = CanariAffinity ()
      .translating (-self.mPoint)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Local to global
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var globalOrigin : CanariPoint { self.mPoint }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public mutating func alignGlobalOrigin (on inUnit : CanariLength) {
    self.mPoint = self.mPoint.aligning (to: inUnit)
  }

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
//     let localTranslation = CanariAffinity ()
//          .transforming (inGlobalTranslation)
    return inGlobalTranslation
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
//    let affinity = CanariAffinity ()
//      .rotating (self.mAngle)
//    let globalTranslation = inLocalTranslation.transformed(by: affinity)
    self.mPoint += inLocalTranslation
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
    let drawingScale = inDrawingScale
    inAction (&ioContext, drawingScale)
    ioContext.translate (by: -self.mPoint)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public static func == (_ inLeft  : Self, _ inRight : Self) -> Bool {
       (inLeft.mPoint  == inRight.mPoint)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @MainActor public static func anchorInspector <DOCUMENT_SHAPES_DISPLAY_SETTINGS, SHAPE_TYPES_DESCRIPTION : DocumentShapesDescriptionProtocol> (shapesUserInterface inShapesUserInterface : ShapesUserInterface <Self, DOCUMENT_SHAPES_DISPLAY_SETTINGS, SHAPE_TYPES_DESCRIPTION>) -> any View {
    return InspectorOfCanariXYAnchor (shapesUserInterface: inShapesUserInterface)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
