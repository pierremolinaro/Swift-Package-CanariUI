//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 13/02/2026.
//--------------------------------------------------------------------------------------------------

import Foundation

//--------------------------------------------------------------------------------------------------

public extension Double {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  var str1f : String { self.strf (1) }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  var str2f : String { self.strf (2) }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  var str3f : String { self.strf (3) }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  var str3g : String { self.strg (3) }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func strf (_ inCount : Int) -> String {
    let formatter = FloatingPointFormatStyle <Double> (locale: Locale (identifier: "en_US_POSIX"))
      .grouping (.never)
      .precision (.fractionLength (inCount))
    return self.formatted (formatter)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func strg (_ inCount : Int) -> String {
    let formatter = FloatingPointFormatStyle <Double> (locale: Locale (identifier: "en_US_POSIX"))
      .grouping (.never)
      .precision (.fractionLength (0 ... inCount))
    return self.formatted (formatter)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
