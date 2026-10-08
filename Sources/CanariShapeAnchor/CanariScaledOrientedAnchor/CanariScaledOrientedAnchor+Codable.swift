//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 09/06/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI
import CanariGeometry

//--------------------------------------------------------------------------------------------------

extension CanariScaledOrientedAnchor : Codable {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (from inDecoder : any Decoder) throws { // Decodable
    let container = try inDecoder.singleValueContainer ()
    let string = try container.decode (String.self)
    let components = string.split (separator: " ")
    if components.count == 5,
       let angle = Int (components [2]),
       let scale = Double (components [3]),
       let hFlip = Int (components [4]) {
      let x = try String (components [0]).decodedCanariLengthWithUnit (container)
      let y = try String (components [1]).decodedCanariLengthWithUnit (container)
      self.init (
        origin: CanariPoint (x: x, y: y),
        angle: CanariAngle (Double (angle) / 1000.0, in: .degree),
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
    let angle = Int ((self.mAngle.unsignedDegreeValue * 1000.0).rounded ())
    try container.encode ("\(self.mPoint.x.stringValueEncodedWithUnit) \(self.mPoint.y.stringValueEncodedWithUnit) \(angle) \(self.mScale) \(self.mHorizontalFlip ? 1 : 0)")
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
