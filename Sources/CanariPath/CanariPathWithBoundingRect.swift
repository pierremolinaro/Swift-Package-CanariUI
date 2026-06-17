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

  public init (path inPath : CanariPath = CanariPath ()) {
    self.path = inPath
    self.boundingRect = inPath.boundingRect
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private init (_ inPath : CanariPath, _ inBoundingRect : CanariRect) {
    self.path = inPath
    self.boundingRect = inPath.boundingRect
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func rotated (by inAngle : CanariAngle) -> Self {
    CanariPathWithBoundingRect (path: self.path.rotated (by: inAngle))
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func scaled (by inScale : Double) -> Self {
    CanariPathWithBoundingRect (path: self.path.transformed (scaling: inScale))
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var xMirrored : Self {
    CanariPathWithBoundingRect (self.path.xMirrored, self.boundingRect)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
