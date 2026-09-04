//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 08/08/2025.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public nonisolated struct CanariRGBColor : Hashable, Sendable {

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

  public init? (htmlColorString inString : String) {
    if let color =  Self.htmlColorDictionary [inString] {
      self = color
    }else if inString.hasPrefix ("rgb("), inString.hasSuffix (")") { // "rgb(nnn, nnn, nnn)"
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
    }else if inString.hasPrefix ("#"), let hexValue = UInt (inString.dropFirst(1), radix: 16) {
      let blue = UInt8 (hexValue & 0xFF)
      let green = UInt8 ((hexValue >> 8) & 0xFF)
      let red = UInt8 ((hexValue >> 16) & 0xFF)
      self = Self (red: red, green: green, blue: blue)
    }else{
      return nil
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private static nonisolated let htmlColorDictionary : [String : CanariRGBColor] = [
    "navy" : CanariRGBColor (red: 0, green: 0, blue: 128),
    "darkblue" : CanariRGBColor (red: 0, green: 0, blue: 139),
    "mediumblue" : CanariRGBColor (red: 0, green: 0, blue: 205),
    "blue" : CanariRGBColor (red: 0, green: 0, blue: 255),
    "darkgreen" : CanariRGBColor (red: 0, green: 100, blue: 0),
    "green" : CanariRGBColor (red: 0, green: 128, blue: 0),
    "teal" : CanariRGBColor (red: 0, green: 128, blue: 128),
    "darkcyan" : CanariRGBColor (red: 0, green: 139, blue: 139),
    "deepskyblue" : CanariRGBColor (red: 0, green: 191, blue: 255),
    "darkturquoise" : CanariRGBColor (red: 0, green: 206, blue: 209),
    "mediumspringgreen" : CanariRGBColor (red: 0, green: 250, blue: 154),
    "lime" : CanariRGBColor (red: 0, green: 255, blue: 0),
    "springgreen" : CanariRGBColor (red: 0, green: 255, blue: 127),
    "cyan" : CanariRGBColor (red: 0, green: 255, blue: 255),
    "aqua" : CanariRGBColor (red: 0, green: 255, blue: 255),
    "midnightblue" : CanariRGBColor (red: 25, green: 25, blue: 112),
    "dodgerblue" : CanariRGBColor (red: 30, green: 144, blue: 255),
    "lightseagreen" : CanariRGBColor (red: 32, green: 178, blue: 170),
    "forestgreen" : CanariRGBColor (red: 34, green: 139, blue: 34),
    "seagreen" : CanariRGBColor (red: 46, green: 139, blue: 87),
    "darkslategray" : CanariRGBColor (red: 47, green: 79, blue: 79),
    "limegreen" : CanariRGBColor (red: 50, green: 205, blue: 50),
    "mediumseagreen" : CanariRGBColor (red: 60, green: 179, blue: 113),
    "turquoise" : CanariRGBColor (red: 64, green: 224, blue: 208),
    "royalblue" : CanariRGBColor (red: 65, green: 105, blue: 225),
    "steelblue" : CanariRGBColor (red: 70, green: 130, blue: 180),
    "darkslateblue" : CanariRGBColor (red: 72, green: 61, blue: 139),
    "mediumturquoise" : CanariRGBColor (red: 72, green: 209, blue: 204),
    "indigo" : CanariRGBColor (red: 75, green: 0, blue: 130),
    "darkolivegreen" : CanariRGBColor (red: 85, green: 107, blue: 47),
    "cadetblue" : CanariRGBColor (red: 95, green: 158, blue: 160),
    "cornflowerblue" : CanariRGBColor (red: 100, green: 149, blue: 237),
    "mediumaquamarine" : CanariRGBColor (red: 102, green: 205, blue: 170),
    "dimgray" : CanariRGBColor (red: 105, green: 105, blue: 105),
    "slateblue" : CanariRGBColor (red: 106, green: 90, blue: 205),
    "olivedrab" : CanariRGBColor (red: 107, green: 142, blue: 35),
    "slategray" : CanariRGBColor (red: 112, green: 128, blue: 144),
    "lightslategray" : CanariRGBColor (red: 119, green: 136, blue: 153),
    "mediumslateblue" : CanariRGBColor (red: 123, green: 104, blue: 238),
    "lawngreen" : CanariRGBColor (red: 124, green: 252, blue: 0),
    "chartreuse" : CanariRGBColor (red: 127, green: 255, blue: 0),
    "aquamarine" : CanariRGBColor (red: 127, green: 255, blue: 212),
    "maroon" : CanariRGBColor (red: 128, green: 0, blue: 0),
    "purple" : CanariRGBColor (red: 128, green: 0, blue: 128),
    "olive" : CanariRGBColor (red: 128, green: 128, blue: 0),
    "gray" : CanariRGBColor (red: 128, green: 128, blue: 128),
    "skyblue" : CanariRGBColor (red: 135, green: 206, blue: 235),
    "lightskyblue" : CanariRGBColor (red: 135, green: 206, blue: 250),
    "blueviolet" : CanariRGBColor (red: 138, green: 43, blue: 226),
    "darkred" : CanariRGBColor (red: 139, green: 0, blue: 0),
    "darkmagenta" : CanariRGBColor (red: 139, green: 0, blue: 139),
    "saddlebrown" : CanariRGBColor (red: 139, green: 69, blue: 19),
    "darkseagreen" : CanariRGBColor (red: 143, green: 188, blue: 143),
    "lightgreen" : CanariRGBColor (red: 144, green: 238, blue: 144),
    "mediumpurple" : CanariRGBColor (red: 147, green: 112, blue: 219),
    "darkviolet" : CanariRGBColor (red: 148, green: 0, blue: 211),
    "palegreen" : CanariRGBColor (red: 152, green: 251, blue: 152),
    "darkorchid" : CanariRGBColor (red: 153, green: 50, blue: 204),
    "yellowgreen" : CanariRGBColor (red: 154, green: 205, blue: 50),
    "sienna" : CanariRGBColor (red: 160, green: 82, blue: 45),
    "brown" : CanariRGBColor (red: 165, green: 42, blue: 42),
    "darkgray" : CanariRGBColor (red: 169, green: 169, blue: 169),
    "lightblue" : CanariRGBColor (red: 173, green: 216, blue: 230),
    "greenyellow" : CanariRGBColor (red: 173, green: 255, blue: 47),
    "paleturquoise" : CanariRGBColor (red: 175, green: 238, blue: 238),
    "lightsteelblue" : CanariRGBColor (red: 176, green: 196, blue: 222),
    "powderblue" : CanariRGBColor (red: 176, green: 224, blue: 230),
    "firebrick" : CanariRGBColor (red: 178, green: 34, blue: 34),
    "darkgoldenrod" : CanariRGBColor (red: 184, green: 134, blue: 11),
    "mediumorchid" : CanariRGBColor (red: 186, green: 85, blue: 211),
    "rosybrown" : CanariRGBColor (red: 188, green: 143, blue: 143),
    "darkkhaki" : CanariRGBColor (red: 189, green: 183, blue: 107),
    "silver" : CanariRGBColor (red: 192, green: 192, blue: 192),
    "mediumvioletred" : CanariRGBColor (red: 199, green: 21, blue: 133),
    "indianred" : CanariRGBColor (red: 205, green: 92, blue: 92),
    "peru" : CanariRGBColor (red: 205, green: 133, blue: 63),
    "chocolate" : CanariRGBColor (red: 210, green: 105, blue: 30),
    "tan" : CanariRGBColor (red: 210, green: 180, blue: 140),
    "lightgray" : CanariRGBColor (red: 211, green: 211, blue: 211),
    "thistle" : CanariRGBColor (red: 216, green: 191, blue: 216),
    "orchid" : CanariRGBColor (red: 218, green: 112, blue: 214),
    "goldenrod" : CanariRGBColor (red: 218, green: 165, blue: 32),
    "palevioletred" : CanariRGBColor (red: 219, green: 112, blue: 147),
    "crimson" : CanariRGBColor (red: 220, green: 20, blue: 60),
    "gainsboro" : CanariRGBColor (red: 220, green: 220, blue: 220),
    "plum" : CanariRGBColor (red: 221, green: 160, blue: 221),
    "burlywood" : CanariRGBColor (red: 222, green: 184, blue: 135),
    "lightcyan" : CanariRGBColor (red: 224, green: 255, blue: 255),
    "lavender" : CanariRGBColor (red: 230, green: 230, blue: 250),
    "darksalmon" : CanariRGBColor (red: 233, green: 150, blue: 122),
    "violet" : CanariRGBColor (red: 238, green: 130, blue: 238),
    "palegoldenrod" : CanariRGBColor (red: 238, green: 232, blue: 170),
    "lightcoral" : CanariRGBColor (red: 240, green: 128, blue: 128),
    "khaki" : CanariRGBColor (red: 240, green: 230, blue: 140),
    "aliceblue" : CanariRGBColor (red: 240, green: 248, blue: 255),
    "honeydew" : CanariRGBColor (red: 240, green: 255, blue: 240),
    "azure" : CanariRGBColor (red: 240, green: 255, blue: 255),
    "sandybrown" : CanariRGBColor (red: 244, green: 164, blue: 96),
    "wheat" : CanariRGBColor (red: 245, green: 222, blue: 179),
    "beige" : CanariRGBColor (red: 245, green: 245, blue: 220),
    "whitesmoke" : CanariRGBColor (red: 245, green: 245, blue: 245),
    "mintcream" : CanariRGBColor (red: 245, green: 255, blue: 250),
    "ghostwhite" : CanariRGBColor (red: 248, green: 248, blue: 255),
    "salmon" : CanariRGBColor (red: 250, green: 128, blue: 114),
    "antiquewhite" : CanariRGBColor (red: 250, green: 235, blue: 215),
    "linen" : CanariRGBColor (red: 250, green: 240, blue: 230),
    "lightgoldenrodyellow" : CanariRGBColor (red: 250, green: 250, blue: 210),
    "oldlace" : CanariRGBColor (red: 253, green: 245, blue: 230),
    "red" : CanariRGBColor (red: 255, green: 0, blue: 0),
    "fuchsia" : CanariRGBColor (red: 255, green: 0, blue: 255),
    "magenta" : CanariRGBColor (red: 255, green: 0, blue: 255),
    "deeppink" : CanariRGBColor (red: 255, green: 20, blue: 147),
    "orangered" : CanariRGBColor (red: 255, green: 69, blue: 0),
    "tomato" : CanariRGBColor (red: 255, green: 99, blue: 71),
    "hotpink" : CanariRGBColor (red: 255, green: 105, blue: 180),
    "coral" : CanariRGBColor (red: 255, green: 127, blue: 80),
    "darkorange" : CanariRGBColor (red: 255, green: 140, blue: 0),
    "lightsalmon" : CanariRGBColor (red: 255, green: 160, blue: 122),
    "orange" : CanariRGBColor (red: 255, green: 165, blue: 0),
    "lightpink" : CanariRGBColor (red: 255, green: 182, blue: 193),
    "pink" : CanariRGBColor (red: 255, green: 192, blue: 203),
    "gold" : CanariRGBColor (red: 255, green: 215, blue: 0),
    "peachpuff" : CanariRGBColor (red: 255, green: 218, blue: 185),
    "navajowhite" : CanariRGBColor (red: 255, green: 222, blue: 173),
    "moccasin" : CanariRGBColor (red: 255, green: 228, blue: 181),
    "bisque" : CanariRGBColor (red: 255, green: 228, blue: 196),
    "mistyrose" : CanariRGBColor (red: 255, green: 228, blue: 225),
    "blanchedalmond" : CanariRGBColor (red: 255, green: 235, blue: 205),
    "papayawhip" : CanariRGBColor (red: 255, green: 239, blue: 213),
    "lavenderblush" : CanariRGBColor (red: 255, green: 240, blue: 245),
    "seashell" : CanariRGBColor (red: 255, green: 245, blue: 238),
    "cornsilk" : CanariRGBColor (red: 255, green: 248, blue: 220),
    "lemonchiffon" : CanariRGBColor (red: 255, green: 250, blue: 205),
    "floralwhite" : CanariRGBColor (red: 255, green: 250, blue: 240),
    "snow" : CanariRGBColor (red: 255, green: 250, blue: 250),
    "yellow" : CanariRGBColor (red: 255, green: 255, blue: 0),
    "lightyellow" : CanariRGBColor (red: 255, green: 255, blue: 224),
    "ivory" : CanariRGBColor (red: 255, green: 255, blue: 240),
    "white" : CanariRGBColor (red: 255, green: 255, blue: 255)
  ]

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

}

//--------------------------------------------------------------------------------------------------
