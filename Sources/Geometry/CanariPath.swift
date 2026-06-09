//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 21/02/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct CanariPath : Equatable, CustomStringConvertible {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  var mPath : Path
  var swiftuiPath : Path { self.mPath }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init () {
    self.mPath = Path ()
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (rect inRect : CanariRect,
               angle inAngle : CanariAngle = .zero,
               around inRotationCenter : CanariRotationCenter = .center) {
    let rotationCenter : CanariPoint
    switch inRotationCenter {
    case .bottomLeft: rotationCenter = inRect.bottomLeft
    case .bottomMiddle : rotationCenter = inRect.bottomMiddle
    case .bottomRight: rotationCenter = inRect.bottomRight
    case .center: rotationCenter = inRect.center
    case .topLeft: rotationCenter = inRect.topLeft
    case .topMiddle: rotationCenter = inRect.topMiddle
    case .topRight: rotationCenter = inRect.topRight
    case .middleLeft: rotationCenter = inRect.middleLeft
    case .middleRight: rotationCenter = inRect.middleRight
    }
    let x = rotationCenter.x.pxValue
    let y = rotationCenter.y.pxValue
    let af = CGAffineTransform (translationX: x, y: y)
      .rotated (by: inAngle.radians)
      .translatedBy (x: -x, y: -y)
    self.mPath = Path (inRect.pxValue).applying (af)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (ellipse inRect : CanariRect) {
    self.mPath = Path (ellipseIn: inRect.pxValue)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public mutating func move (to inPoint : CGPoint) {
    self.mPath.move (to: inPoint)
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

  public mutating func move (toX inX : Double, toY inY : Double) {
    self.mPath.move (to: CGPoint (x: inX, y: inY))
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public mutating func addPath (_ inPath : CanariPath) {
    self.mPath.addPath (inPath.swiftuiPath)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public mutating func addRect (_ inRect : CanariRect) {
    self.mPath.addRect (inRect.pxValue)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public mutating func addLine (to inPoint : CanariPoint) {
    self.mPath.addLine (to: inPoint.pxValue)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public mutating func addLine (to inPoint : CGPoint) {
    self.mPath.addLine (to: inPoint)
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

  public mutating func addQuadCurve (to inPoint : CGPoint,
                                     control inCtrl : CGPoint) {
    self.mPath.addQuadCurve (to: inPoint, control: inCtrl)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public mutating func addCurve (to inPoint : CanariPoint,
                                 control1 inCtrl1 : CanariPoint,
                                 control2 inCtrl2 : CanariPoint) {
    self.mPath.addCurve (to: inPoint.pxValue, control1: inCtrl1.pxValue, control2: inCtrl2.pxValue)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public mutating func addCurve (to inPoint : CGPoint,
                                 control1 inCtrl1 : CGPoint,
                                 control2 inCtrl2 : CGPoint) {
    self.mPath.addCurve (to: inPoint, control1: inCtrl1, control2: inCtrl2)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public mutating func close () {
    self.mPath.closeSubpath ()
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func transformed (byMoving inTranslation : CanariPoint = .zero,
                           zooming inZoom : Double = 1.0) -> CanariPath {
    let af = CGAffineTransform (scaleX: inZoom, y: inZoom)
      .translatedBy (x: inTranslation.x.pxValue, y: inTranslation.y.pxValue)
    var result = CanariPath ()
    result.mPath = self.mPath.applying (af)
    return result
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func transformed (by inAffinity : CanariAffinity) -> CanariPath {
    let af = inAffinity.cgAffineTransform
    var result = CanariPath ()
    result.mPath = self.mPath.applying (af)
    return result
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func transformed (using inTransform : CGAffineTransform) -> CanariPath {
    var result = CanariPath ()
    result.mPath = self.mPath.applying (inTransform)
    return result
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

//  public func clipped (inRect inRect : NSRect) -> CanariPath {
//    var result = CanariPath ()
//    result.mPath = self.mPath.applying (inTransform)
//    return result
//  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func contains (_ inP : CanariPoint, eoFill : Bool = false) -> Bool {
    return self.mPath.contains (inP.pxValue, eoFill: eoFill)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func intersects (_ inRect : CanariRect) -> Bool {
  //--- BIZARRE ! le code avec Path renvoie toujours une intersection non vide !!!
//    let r = Path (inRect.pxValue)
//    let intersection = self.mPath.intersection (r)
  //--- Alors, on utilise un CGPath, et là, c'est ok
    let r = unsafe CGPath (rect: inRect.pxValue, transform: nil)
    let intersection = self.mPath.cgPath.intersection (r)
    return !intersection.isEmpty
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func intersects (_ inPath : CanariPath) -> Bool {
  //--- On utilise aussi un CGPath
    let intersection = self.mPath.cgPath.intersection (inPath.mPath.cgPath)
    return !intersection.isEmpty
  }

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

  public func moved (x inX : CanariLength, y inY : CanariLength) -> CanariPath {
    let dx = inX.pxValue
    let dy = inY.pxValue
    var path = CanariPath ()
    self.mPath.forEach {
      switch $0 {
      case .closeSubpath :
        path.close ()
      case .move (to: let p) :
        path.move (toX: p.x + dx, toY: p.y + dy)
      case .line (to: let p) :
        path.addLine (to: CGPoint (x: p.x + dx, y: p.y + dy))
      case .curve (to: let p, control1: let ctrl1, control2: let ctrl2) :
        path.addCurve (
          to: CGPoint (x: p.x + dx, y: p.y + dy),
          control1: CGPoint (x: ctrl1.x + dx, y: ctrl1.y + dy),
          control2: CGPoint (x: ctrl2.x + dx, y: ctrl2.y + dy)
        )
      case .quadCurve (to: let p, control: let ctrl) :
         path.addQuadCurve (
          to: CGPoint (x: p.x + dx, y: p.y + dy),
          control: CGPoint (x: ctrl.x + dx, y: ctrl.y + dy)
        )
      }
    }
    return path
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public mutating func unionInPlace (_ inPath : CanariPath) {
    self.mPath = self.mPath.union (inPath.mPath)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var boundingRect : CanariRect {
    CanariRect (px: self.mPath.boundingRect)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
