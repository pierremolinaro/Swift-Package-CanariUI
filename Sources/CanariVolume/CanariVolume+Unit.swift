//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 19/09/2025.
//--------------------------------------------------------------------------------------------------

import AppKit

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
    case px3
    case cu3

    // -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -

    public var cu3Value : Int128 {
      switch self {
        case .mm3   : return Int128 (CanariArea.Unit.mm2.cu2Value) * Int128 (CanariLength.Unit.mm.cuValue)
        case .cm3   : return Int128 (CanariArea.Unit.cm2.cu2Value) * Int128 (CanariLength.Unit.cm.cuValue)
        case .inch3 : return Int128 (CanariArea.Unit.inch2.cu2Value) * Int128 (CanariLength.Unit.inch.cuValue)
        case .mil3  : return Int128 (CanariArea.Unit.mil2.cu2Value) * Int128 (CanariLength.Unit.mil.cuValue)
        case .µm3   : return Int128 (CanariArea.Unit.µm2.cu2Value) * Int128 (CanariLength.Unit.µm.cuValue)
        case .cu3   : return 1
        case .px3   : return Int128 (CanariArea.Unit.px2.cu2Value) * Int128 (CanariLength.Unit.px.cuValue)
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
        case .px3   : return "px³"
      }
    }

   // -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -

  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
