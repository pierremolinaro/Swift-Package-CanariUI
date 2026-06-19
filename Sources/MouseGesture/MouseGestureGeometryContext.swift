//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 26/02/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct MouseGestureGeometryContext {
  public let unalignedUserStartLocation : CanariPoint
  public let alignedUserStartLocation : CanariPoint
  public let unalignedUserCurrentLocation : CanariPoint
  public let alignedUserCurrentLocation : CanariPoint
  public let scale : Double
  public let contentSize : CanariSize
  public let canvasSize : CanariSize

  public init (unalignedUserStartLocation : CanariPoint,
               alignedUserStartLocation : CanariPoint,
               unalignedUserCurrentLocation : CanariPoint,
               alignedUserCurrentLocation : CanariPoint,
               scale : Double,
               contentSize : CanariSize,
               canvasSize : CanariSize) {
    self.unalignedUserStartLocation = unalignedUserStartLocation
    self.alignedUserStartLocation = alignedUserStartLocation
    self.unalignedUserCurrentLocation = unalignedUserCurrentLocation
    self.alignedUserCurrentLocation = alignedUserCurrentLocation
    self.scale = scale
    self.contentSize = contentSize
    self.canvasSize = canvasSize
  }
}

//--------------------------------------------------------------------------------------------------
