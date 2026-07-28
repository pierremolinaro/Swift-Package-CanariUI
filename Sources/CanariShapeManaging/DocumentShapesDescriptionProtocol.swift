//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 26/03/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public protocol DocumentShapesDescriptionProtocol {

  associatedtype ANCHOR : CanariShapeAnchorProtocol
  associatedtype DOCUMENT_SHAPES_DISPLAY_SETTINGS
  associatedtype SHAPE_TYPES_DESCRIPTION : DocumentShapesDescriptionProtocol

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  nonisolated static var shapeTypeArray : [(any CanariShapeDecorationProtocol <ANCHOR, DOCUMENT_SHAPES_DISPLAY_SETTINGS, SHAPE_TYPES_DESCRIPTION>.Type, String, Bool)] { get }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------

extension DocumentShapesDescriptionProtocol {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  static func documentEncodedTypeName (_ inShape : any CanariShapeDecorationProtocol) -> String {
    let type = type (of: inShape)
    for (shapeType, typeName, _) in Self.shapeTypeArray {
      if shapeType == type {
        return typeName
      }
    }
    return "???"
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  static func anchorInspectorIsDisplayed (_ inType : any CanariShapeDecorationProtocol.Type ) -> Bool {
    for (shapeType, _, inspectorIsDisplayed) in Self.shapeTypeArray {
      if shapeType == inType {
        return inspectorIsDisplayed
      }
    }
    return true
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
