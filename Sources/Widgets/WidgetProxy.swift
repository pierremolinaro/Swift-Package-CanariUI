//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 21/02/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct WidgetProxy <TypeDictionary : WidgetTypeArrayProtocol> : Equatable, Codable {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private let mWidget : any WidgetUIProtocol <TypeDictionary>
  public var widget : any WidgetUIProtocol <TypeDictionary> { self.mWidget }
  
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (_ inWidget : any WidgetUIProtocol <TypeDictionary>) {
    self.mWidget = inWidget
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Encoding, Decoding
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private enum CodingKeys : String, CodingKey { case value, type }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (from inDecoder : Decoder) throws {
    var dictionary : [String : any WidgetUIProtocol.Type] = [:]
    for type : any WidgetUIProtocol.Type in TypeDictionary.array {
      let name = type.documentEncodedTypeName ()
      dictionary [name] = type
    }
    let container = try inDecoder.container (keyedBy: CodingKeys.self)
    let typeName = try container.decode (String.self, forKey: .type)
    if let type = dictionary [typeName] {
      let widget : any WidgetUIProtocol = try container.decode (type, forKey: .value)
      self.mWidget = widget as! any WidgetUIProtocol <TypeDictionary>
    }else{
      throw DecodingError.dataCorruptedError (
        forKey: .type,
        in: container,
        debugDescription: "No initializer found for type: \(typeName)"
      )
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func encode (to inEncoder : Encoder) throws {
    var container = inEncoder.container (keyedBy: CodingKeys.self)
    try container.encode (type (of: self.mWidget).documentEncodedTypeName (), forKey: .type)
    try container.encode (self.mWidget, forKey: .value)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public static func == (_ inLeft : WidgetProxy<TypeDictionary>, _ inRight : WidgetProxy<TypeDictionary>) -> Bool {
    inLeft.mWidget.isEqual (to: inRight.mWidget)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
