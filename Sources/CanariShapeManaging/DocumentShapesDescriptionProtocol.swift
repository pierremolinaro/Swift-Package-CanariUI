//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 26/03/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public nonisolated struct DocumentShapeFeatures : Sendable {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public let typeNameInDocument : String
  public let presentAnchorInspector : Bool
  public let presentRotationKnob : Bool

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (typeNameInDocument: String,
               presentAnchorInspector : Bool,
               presentRotationKnob : Bool) {
    self.typeNameInDocument = typeNameInDocument
    self.presentAnchorInspector = presentAnchorInspector
    self.presentRotationKnob = presentRotationKnob
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------

public protocol DocumentShapesDescriptionProtocol {

  associatedtype ANCHOR : CanariShapeAnchorProtocol
  associatedtype DOCUMENT_SHAPES_DISPLAY_SETTINGS
  associatedtype SHAPE_TYPES_DESCRIPTION : DocumentShapesDescriptionProtocol

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  nonisolated static var shapeTypeArray : [(any CanariShapeDecorationProtocol <ANCHOR, DOCUMENT_SHAPES_DISPLAY_SETTINGS, SHAPE_TYPES_DESCRIPTION>.Type, DocumentShapeFeatures)] { get }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------

extension DocumentShapesDescriptionProtocol {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  static func documentEncodedTypeName (_ inShape : any CanariShapeDecorationProtocol) -> String {
    let type = type (of: inShape)
    for (shapeType, features) in Self.shapeTypeArray {
      if shapeType == type {
        return features.typeNameInDocument
      }
    }
    return "???"
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  static func anchorInspectorIsDisplayed (_ inType : any CanariShapeDecorationProtocol.Type ) -> Bool {
    for (shapeType, features) in Self.shapeTypeArray {
      if shapeType == inType {
        return features.presentAnchorInspector
      }
    }
    return true
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  static func rotationKnobIsDisplayed (_ inType : any CanariShapeDecorationProtocol.Type ) -> Bool {
    for (shapeType, features) in Self.shapeTypeArray {
      if shapeType == inType {
        return features.presentRotationKnob
      }
    }
    return true
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
