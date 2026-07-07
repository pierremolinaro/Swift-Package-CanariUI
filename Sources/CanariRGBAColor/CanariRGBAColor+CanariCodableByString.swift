//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 08/08/2025.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

extension CanariRGBAColor : CanariCodableByString {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (scanner inScanner : Scanner, _ ioOk : inout Bool) {
    if ioOk {
      let red = UInt8 (scanner: inScanner, &ioOk)
      let green = UInt8 (scanner: inScanner, &ioOk)
      let blue = UInt8 (scanner: inScanner, &ioOk)
      let alpha = UInt8 (scanner: inScanner, &ioOk)
      self = CanariRGBAColor (red: red, green: green, blue: blue, alpha: alpha)
    }else{
      ioOk = false
      self = CanariRGBAColor.black
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func canariCodableEncodedString () -> String {
    return "\(self.red) \(self.green) \(self.blue) \(self.alpha)"
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
