//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 08/08/2025.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

extension CanariRGBAColor : Codable {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (from inDecoder : any Decoder) throws { // Decodable
    let container = try inDecoder.singleValueContainer ()
    let string = try container.decode (String.self)
    let components = string.split (separator: " ")
    if components.count == 4,
       let red = UInt8 (components [0]),
       let green = UInt8 (components [1]),
       let blue = UInt8 (components [2]),
       let alpha = UInt8 (components [3]) {
      self.red = red
      self.green = green
      self.blue = blue
      self.alpha = alpha
    }else {
      throw DecodingError.dataCorruptedError (in: container, debugDescription: "Invalid color string")
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func encode (to inEncoder : any Encoder) throws { // Encodable
    var container = inEncoder.singleValueContainer ()
    try container.encode ("\(self.red) \(self.green) \(self.blue) \(self.alpha)")
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
