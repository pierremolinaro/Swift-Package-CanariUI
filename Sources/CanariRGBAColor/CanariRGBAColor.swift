//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 08/08/2025.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct CanariRGBAColor : Equatable {

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

  public init (_ inRGBColor : CanariRGBColor,
               alpha inAlpha : UInt8) {
    self.red = inRGBColor.red
    self.green = inRGBColor.green
    self.blue = inRGBColor.blue
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

  public static var black  : CanariRGBAColor { .init (red: 000, green: 000, blue: 000, alpha: 255) }
  public static var blue   : CanariRGBAColor { .init (red: 000, green: 000, blue: 255, alpha: 255) }
  public static var orange : CanariRGBAColor { .init (red: 251, green: 176, blue: 039, alpha: 255) }
  public static var green  : CanariRGBAColor { .init (red: 000, green: 128, blue: 000, alpha: 255) }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
