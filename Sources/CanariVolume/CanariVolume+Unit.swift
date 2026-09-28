//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 19/09/2025.
//--------------------------------------------------------------------------------------------------

import AppKit
import CanariGeometry

//--------------------------------------------------------------------------------------------------

public extension CanariVolume {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  enum Unit : Sendable {

    // -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -

    case mm3
    case cm3
    case inch3
    case mil3
    case µm3
    case pt3
    case cu3

    // -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -

    public var cu3Value : Int128 {
      switch self {
        case .mm3   : return Int128 (CanariAreaUnit.mm2.cu2Value) * Int128 (CanariLengthUnit.mm.cuValue)
        case .cm3   : return Int128 (CanariAreaUnit.cm2.cu2Value) * Int128 (CanariLengthUnit.cm.cuValue)
        case .inch3 : return Int128 (CanariAreaUnit.inch2.cu2Value) * Int128 (CanariLengthUnit.inch.cuValue)
        case .mil3  : return Int128 (CanariAreaUnit.mil2.cu2Value) * Int128 (CanariLengthUnit.mil.cuValue)
        case .µm3   : return Int128 (CanariAreaUnit.µm2.cu2Value) * Int128 (CanariLengthUnit.µm.cuValue)
        case .cu3   : return 1
        case .pt3   : return Int128 (CanariAreaUnit.pt2.cu2Value) * Int128 (CanariLengthUnit.pt.cuValue)
      }
    }

    // -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -

    public var unitString : String {
      switch self {
        case .mm3   : return "mm³"
        case .cm3   : return "cm³"
        case .inch3 : return "in³"
        case .mil3  : return "mil³"
        case .µm3   : return "µm³"
        case .cu3   : return "cu³"
        case .pt3   : return "pt³"
      }
    }

   // -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -

  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
