//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 02/06/2026.
//--------------------------------------------------------------------------------------------------

import AppKit

//--------------------------------------------------------------------------------------------------

extension CanariPath : CustomStringConvertible {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  public var description : String {
    var s = "["
    self.mPath.forEach {
      switch $0 {
      case .closeSubpath: s += "Z"
      case .move(to: let p): s += "M\(p.x) \(p.y)"
      case .line(to: let p): s += "L\(p.x) \(p.y)"
      case .curve (to: let p, control1: let ctrl1, control2: let ctrl2) : s += "C\(p.x) \(p.y) \(ctrl1.x) \(ctrl1.y) \(ctrl2.x)\(ctrl2.y)"
      case .quadCurve (to: let p, control: let ctrl) : s += "Q\(p.x) \(p.y) \(ctrl.x) \(ctrl.y)"
      }
    }
    s += "]"
    return s
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
