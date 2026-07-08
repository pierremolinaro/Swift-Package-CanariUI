//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 21/02/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

extension CanariShapeRoot : Codable {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Encoding, Decoding
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private enum CodingKeys : String, CodingKey { case value, oo, type }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  nonisolated public init (from inDecoder : Decoder) throws {
    var dictionary : [String : any CanariShapeDecorationProtocol.Type] = [:]
    for (type, name) : (any CanariShapeDecorationProtocol.Type, String) in SHAPE_TYPES_DESCRIPTION.shapeTypeArray {
      dictionary [name] = type
    }
    let container = try inDecoder.container (keyedBy: CodingKeys.self)
    self.mAnchor = try container.decode (ANCHOR.self, forKey: .oo)
    let typeName = try container.decode (String.self, forKey: .type)
    if let type = dictionary [typeName] {
      let shape : any CanariShapeDecorationProtocol = try container.decode (type, forKey: .value)
      self.mDecoration = shape as! any CanariShapeDecorationProtocol <ANCHOR, SHAPE_TYPES_DESCRIPTION>
      let localOutlinePath = self.mDecoration.localOutlinePath
      self.mAnchor.setLocalOutline (localOutlinePath)
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
    try container.encode (SHAPE_TYPES_DESCRIPTION.documentEncodedTypeName (self.mDecoration), forKey: .type)
    try container.encode (self.mAnchor, forKey: .oo)
    try container.encode (self.mDecoration, forKey: .value)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
