//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 02/06/2026.
//--------------------------------------------------------------------------------------------------

import AppKit

//--------------------------------------------------------------------------------------------------

extension CanariPoint : CanariCodableByString {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (scanner inScanner : Scanner, _ ioOk : inout Bool) {
    if ioOk, let x = inScanner.scanInt (), let y = inScanner.scanInt () {
      self = CanariPoint (x: .cu (x), y: .cu (y))
    }else{
      ioOk = false
      self = .zero
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func canariCodableEncodedString () -> String {
    return "\(self.x.cuValue) \(self.y.cuValue)"
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
