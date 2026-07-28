//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 27/03/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public protocol CanariShapeDecorationProtocol <ANCHOR, DOCUMENT_SHAPES_DISPLAY_SETTINGS, SHAPE_TYPES_DESCRIPTION> : Sendable, Codable {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  associatedtype ANCHOR : CanariShapeAnchorProtocol
  associatedtype SHAPE_TYPES_DESCRIPTION : DocumentShapesDescriptionProtocol
  associatedtype DOCUMENT_SHAPES_DISPLAY_SETTINGS

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Draw
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func drawShape (context ioContext : inout GraphicsContext,
                  anchor inAnchor : ANCHOR,
                  documentShapeDisplaySettings inDisplaySettings : DOCUMENT_SHAPES_DISPLAY_SETTINGS,
                  drawingScale inDrawingScale : Double,
                  hovered inHovered : Bool,
                  selected inSelected : Bool,
                  groupLevel inGroupLevel : UInt)

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  var localOutlinePath : CanariPath { get }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func duplicated () -> (any CanariShapeDecorationProtocol <ANCHOR, DOCUMENT_SHAPES_DISPLAY_SETTINGS, SHAPE_TYPES_DESCRIPTION>)?

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  var shapeKnobs : [ShapeKnob <ANCHOR, DOCUMENT_SHAPES_DISPLAY_SETTINGS, SHAPE_TYPES_DESCRIPTION>] { get }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func contextualMenu (_ inExecutor : ContextualMenuExecutor <ANCHOR, DOCUMENT_SHAPES_DISPLAY_SETTINGS, SHAPE_TYPES_DESCRIPTION>) -> any View

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func isEqual (to inOther : any CanariShapeDecorationProtocol <ANCHOR, DOCUMENT_SHAPES_DISPLAY_SETTINGS, SHAPE_TYPES_DESCRIPTION>) -> Bool

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  var isGraphicallyEmpty : Bool { get }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: AlignmentGuidePoints
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  var localAlignmentGuidePoints : [CanariPoint] { get }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: inspectorView
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @MainActor static var inspectorTitle : String { get }

// § @MainActor static var anchorIsDisplayed : String { get }

  @MainActor static func inspectorView (proxy inProxy : CanariInspectorProxy <ANCHOR, DOCUMENT_SHAPES_DISPLAY_SETTINGS, SHAPE_TYPES_DESCRIPTION>) -> any View

 // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
