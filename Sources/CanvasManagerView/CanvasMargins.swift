//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 30/03/2026.
//--------------------------------------------------------------------------------------------------

import Foundation

//--------------------------------------------------------------------------------------------------
//  struct CanvasMargins
//--------------------------------------------------------------------------------------------------

public struct CanvasMargins : Codable, CustomStringConvertible, Equatable, Sendable {

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
       let left = String (components [0]).decodedCanariLengthWithUnit (),
       let bottom = String (components [1]).decodedCanariLengthWithUnit (),
       let right = String (components [2]).decodedCanariLengthWithUnit (),
       let top = String (components [3]).decodedCanariLengthWithUnit () {
      self.bottom = bottom
      self.left = left
      self.right = right
      self.top = top
    }else {
      throw DecodingError.dataCorruptedError (in: container, debugDescription: "Invalid rectangle string")
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func encode (to inEncoder : any Encoder) throws { // Encodable
    var container = inEncoder.singleValueContainer ()
    try container.encode ("\(self.left.valueEncodedWithUnit) \(self.bottom.valueEncodedWithUnit) \(self.right.valueEncodedWithUnit) \(self.top.valueEncodedWithUnit)")
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
