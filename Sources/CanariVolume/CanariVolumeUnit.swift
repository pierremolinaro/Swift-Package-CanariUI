//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 19/09/2025.
//--------------------------------------------------------------------------------------------------

import AppKit
import CanariGeometry

//--------------------------------------------------------------------------------------------------

public enum CanariVolumeUnit : Sendable {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  case mm3
  case cm3
  case inch3
  case mil3
  case µm3
  case pt3
//    case cu3

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var pt3Value : Double {
    switch self {
      case .mm3   : return CanariAreaUnit.mm2.pt2Value * CanariLengthUnit.mm.ptValue
      case .cm3   : return CanariAreaUnit.cm2.pt2Value * CanariLengthUnit.cm.ptValue
      case .inch3 : return CanariAreaUnit.inch2.pt2Value * CanariLengthUnit.inch.ptValue
      case .mil3  : return CanariAreaUnit.mil2.pt2Value * CanariLengthUnit.mil.ptValue
      case .µm3   : return CanariAreaUnit.µm2.pt2Value * CanariLengthUnit.µm.ptValue
//        case .cu3   : return 1
      case .pt3   : return CanariAreaUnit.pt2.pt2Value * CanariLengthUnit.pt.ptValue
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var unitString : String {
    switch self {
      case .mm3   : return "mm³"
      case .cm3   : return "cm³"
      case .inch3 : return "in³"
      case .mil3  : return "mil³"
      case .µm3   : return "µm³"
//        case .cu3   : return "cu³"
      case .pt3   : return "pt³"
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
