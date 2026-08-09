//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 21/07/2026.
//--------------------------------------------------------------------------------------------------

import Foundation

//--------------------------------------------------------------------------------------------------

extension CanariLength {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public enum DisplayUnit {
    case cm
    case inch

    var unit : CanariLength.Unit {
      switch self {
      case .cm : return .cm
      case .inch : return .inch
      }
    }

    var string : String {
      switch self {
      case .cm : return "cm"
      case .inch : return "in"
      }
    }

    func length (_ inDivisor: Divisor) -> CanariLength {
      switch self {
      case .cm   : return .cm (1) / inDivisor.rawValue
      case .inch : return .inch (1) / inDivisor.rawValue
      }
    }

    func name (_ inDivisor : Divisor) -> String {
      switch (self, inDivisor) {
      case (.cm, .d1) : return " 1 cm"
      case (.cm, .d10) : return " 1 mm"
      case (.cm, .d100) : return " 0.1 mm"
      case (.cm, .d1000) : return " 0.01 mm"
      case (.inch, .d1) : return " 1 in"
      case (.inch, .d10) : return " 100 mil"
      case (.inch, .d100) : return " 10 mil"
      case (.inch, .d1000) : return " 1 mil"
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  enum Divisor : Int {
    case d1 = 1
    case d10 = 10
    case d100 = 100
    case d1000 = 1000
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
