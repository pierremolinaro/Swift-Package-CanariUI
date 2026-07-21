//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 19/09/2025.
//--------------------------------------------------------------------------------------------------

import AppKit

//--------------------------------------------------------------------------------------------------

private let CANARI_UNITS_PER_µM    = 90
private let CANARI_UNITS_PER_MM    = CANARI_UNITS_PER_µM * 1000
private let CANARI_UNITS_PER_CM    = CANARI_UNITS_PER_MM * 10
private let CANARI_UNITS_PER_INCH  = CANARI_UNITS_PER_µM * 25_400 // CANARI_UNITS_PER_MIL * 1000
private let CANARI_UNITS_PER_MIL   = CANARI_UNITS_PER_INCH / 1_000 // 2_286
private let CANARI_UNITS_PER_PIXEL = CANARI_UNITS_PER_INCH / 72 // 31_750

//--------------------------------------------------------------------------------------------------

public extension CanariArea {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  enum Unit : Sendable {

    // -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -

    case mm2
    case cm2
    case inch2
    case mil2
    case µm2
    case px2
    case cu2

    // -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -

    public var cu2Value : Int {
      switch self {
        case .mm2   : return CanariLength.Unit.mm.cuValue * CanariLength.Unit.mm.cuValue
        case .cm2   : return CanariLength.Unit.cm.cuValue * CanariLength.Unit.cm.cuValue
        case .inch2 : return CanariLength.Unit.inch.cuValue * CanariLength.Unit.inch.cuValue
        case .mil2  : return CanariLength.Unit.mil.cuValue * CanariLength.Unit.mil.cuValue
        case .µm2   : return CanariLength.Unit.µm.cuValue * CanariLength.Unit.µm.cuValue
        case .cu2   : return 1
        case .px2   : return CanariLength.Unit.px.cuValue * CanariLength.Unit.px.cuValue
      }
    }

    // -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -

    public var unitString : String {
      switch self {
        case .mm2   : return "mm²"
        case .cm2   : return "cm²"
        case .inch2 : return "in²"
        case .mil2  : return "mil²"
        case .µm2   : return "µm²"
        case .cu2   : return "cu²"
        case .px2   : return "px²"
      }
    }

    // -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -

    public var area : CanariArea { .cu2 (self.cu2Value) }

    // -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -

  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
