//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 08/08/2025.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

extension CanariRGBColor : CanariCodableByString {

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

}

//--------------------------------------------------------------------------------------------------
