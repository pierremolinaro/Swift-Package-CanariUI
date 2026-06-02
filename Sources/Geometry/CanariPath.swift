//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 21/02/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct CanariPath {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private var mPath : Path
  var swiftuiPath : Path { self.mPath }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init () {
    self.mPath = Path ()
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (rect inRect : CanariRect) {
    self.mPath = Path (inRect.pxValue)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (ellipse inRect : CanariRect) {
    self.mPath = Path (ellipseIn: inRect.pxValue)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public mutating func move (to inPoint : CanariPoint) {
    self.mPath.move (to: inPoint.pxValue)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public mutating func move (toX inX : CanariLength, toY inY : CanariLength) {
    self.mPath.move (to: CanariPoint (x: inX, y: inY).pxValue)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public mutating func addLine (to inPoint : CanariPoint) {
    self.mPath.addLine (to: inPoint.pxValue)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public mutating func addLine (toX inX : CanariLength, toY inY : CanariLength) {
    self.mPath.addLine (to: CanariPoint (x: inX, y: inY).pxValue)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public mutating func addQuadCurve (to inPoint : CanariPoint,
                              control inCtrl : CanariPoint) {
    self.mPath.addQuadCurve (to: inPoint.pxValue, control: inCtrl.pxValue)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public mutating func addCurve (to inPoint : CanariPoint,
                          control1 inCtrl1 : CanariPoint,
                          control1 inCtrl2 : CanariPoint) {
    self.mPath.addCurve (to: inPoint.pxValue, control1: inCtrl1.pxValue, control2: inCtrl2.pxValue)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func zoomed (by inZoom : Double) -> CanariPath {
    let af = CGAffineTransform (scaleX: inZoom, y: inZoom)
    var result = CanariPath ()
    result.mPath = self.mPath.applying (af)
    return result
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func contains (_ inP : CanariPoint, eoFill : Bool = false) -> Bool {
    return self.mPath.contains (inP.pxValue, eoFill: eoFill)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func intersects (rect inRect : CanariRect) -> Bool {
  //--- BIZARRE ! le code avec Path renvoie toujours une intersection non vide !!!
//    let r = Path (inRect.pxValue)
//    let intersection = self.mPath.intersection (r)
  //--- Alors, on utilise un CGPath, et là, c'est ok
    let r = unsafe CGPath (rect: inRect.pxValue, transform: nil)
    let intersection = self.mPath.cgPath.intersection (r)
    return !intersection.isEmpty
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------

public extension Path {

  public func zoomed (by inZoom : Double) -> Path {
    let af = CGAffineTransform (scaleX: inZoom, y: inZoom)
    return self.applying (af)
  }


}
