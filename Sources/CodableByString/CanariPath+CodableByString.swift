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
        let target = CanariPoint (scanner: inScanner, &ioOk)
        self.move (to: target)
      }else if inScanner.scanString ("L") != nil { // Line
        let target = CanariPoint (scanner: inScanner, &ioOk)
        self.addLine (to: target)
      }else if ioOk, inScanner.scanString ("C") != nil { // Cubic
        let target = CanariPoint (scanner: inScanner, &ioOk)
        let c1 = CanariPoint (scanner: inScanner, &ioOk)
        let c2 = CanariPoint (scanner: inScanner, &ioOk)
        self.addCurve (to: target, control1: c1, control2: c2)
      }else if ioOk, inScanner.scanString ("Q") != nil { // Quadratic
        let target = CanariPoint (scanner: inScanner, &ioOk)
        let c = CanariPoint (scanner: inScanner, &ioOk)
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
        s += "M\(CanariLength.px (p.x).cuValue) \(CanariLength.px (p.y).cuValue)"
      case .line (to: let p) :
        s += "L\(CanariLength.px (p.x).cuValue) \(CanariLength.px (p.y).cuValue)"
      case .curve (to: let p, control1: let ctrl1, control2: let ctrl2) :
        s += "C\(CanariLength.px (p.x).cuValue) \(CanariLength.px (p.y).cuValue)"
        s += " \(CanariLength.px (ctrl1.x).cuValue) \(CanariLength.px (ctrl1.y).cuValue)"
        s += " \(CanariLength.px (ctrl2.x).cuValue) \(CanariLength.px (ctrl2.y).cuValue)"
      case .quadCurve (to: let p, control: let ctrl) :
        s += "Q\(CanariLength.px (p.x).cuValue) \(CanariLength.px (p.y).cuValue)"
        s += " \(CanariLength.px (ctrl.x).cuValue) \(CanariLength.px (ctrl.y).cuValue)"
      }
    }
    return s
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
