//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 09/06/2026.
//--------------------------------------------------------------------------------------------------

import AppKit

//--------------------------------------------------------------------------------------------------

extension CanariOrientedOrigin : Codable {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (from inDecoder : any Decoder) throws { // Decodable
    let container = try inDecoder.singleValueContainer ()
    let string = try container.decode (String.self)
    let components = string.split (separator: " ")
    if components.count == 3,
       let x = Int (components [0]),
       let y = Int (components [1]),
       let angle = Int (components [2]) {
      self = CanariOrientedOrigin (CanariPoint (x: .cu (x), y: .cu (y)), CanariAngle (Double (angle) / 1000.0, in: .degrees))
    }else {
      throw DecodingError.dataCorruptedError (in: container, debugDescription: "Invalid rectangle string")
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func encode (to inEncoder : any Encoder) throws { // Encodable
    var container = inEncoder.singleValueContainer ()
    let a = Int ((self.mAngle.degrees * 1000.0).rounded ())
    try container.encode ("\(self.mOrigin.x.cuValue) \(self.mOrigin.y.cuValue) \(a)")
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
