//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 02/06/2026.
//--------------------------------------------------------------------------------------------------

import AppKit

//--------------------------------------------------------------------------------------------------

public extension CanariPath {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  mutating func transformInPlace (using inAffinity : CanariAffinity) {
    let af = inAffinity.cgAffineTransform
    self.mPath = self.mPath.applying (af)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func transformed (using inAffinity : CanariAffinity) -> CanariPath {
    let af = inAffinity.cgAffineTransform
    var result = CanariPath ()
    result.mPath = self.mPath.applying (af)
    return result
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func transformed (using inTransform : CGAffineTransform) -> CanariPath {
    var result = CanariPath ()
    result.mPath = self.mPath.applying (inTransform)
    return result
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func transformed (byTranslating inTranslation : CanariPoint = .zero,
                    scaling inScale : Double = 1.0) -> CanariPath {
    let af = CGAffineTransform (scaleX: inScale, y: inScale)
      .translatedBy (x: inTranslation.x.pxValue, y: inTranslation.y.pxValue)
    var result = CanariPath ()
    result.mPath = self.mPath.applying (af)
    return result
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
