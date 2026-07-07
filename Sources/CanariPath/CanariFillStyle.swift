//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 02/06/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct CanariFillStyle : Equatable, Sendable, CanariCodableByString {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var eoFill : Bool // false -> non zero, true -> odd-even

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (eoFill : Bool = false) {
    self.eoFill = eoFill
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public static var nonZero : Self { Self (eoFill: false) }
  public static var evenOdd : Self { Self (eoFill: true) }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (scanner inScanner : Scanner, _ ioOk : inout Bool) {
    self.eoFill = Bool (scanner: inScanner, &ioOk)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func canariCodableEncodedString () -> String { self.eoFill.canariCodableEncodedString () }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var fillStyle : FillStyle { FillStyle (eoFill: self.eoFill) }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
