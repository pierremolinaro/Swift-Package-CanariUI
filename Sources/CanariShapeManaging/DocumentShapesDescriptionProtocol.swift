//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 26/03/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public protocol DocumentShapesDescriptionProtocol {

  associatedtype ANCHOR : CanariShapeAnchorProtocol
  associatedtype SHAPE_TYPES_DESCRIPTION : DocumentShapesDescriptionProtocol

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  nonisolated static var shapeTypeArray : [(any CanariShapeDecorationProtocol <ANCHOR, SHAPE_TYPES_DESCRIPTION>.Type, String)] { get }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------

extension DocumentShapesDescriptionProtocol {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  static func documentEncodedTypeName (_ inShape : any CanariShapeDecorationProtocol) -> String {
    let type = type (of: inShape)
    for (shapeType, typeName) in Self.shapeTypeArray {
      if shapeType == type {
        return typeName
      }
    }
    return "???"
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
