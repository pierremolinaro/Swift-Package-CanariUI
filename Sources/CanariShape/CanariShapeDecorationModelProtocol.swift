//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 27/03/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public protocol CanariShapeDecorationModelProtocol <ShapeTypesDescription> : Identifiable, Sendable, Codable {

  associatedtype ShapeTypesDescription : DocumentShapesDescriptionProtocol

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  var id : UUID { get }

  var localOutlinePath : CanariPath { get }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func duplicated () -> (any CanariShapeDecorationUIProtocol <ShapeTypesDescription>)?

 // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
