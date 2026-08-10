//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 09/06/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

extension CanariScaledOrientedAnchor : Codable {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (from inDecoder : any Decoder) throws { // Decodable
    let container = try inDecoder.singleValueContainer ()
    let string = try container.decode (String.self)
    let components = string.split (separator: " ")
    if components.count == 5,
       let x = String (components [0]).decodedCanariLengthWithUnit (),
       let y = String (components [1]).decodedCanariLengthWithUnit (),
       let angle = Int (components [2]),
       let scale = Double (components [3]),
       let hFlip = Int (components [4]) {
      self.init (
        origin: CanariPoint (x: x, y: y),
        angle: CanariAngle (Double (angle) / 1000.0, in: .degrees),
        scale: scale,
        hFlip: hFlip != 0
      )
    }else {
      throw DecodingError.dataCorruptedError (in: container, debugDescription: "Invalid CanariScaledOrientedAnchor string")
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func encode (to inEncoder : any Encoder) throws { // Encodable
    var container = inEncoder.singleValueContainer ()
    let angle = Int ((self.mAngle.degrees * 1000.0).rounded ())
    try container.encode ("\(self.mPoint.x.valueEncodedWithUnit) \(self.mPoint.y.valueEncodedWithUnit) \(angle) \(self.mScale) \(self.mHorizontalFlip ? 1 : 0)")
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
