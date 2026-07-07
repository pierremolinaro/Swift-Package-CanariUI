//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 21/02/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

extension CanariBaseShape : Codable {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Encoding, Decoding
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private enum CodingKeys : String, CodingKey { case value, oo, type }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  nonisolated public init (from inDecoder : Decoder) throws {
    var dictionary : [String : any CanariShapeUIProtocol.Type] = [:]
    for (type, name) : (any CanariShapeUIProtocol.Type, String) in ShapeTypesDescription.shapeTypeArray {
      dictionary [name] = type
    }
    let container = try inDecoder.container (keyedBy: CodingKeys.self)
    self.orientedOrigin = try container.decode (CanariScaledOrientedOrigin.self, forKey: .oo)
    let typeName = try container.decode (String.self, forKey: .type)
    if let type = dictionary [typeName] {
      let shape : any CanariShapeUIProtocol = try container.decode (type, forKey: .value)
      self.shape = shape as! any CanariShapeUIProtocol <ShapeTypesDescription>
      let localOutlinePath = self.shape.localOutlinePath
      self.orientedOrigin.setLocalOutline (localOutlinePath)
    }else{
      throw DecodingError.dataCorruptedError (
        forKey: .type,
        in: container,
        debugDescription: "No initializer found for type: \(typeName)"
      )
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public nonisolated func encode (to inEncoder : Encoder) throws {
    var container = inEncoder.container (keyedBy: CodingKeys.self)
    try container.encode (ShapeTypesDescription.documentEncodedTypeName (self.shape), forKey: .type)
    try container.encode (self.orientedOrigin, forKey: .oo)
    try container.encode (self.shape, forKey: .value)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
