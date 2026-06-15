//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 21/02/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct WidgetProxy <WidgetTypesDescription : DocumentWidgetsDescriptionProtocol> : Equatable, Codable, Sendable {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public let widget : any WidgetUIProtocol <WidgetTypesDescription>

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (_ inWidget : any WidgetUIProtocol <WidgetTypesDescription>) {
    self.widget = inWidget
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Encoding, Decoding
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private enum CodingKeys : String, CodingKey { case value, type }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  nonisolated public init (from inDecoder : Decoder) throws {
    var dictionary : [String : any WidgetUIProtocol.Type] = [:]
    for (type, name) : (any WidgetUIProtocol.Type, String) in WidgetTypesDescription.widgetTypeArray {
      dictionary [name] = type
    }
    let container = try inDecoder.container (keyedBy: CodingKeys.self)
    let typeName = try container.decode (String.self, forKey: .type)
    if let type = dictionary [typeName] {
      let widget : any WidgetUIProtocol = try container.decode (type, forKey: .value)
      self.widget = widget as! any WidgetUIProtocol <WidgetTypesDescription>
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
    try container.encode (WidgetTypesDescription.documentEncodedTypeName (self.widget), forKey: .type)
    try container.encode (self.widget, forKey: .value)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public static func == (_ inLeft : borrowing WidgetProxy<WidgetTypesDescription>,
                         _ inRight : borrowing WidgetProxy<WidgetTypesDescription>) -> Bool {
    inLeft.widget.isEqual (to: inRight.widget)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
