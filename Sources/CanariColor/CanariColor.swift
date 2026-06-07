//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 08/08/2025.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct CanariColor : Codable, Sendable, Equatable, RawRepresentable, CanariCodableByString {

  public typealias RawValue = String // RawRepresentable

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public let red : UInt8
  public let green : UInt8
  public let blue : UInt8
  public let alpha : UInt8

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (red inRed : UInt8,
               green inGreen : UInt8,
               blue inBlue : UInt8,
               alpha inAlpha : UInt8) {
    self.red = inRed
    self.green = inGreen
    self.blue = inBlue
    self.alpha = inAlpha
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (nsColor inColor : NSColor) {
    let rgbColor : NSColor = inColor.usingColorSpace (.genericRGB)!
    self.red = UInt8 (rgbColor.redComponent * 255.0)
    self.green = UInt8 (rgbColor.greenComponent * 255.0)
    self.blue = UInt8 (rgbColor.blueComponent * 255.0)
    self.alpha = UInt8 (rgbColor.alphaComponent * 255.0)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public static var black : CanariColor { CanariColor (red: 0, green: 0, blue: 0, alpha: 255) }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var nsColor : NSColor {
    let fRed = CGFloat (self.red) / 255.0
    let fGreen = CGFloat (self.green) / 255.0
    let fBlue = CGFloat (self.blue) / 255.0
    let fAlpha = CGFloat (self.alpha) / 255.0
    return NSColor (red: fRed, green: fGreen, blue: fBlue, alpha: fAlpha)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var color : Color { Color (self.nsColor) }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public static var blue : CanariColor { .init (red: 0, green: 0, blue: 255, alpha: 255) }
  public static var orange : CanariColor { .init (red: 255, green: 165, blue: 0, alpha: 255) }
  public static var green : CanariColor { .init (red: 0, green: 128, blue: 0, alpha: 255) }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Codable
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
  //MARK: RawRepresentable
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var rawValue : String { // RawRepresentable
    return "\(self.red) \(self.green) \(self.blue) \(self.alpha)"
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init? (rawValue inRawValue : String) { // RawRepresentable
    let components = inRawValue.split (separator: " ")
    if components.count == 4,
       let red = UInt8 (components[0]),
       let green = UInt8 (components[1]),
       let blue = UInt8 (components[2]),
       let alpha = UInt8 (components[4]) {
      self.init (red: red, green: green, blue: blue, alpha: alpha)
    }else{
      return nil
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: CanariCodableByString
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (scanner inScanner : Scanner, _ ioOk : inout Bool) {
    if ioOk {
      let red = UInt8 (scanner: inScanner, &ioOk)
      let green = UInt8 (scanner: inScanner, &ioOk)
      let blue = UInt8 (scanner: inScanner, &ioOk)
      let alpha = UInt8 (scanner: inScanner, &ioOk)
      self = CanariColor (red: red, green: green, blue: blue, alpha: alpha)
    }else{
      ioOk = false
      self = CanariColor.black
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func canariCodableEncodedString () -> String {
    return "\(self.red) \(self.green) \(self.blue) \(self.alpha)"
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
