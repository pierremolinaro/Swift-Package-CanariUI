//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 26/03/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public protocol DocumentShapesDescriptionProtocol {

  associatedtype ShapeTypesDescription : DocumentShapesDescriptionProtocol

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  nonisolated static var shapeTypeArray : [(any CanariShapeDecorationUIProtocol <ShapeTypesDescription>.Type, String)] { get }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------

extension DocumentShapesDescriptionProtocol {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  static func documentEncodedTypeName (_ inShape : any CanariShapeDecorationUIProtocol) -> String {
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
