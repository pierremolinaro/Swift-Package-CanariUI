//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 30/03/2026.
//--------------------------------------------------------------------------------------------------

import Foundation

//--------------------------------------------------------------------------------------------------
//  struct CanvasMargins
//--------------------------------------------------------------------------------------------------

public struct CanvasMargins : Codable, CustomStringConvertible, Sendable, Equatable {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var left : CanariLength
  public var right : CanariLength
  public var top : CanariLength
  public var bottom : CanariLength

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init () {
    self.bottom = .zero
    self.left = .zero
    self.right = .zero
    self.top = .zero
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (left inLeftMargin : CanariLength,
               bottom inBottomMargin : CanariLength,
               right inRightMargin : CanariLength,
               top inTopMargin : CanariLength) {
    self.bottom = inBottomMargin
    self.left = inLeftMargin
    self.right = inRightMargin
    self.top = inTopMargin
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Codable
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (from inDecoder : any Decoder) throws { // Decodable
    let container = try inDecoder.singleValueContainer ()
    let string = try container.decode (String.self)
    let components = string.split (separator: " ")
    if components.count == 4,
       let left = Int (components [0]),
       let bottom = Int (components [1]),
       let right = Int (components [2]),
       let top = Int (components [3]) {
      self.bottom = .cu (bottom)
      self.left = .cu (left)
      self.right = .cu (right)
      self.top = .cu (top)
    }else {
      throw DecodingError.dataCorruptedError (in: container, debugDescription: "Invalid rectangle string")
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func encode (to inEncoder : any Encoder) throws { // Encodable
    var container = inEncoder.singleValueContainer ()
    try container.encode ("\(self.left.cuValue) \(self.bottom.cuValue) \(self.right.cuValue) \(self.top.cuValue)")
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  /**
    A textual representation of this instance.
  */

  public var description : String { // CustomStringConvertible protocol
    return "left: \(self.left), bottom: \(self.bottom), right: \(self.right), top: \(self.top)"
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
