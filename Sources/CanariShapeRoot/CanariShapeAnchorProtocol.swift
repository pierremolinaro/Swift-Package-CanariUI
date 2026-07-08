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

  @MainActor static func anchorInspector <ANCHOR : CanariShapeAnchorProtocol, SHAPE_TYPES_DESCRIPTION : DocumentShapesDescriptionProtocol> (shapesUserInterface inShapesUserInterface : ShapesUserInterface <ANCHOR, SHAPE_TYPES_DESCRIPTION>) -> any View

  func withLocalBoundingRect (action inAction : (CanariRect) -> Void)

  func globalTranslationToLocalTranslation (_ inGlobalTranslation : CanariPoint) -> CanariPoint

  static func == (_ inLeft  : Self, _ inRight : Self) -> Bool

  init (origin inOrigin : CanariPoint)

  var globalBoundingRect : CanariRect { get }

  mutating func setLocalOutline (_ inLocalOutLine : CanariPath)

  func withGlobalOutline (action inAction : (CanariPath) -> Void)

  func globalOutlineIntersects (mouseGestureGlobalRect inGlobalRect : CanariRect) -> Bool

  func withLocalCoordinates (context ioContext: inout GraphicsContext,
                             drawingScale inDrawingScale : Double,
                             action inAction : (inout GraphicsContext, Double) -> Void)

  mutating func transformToGlobal (_ inGlobalAnchor : Self)

  func transforming (toGlobal inGlobalAnchor : Self) -> Self

  mutating func addGlobalTranslation (_ inGlobalTranslation : CanariPoint)

  mutating func addLocalTranslation (_ inLocalTranslation: CanariPoint)

  func withLocalOutline (action inAction : (CanariPath) -> Void)

  func localOutline (containsLocalPointForMouseGesture inLocalPoint : CanariPoint) -> Bool

  func localToGlobal (_ inPoint : CanariPoint) -> CanariPoint

  func localToGlobal (_ inLocalRect : CanariRect) -> CanariPath

  func localToGlobal (_ inLocalPath : CanariPath) -> CanariPath

  func localToGlobal (_ inPointSet : [CanariPoint]) -> Set <CanariPoint>

  func globalToLocal (_ inCanvasPoint : CanariPoint) -> CanariPoint

  func globalToLocal (_ inCanvasPath : CanariPath) -> CanariPath

}

//--------------------------------------------------------------------------------------------------
