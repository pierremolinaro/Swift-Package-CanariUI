//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 02/06/2026.
//--------------------------------------------------------------------------------------------------

import AppKit

//--------------------------------------------------------------------------------------------------

extension CanariPath : CodableByString {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (scanner inScanner : Scanner, _ ioOk : inout Bool) {
    self.init ()
    while ioOk, !inScanner.isAtEnd {
      if inScanner.scanString ("M") != nil { // Move
        let target = CGPoint (scanner: inScanner, &ioOk)
        self.move (to: target)
      }else if inScanner.scanString ("L") != nil { // Line
        let target = CGPoint (scanner: inScanner, &ioOk)
        self.addLine (to: target)
      }else if ioOk, inScanner.scanString ("C") != nil { // Cubic
        let target = CGPoint (scanner: inScanner, &ioOk)
        let c1 = CGPoint (scanner: inScanner, &ioOk)
        let c2 = CGPoint (scanner: inScanner, &ioOk)
        self.addCurve (to: target, control1: c1, control2: c2)
      }else if ioOk, inScanner.scanString ("Q") != nil { // Quadratic
        let target = CGPoint (scanner: inScanner, &ioOk)
        let c = CGPoint (scanner: inScanner, &ioOk)
        self.addQuadCurve (to: target, control: c)
      }else if ioOk, inScanner.scanString ("Z") != nil { // Close
        self.close ()
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func encodedString () -> String {
    var s = ""
    self.swiftuiPath.forEach {
      switch $0 {
      case .closeSubpath :
        s += "Z"
      case .move (to: let p) :
        s += "M\(p.x) \(p.y)"
      case .line (to: let p) :
        s += "L\(p.x) \(p.y)"
      case .curve (to: let p, control1: let ctrl1, control2: let ctrl2) :
        s += "C\(p.x) \(p.y) \(ctrl1.x) \(ctrl1.y) \(ctrl2.x) \(ctrl2.y)"
      case .quadCurve (to: let p, control: let ctrl) :
        s += "Q\(p.x) \(p.y) \(ctrl.x) \(ctrl.y)"
      }
    }
    return s
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
