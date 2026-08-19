//
//  CanariShapeAnchorProtocol.swift
//  CanariUI
//
//  Created by Pierre Molinaro on 08/07/2026.
//
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public protocol CanariShapeAnchorProtocol : Sendable, Codable, Equatable {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  init (origin inOrigin : CanariPoint)

  static func == (_ inLeft  : Self, _ inRight : Self) -> Bool

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Bounding Rect
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func withLocalBoundingRect (action inAction : (CanariRect) -> Void)

  var globalBoundingRect : CanariRect { get }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Global Outline
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  var globalOutline : CanariPath { get }

  func withGlobalOutline (action inAction : (CanariPath) -> Void)

  func globalOutlineIntersects (mouseGestureGlobalRect inGlobalRect : CanariRect) -> Bool

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Local Outline
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  mutating func setLocalOutline (_ inLocalOutLine : CanariPath)

  func withLocalCoordinates (context ioContext: inout GraphicsContext,
                             drawingScale inDrawingScale : Double,
                             action inAction : (inout GraphicsContext, Double) -> Void)

  func withLocalOutline (action inAction : (CanariPath) -> Void)

  func outlineContainsGlobalPointForMouseGesture (_ inGlobalPoint : CanariPoint) -> Bool

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Global origin
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  var globalOrigin : CanariPoint { get }

  mutating func alignGlobalOrigin (on inUnit : CanariLength)

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Translation
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  mutating func addGlobalTranslation (_ inGlobalTranslation : CanariPoint)

  mutating func addLocalTranslation (_ inLocalTranslation: CanariPoint)

  func globalTranslationToLocalTranslation (_ inGlobalTranslation : CanariPoint) -> CanariPoint

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Rotation
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  mutating func addRotation (_ inAngle : CanariAngle)
  
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Local to Global
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func localToGlobal (_ inPoint : CanariPoint) -> CanariPoint

  func localToGlobal (_ inLocalRect : CanariRect) -> CanariPath

  func localToGlobal (_ inLocalPath : CanariPath) -> CanariPath

  func localToGlobal (_ inPointSet : [CanariPoint]) -> Set <CanariPoint>

  mutating func transformToGlobal (_ inGlobalAnchor : Self)

  func transforming (toGlobal inGlobalAnchor : Self) -> Self

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Global to Local
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func globalToLocal (_ inCanvasPoint : CanariPoint) -> CanariPoint

  func globalToLocal (_ inCanvasPath : CanariPath) -> CanariPath

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Anchor Inspector
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @MainActor static func anchorInspector <DOCUMENT_SHAPES_DISPLAY_SETTINGS, SHAPE_TYPES_DESCRIPTION : DocumentShapesDescriptionProtocol> (shapesUserInterface inShapesUserInterface : ShapesUserInterface <Self, DOCUMENT_SHAPES_DISPLAY_SETTINGS, SHAPE_TYPES_DESCRIPTION>) -> any View

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
