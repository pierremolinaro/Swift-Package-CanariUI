//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 08/08/2025.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct CanariRGBColor : Codable,
                               Sendable,
                               Hashable,
                               RawRepresentable,
                               CanariCodableByString,
                               CustomStringConvertible {

  public typealias RawValue = String // RawRepresentable

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public let red : UInt8
  public let green : UInt8
  public let blue : UInt8

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (red inRed : UInt8,
               green inGreen : UInt8,
               blue inBlue : UInt8) {
    self.red = inRed
    self.green = inGreen
    self.blue = inBlue
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init? (svgColorString inString : String) { // "svg(nnn, nnn, nnn)"
    if inString.hasPrefix ("rgb("), inString.hasSuffix (")") {
      var s = inString
      s.removeFirst (4)
      s.removeLast (1)
      s.removeAll { $0 == " " }
      let components = s.components (separatedBy: ",")
      if components.count == 3,
         let red = UInt8 (components [0]),
         let green = UInt8 (components [1]),
         let blue = UInt8 (components [2]) {
        self.red = red
        self.green = green
        self.blue = blue
      }else{
        return nil
      }
    }else{
      return nil
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (nsColor inColor : NSColor) {
    let rgbColor : NSColor = inColor.usingColorSpace (.genericRGB)!
    self.red = UInt8 (rgbColor.redComponent * 255.0)
    self.green = UInt8 (rgbColor.greenComponent * 255.0)
    self.blue = UInt8 (rgbColor.blueComponent * 255.0)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var nsColor : NSColor {
    let fRed = CGFloat (self.red) / 255.0
    let fGreen = CGFloat (self.green) / 255.0
    let fBlue = CGFloat (self.blue) / 255.0
    return NSColor (red: fRed, green: fGreen, blue: fBlue, alpha: 1.0)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var color : Color { Color (self.nsColor) }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public static var black  : CanariRGBColor { .init (red: 000, green: 000, blue: 000) }
  public static var blue   : CanariRGBColor { .init (red: 000, green: 000, blue: 255) }
  public static var orange : CanariRGBColor { .init (red: 251, green: 176, blue: 039) }
  public static var green  : CanariRGBColor { .init (red: 000, green: 128, blue: 000) }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Codable
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (from inDecoder : any Decoder) throws { // Decodable
    let container = try inDecoder.singleValueContainer ()
    let string = try container.decode (String.self)
    let components = string.split (separator: " ")
    if components.count == 3,
       let red = UInt8 (components [0]),
       let green = UInt8 (components [1]),
       let blue = UInt8 (components [2]) {
      self.red = red
      self.green = green
      self.blue = blue
    }else {
      throw DecodingError.dataCorruptedError (in: container, debugDescription: "Invalid color string")
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func encode (to inEncoder : any Encoder) throws { // Encodable
    var container = inEncoder.singleValueContainer ()
    try container.encode ("\(self.red) \(self.green) \(self.blue)")
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: RawRepresentable
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var rawValue : String { // RawRepresentable
    return "\(self.red) \(self.green) \(self.blue)"
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init? (rawValue inRawValue : String) { // RawRepresentable
    let components = inRawValue.split (separator: " ")
    if components.count == 3,
       let red = UInt8 (components[0]),
       let green = UInt8 (components[1]),
       let blue = UInt8 (components[2]) {
      self.init (red: red, green: green, blue: blue)
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
      self = CanariRGBColor (red: red, green: green, blue: blue)
    }else{
      ioOk = false
      self = CanariRGBColor.black
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func canariCodableEncodedString () -> String {
    return "\(self.red) \(self.green) \(self.blue)"
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var description : String {
    return "\(self.red) \(self.green) \(self.blue)"
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
