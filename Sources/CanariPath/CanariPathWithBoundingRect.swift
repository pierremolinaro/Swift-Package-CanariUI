//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 14/06/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------
// Computing bounding rect is costly, using this struct enables computing it once
//--------------------------------------------------------------------------------------------------

public struct CanariPathWithBoundingRect : Sendable, Equatable {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public let path : CanariPath
  public let boundingRect : CanariRect

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (_ inPath : CanariPath = CanariPath ()) {
    self.path = inPath
    self.boundingRect = inPath.boundingRect
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
