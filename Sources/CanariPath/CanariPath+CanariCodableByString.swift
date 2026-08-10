//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 02/06/2026.
//--------------------------------------------------------------------------------------------------

import AppKit

//--------------------------------------------------------------------------------------------------

extension CanariPath : CanariCodableByString {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (scanner inScanner : Scanner, _ ioOk : inout Bool) {
    self.init ()
    var current = CanariPoint.zero
    while ioOk, !inScanner.isAtEnd {
      if inScanner.scanString ("M") != nil { // Move
        current += CanariPoint (scanner: inScanner, &ioOk)
        self.addMove (to: current)
      }else if inScanner.scanString ("L") != nil { // Line
        current += CanariPoint (scanner: inScanner, &ioOk)
        self.addLine (to: current)
      }else if ioOk, inScanner.scanString ("C") != nil { // Cubic
        let target = current + CanariPoint (scanner: inScanner, &ioOk)
        let c1 = current + CanariPoint (scanner: inScanner, &ioOk)
        let c2 = current + CanariPoint (scanner: inScanner, &ioOk)
        self.addCubicCurve (to: target, control1: c1, control2: c2)
        current = target
      }else if ioOk, inScanner.scanString ("Q") != nil { // Quadratic
        let target = current + CanariPoint (scanner: inScanner, &ioOk)
        let c = current +  CanariPoint (scanner: inScanner, &ioOk)
        self.addQuadCurve (to: target, control: c)
        current = target
      }else if ioOk, inScanner.scanString ("Z") != nil { // Close
        self.addClosePath ()
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func canariCodableEncodedString () -> String {
    var s = ""
    var current = CanariPoint.zero
    self.mPath.forEach {
      switch $0 {
      case .closeSubpath :
        s += " Z"
      case .move (to: let p) :
        let cp = CanariPoint (px: p)
        let dP = cp - current
        s += " M\(dP.x.valueEncodedWithUnit) \(dP.y.valueEncodedWithUnit)"
        current = cp
      case .line (to: let p) :
        let cp = CanariPoint (px: p)
        let dP = cp - current
        s += " L\(dP.x.valueEncodedWithUnit) \(dP.y.valueEncodedWithUnit)"
        current = cp
      case .curve (to: let p, control1: let ctrl1, control2: let ctrl2) :
        let cp = CanariPoint (px: p)
        let dP = cp - current
        let dCtrl1 = CanariPoint (px: ctrl1) - current
        let dCtrl2 = CanariPoint (px: ctrl2) - current
        s += " C\(dP.x.valueEncodedWithUnit) \(dP.y.valueEncodedWithUnit)"
        s += " \(dCtrl1.x.valueEncodedWithUnit) \(dCtrl1.y.valueEncodedWithUnit)"
        s += " \(dCtrl2.x.valueEncodedWithUnit) \(dCtrl2.y.valueEncodedWithUnit)"
        current = cp
      case .quadCurve (to: let p, control: let ctrl) :
        let cp = CanariPoint (px: p)
        let dP = cp - current
        let dCtrl = CanariPoint (px: ctrl) - current
        s += " Q\(dP.x.valueEncodedWithUnit) \(dP.y.valueEncodedWithUnit)"
        s += " \(dCtrl.x.valueEncodedWithUnit) \(dCtrl.y.valueEncodedWithUnit)"
        current = cp
      }
    }
    return s
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
