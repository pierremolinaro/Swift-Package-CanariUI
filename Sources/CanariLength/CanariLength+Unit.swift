//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 19/09/2025.
//--------------------------------------------------------------------------------------------------

import AppKit

//--------------------------------------------------------------------------------------------------
// L'unité de longueur utilisée dans canari est le 1/90 µm [cu = Canari Unit]
// 1 µm = 90 cu
// 1 mm = 90 000 cu
// 1 cm = 900 000 cu
// 1 pouce = 2,54 cm = 2 286 000 cu
// 1 mil = 0,001 pouce = 2 286 cu
// Le pixel Cocoa est 1/72 pouce
// 1 px = 1/72 pouce = 31 750 cu
// Dans certains logiciels, le pixel est le 1/96 pouce
// 1/96 pouce = 23 812.5 cu
//--------------------------------------------------------------------------------------------------

private let CANARI_UNITS_PER_µM    = 90
private let CANARI_UNITS_PER_MM    = CANARI_UNITS_PER_µM * 1000
private let CANARI_UNITS_PER_CM    = CANARI_UNITS_PER_MM * 10
private let CANARI_UNITS_PER_INCH  = CANARI_UNITS_PER_µM * 25_400 // CANARI_UNITS_PER_MIL * 1000
private let CANARI_UNITS_PER_MIL   = CANARI_UNITS_PER_INCH / 1_000 // 2_286
private let CANARI_UNITS_PER_PIXEL = CANARI_UNITS_PER_INCH / 72 // 31_750

//--------------------------------------------------------------------------------------------------

public extension CanariLength {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  enum Unit : Sendable {

    // -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -

    case mm
    case cm
    case inch
    case mil
    case µm
    case px // Cocoa point, Cocoa Pixel, 1/72 inch
    case cu // Canari Unit 1cu = 1/90 µm

    // -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -

    public var cuValue : Int {
      switch self {
        case .mm   : return CANARI_UNITS_PER_MM
        case .cm   : return CANARI_UNITS_PER_CM
        case .inch : return CANARI_UNITS_PER_INCH
        case .mil  : return CANARI_UNITS_PER_MIL
        case .µm   : return CANARI_UNITS_PER_µM
        case .cu   : return 1
        case .px   : return CANARI_UNITS_PER_PIXEL
      }
    }

    // -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -

    public var unitString : String {
      switch self {
        case .mm   : return "mm"
        case .cm   : return "cm"
        case .inch : return "inch"
        case .mil  : return "mil"
        case .µm   : return "µm"
        case .cu   : return "cu"
        case .px   : return "px"
      }
    }

    // -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -

    public var length : CanariLength { .cu (self.cuValue) }

    // -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -

  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
