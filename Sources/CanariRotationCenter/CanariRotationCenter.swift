//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 04/06/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public enum CanariRotationCenter : UInt, CustomStringConvertible, Codable {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  case topLeft = 0
  case middleLeft = 1
  case bottomLeft = 2
  case topMiddle = 3
  case center = 4
  case bottomMiddle = 5
  case topRight = 6
  case middleRight = 7
  case bottomRight = 8

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var description : String {
    switch self {
    case .topLeft : return "top left"
    case .middleLeft : return "middle left"
    case .bottomLeft : return "bottom left"
    case .topMiddle : return "top middle"
    case .center : return "center"
    case .bottomMiddle : return "bottom middle"
    case .topRight : return "top right"
    case .middleRight : return "middle right"
    case .bottomRight : return "bottom right"
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
