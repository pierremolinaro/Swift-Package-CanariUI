//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 02/06/2026.
//--------------------------------------------------------------------------------------------------

import AppKit
import CanariGeometry

//--------------------------------------------------------------------------------------------------

public extension CanariPath {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  init (segment inSegment : CanariOrientedSegment) {
    self.init ()
    self.addSegment (inSegment)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  mutating func addSegment (_ inSegment : CanariOrientedSegment) {
    self.addMove (to: inSegment.src)
    self.addLine (to: inSegment.tgt)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
