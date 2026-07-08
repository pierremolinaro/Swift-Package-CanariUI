//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 27/03/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public protocol CanariShapeDecorationProtocol <SHAPE_TYPES_DESCRIPTION> : Sendable, Codable {

  associatedtype SHAPE_TYPES_DESCRIPTION : DocumentShapesDescriptionProtocol

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  var localOutlinePath : CanariPath { get }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func duplicated () -> (any CanariShapeDecorationProtocol <SHAPE_TYPES_DESCRIPTION>)?

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  var shapeKnobs : [ShapeKnob <SHAPE_TYPES_DESCRIPTION>] { get }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func contextualMenu (_ inExecutor : ContextualMenuExecutor <SHAPE_TYPES_DESCRIPTION>) -> any View

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func isEqual (to inOther : any CanariShapeDecorationProtocol <SHAPE_TYPES_DESCRIPTION>) -> Bool

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  var isGraphicallyEmpty : Bool { get }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Draw
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func drawShape (context ioContext : inout GraphicsContext,
                  anchor inAnchor : CanariScaledOrientedAnchor,
                  drawingScale inDrawingScale : Double,
                  hovered inHovered : Bool,
                  selected inSelected : Bool,
                  groupLevel inGroupLevel : UInt)

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: AlignmentGuidePoints
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  var localAlignmentGuidePoints : [CanariPoint] { get }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: inspectorView
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @MainActor static var inspectorTitle : String { get }

  @MainActor static func inspectorView (proxy inProxy : CanariInspectorProxy <SHAPE_TYPES_DESCRIPTION>) -> any View

 // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
