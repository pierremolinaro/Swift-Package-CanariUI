//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 21/02/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct CanariPath : Equatable, CustomStringConvertible, Sendable {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  var mPath : Path
  var swiftuiPath : Path { self.mPath }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init () {
    self.mPath = Path ()
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private init (cgPath inCGPath : CGPath) {
    self.mPath = Path (inCGPath)
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

  public init (lineFrom inStart : CanariPoint, to inTarget : CanariPoint) {
    self.init ()
    self.move (to: inStart)
    self.addLine (to: inTarget)
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

  public mutating func transformInPlace (by inAffinity : CanariAffinity) {
    let af = inAffinity.cgAffineTransform
    self.mPath = self.mPath.applying (af)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func rotated (by inAngle : CanariAngle) -> CanariPath {
    let af = CGAffineTransform (rotationAngle: inAngle.radians)
    var result = CanariPath ()
    result.mPath = self.mPath.applying (af)
    return result
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func transformed (byMoving inTranslation : CanariPoint = .zero,
                           scaling inScale : Double = 1.0) -> CanariPath {
    let af = CGAffineTransform (scaleX: inScale, y: inScale)
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

  public var xMirrored : Self {
    self.transformed (by: CanariAffinity (scale: 1.0, horizontalFlip: true))
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

  public func moved (by inPoint : CanariPoint) -> CanariPath {
    return self.moved (x: inPoint.x, y: inPoint.y)
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

  public func flattened (threshold inThreshold : Double) -> CanariPath {
    CanariPath (cgPath: self.mPath.cgPath.flattened (threshold: inThreshold))
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func forEach (_ inBody : (Path.Element) -> Void) {
    self.mPath.forEach (inBody)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public mutating func unionInPlace (_ inPath : CanariPath) {
    self.mPath = self.mPath.union (inPath.mPath)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var boundingRect : CanariRect {
//    enterTracing ("path.bounding.rect") ; defer { exitTracing ("path.bounding.rect") }
    return self.mPath.isEmpty ? CanariRect () : CanariRect (px: self.mPath.boundingRect)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var currentCGPoint : CGPoint? { self.mPath.currentPoint }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var currentCanariPoint : CanariPoint? {
    if let p = self.mPath.currentPoint {
      return CanariPoint (px: p)
    }else{
      return nil
    }
  }

  //--------------------------------------------------------------------------------------------------
  // https://www.w3.org/TR/SVG11/single-page.html#chapter-paths
  //--------------------------------------------------------------------------------------------------

  public init? (fromSVGPathString inString : String) {
    guard !inString.isEmpty else { return nil }
    self.init ()
    var currentPoint = CGPoint ()
    let scanner = Scanner (string: inString)
    scanner.caseSensitive = true
    while !scanner.isAtEnd {
      if scanner.scanString ("M") != nil { // Move to point absolute
        do{
          let x = scanner.scanDouble ()!
          _ = scanner.scanString (",")
          let y = scanner.scanDouble ()!
          // print ("  M \(x) \(y)")
          currentPoint = NSPoint (x: x, y: y)
          self.move (to: currentPoint)
        }
        while let x2 = scanner.scanDouble () { // Line to point absolute
          _ = scanner.scanString (",")
          let y2 = scanner.scanDouble ()!
          // print ("   +L \(x2) \(y2)")
          currentPoint = NSPoint (x: x2, y: y2)
          self.addLine (to: currentPoint)
        }
      }else if scanner.scanString ("m") != nil { // Move to point
        do{
          let dx = scanner.scanDouble ()!
          _ = scanner.scanString (",")
          let dy = scanner.scanDouble ()!
          // print ("  m \(dx) \(dy)")
          currentPoint.x += dx
          currentPoint.y += dy
          self.move (to: currentPoint)
        }
        while let dx2 = scanner.scanDouble () {
          _ = scanner.scanString (",")
          let dy2 = scanner.scanDouble ()!
          // print ("   +l \(dx2) \(dy2)")
          currentPoint.x += dx2
          currentPoint.y += dy2
          self.addLine (to: currentPoint)
        }
      }else if scanner.scanString ("L") != nil { // Line to point
        do{
          let x = scanner.scanDouble ()!
          _ = scanner.scanString (",")
          let y = scanner.scanDouble ()!
          // print ("  L \(x) \(y)")
          currentPoint = NSPoint (x: x, y: y)
          self.addLine (to: currentPoint)
        }
        while let x2 = scanner.scanDouble () {
          _ = scanner.scanString (",")
          let y2 = scanner.scanDouble ()!
          // print ("   +L \(x2) \(y2)")
          self.addLine (to: NSPoint (x: x2, y: y2))
        }
      }else if scanner.scanString ("l") != nil { // Line to point
        do{
          let dx = scanner.scanDouble ()!
          _ = scanner.scanString (",")
          let dy = scanner.scanDouble ()!
          // print ("  l \(dx) \(dy)")
          currentPoint.x += dx
          currentPoint.y += dy
          self.addLine (to: currentPoint)
        }
        while let dx = scanner.scanDouble () {
          _ = scanner.scanString (",")
          let dy = scanner.scanDouble ()!
          // print ("   +l \(dx) \(dy)")
          currentPoint.x += dx
          currentPoint.y += dy
          self.addLine (to: currentPoint)
        }
      }else if scanner.scanString ("C") != nil { // Cubic to point
        do{
          let ctrl1X = scanner.scanDouble ()!
          _ = scanner.scanString (",")
          let ctrl1Y = scanner.scanDouble ()!
          let ctrl2X = scanner.scanDouble ()!
          _ = scanner.scanString (",")
          let ctrl2Y = scanner.scanDouble ()!
          let endX = scanner.scanDouble ()!
          _ = scanner.scanString (",")
          let endY = scanner.scanDouble ()!
          // print ("  C \(endX) \(endY) \(ctrl1X) \(ctrl1Y) \(ctrl2X) \(ctrl2Y)")
          currentPoint = NSPoint (x: endX, y: endY)
          self.addCurve (
            to: currentPoint,
            control1: NSPoint (x: ctrl1X, y: ctrl1Y),
            control2: NSPoint (x: ctrl2X, y: ctrl2Y)
          )
        }
        while let ctrl1X = scanner.scanDouble () {
          _ = scanner.scanString (",")
          let ctrl1Y = scanner.scanDouble ()!
          let ctrl2X = scanner.scanDouble ()!
          _ = scanner.scanString (",")
          let ctrl2Y = scanner.scanDouble ()!
          let endX = scanner.scanDouble ()!
          _ = scanner.scanString (",")
          let endY = scanner.scanDouble ()!
          // print ("   +C \(endX) \(endY) \(ctrl1X) \(ctrl1Y) \(ctrl2X) \(ctrl2Y)")
          self.addCurve (
            to: NSPoint (x: endX, y: endY),
            control1: NSPoint (x: ctrl1X, y: ctrl1Y),
            control2: NSPoint (x: ctrl2X, y: ctrl2Y)
          )
        }
      }else if scanner.scanString ("c") != nil { // Cubic to point
        do{
          let ctrl1X = scanner.scanDouble ()!
          _ = scanner.scanString (",")
          let ctrl1Y = scanner.scanDouble ()!
          let ctrl2X = scanner.scanDouble ()!
          _ = scanner.scanString (",")
          let ctrl2Y = scanner.scanDouble ()!
          let endX = scanner.scanDouble ()!
          _ = scanner.scanString (",")
          let endY = scanner.scanDouble ()!
          // print ("  c \(endX) \(endY) \(ctrl1X) \(ctrl1Y) \(ctrl2X) \(ctrl2Y)")
          currentPoint.x += endX
          currentPoint.y += endY
          self.addCurve (
            to: currentPoint,
            control1: NSPoint (x: currentPoint.x + ctrl1X, y: currentPoint.y + ctrl1Y),
            control2: NSPoint (x: currentPoint.x + ctrl2X, y: currentPoint.y + ctrl2Y)
          )
        }
        while let ctrl1X = scanner.scanDouble () {
          _ = scanner.scanString (",")
          let ctrl1Y = scanner.scanDouble ()!
          let ctrl2X = scanner.scanDouble ()!
          _ = scanner.scanString (",")
          let ctrl2Y = scanner.scanDouble ()!
          let endX = scanner.scanDouble ()!
          _ = scanner.scanString (",")
          let endY = scanner.scanDouble ()!
          // print ("   +c \(endX) \(endY) \(ctrl1X) \(ctrl1Y) \(ctrl2X) \(ctrl2Y)")
          currentPoint.x += endX
          currentPoint.y += endY
          self.addCurve (
            to: currentPoint,
            control1: NSPoint (x: currentPoint.x + ctrl1X, y: currentPoint.y + ctrl1Y),
            control2: NSPoint (x: currentPoint.x + ctrl2X, y: currentPoint.y + ctrl2Y)
          )
        }
      }else if scanner.scanString ("H") != nil { // Horizontal line to absolute X
        do{
          let x = scanner.scanDouble ()!
          // print ("  H \(x)")
          currentPoint.x = x
          self.addLine (to: currentPoint)
        }
        while let x = scanner.scanDouble () {
          // print ("   +H \(x)")
          currentPoint.x = x
          self.addLine (to: currentPoint)
        }
      }else if scanner.scanString ("h") != nil { // Horizontal line to relative X
        do{
          let dx = scanner.scanDouble ()!
          // print ("  h \(dx)")
          currentPoint.x += dx
          self.addLine (to: currentPoint)
        }
        while let dx = scanner.scanDouble () {
          // print ("   +h \(dx)")
          currentPoint.x += dx
          self.addLine (to: currentPoint)
        }
      }else if scanner.scanString ("V") != nil { // Vertical to point
        do{
          let y = scanner.scanDouble ()!
          // print ("  V \(y)")
          currentPoint.y = y
          self.addLine (to: currentPoint)
        }
        while let y = scanner.scanDouble () {
          // print ("   +V \(y)")
          currentPoint.y = y
          self.addLine (to: currentPoint)
        }
      }else if scanner.scanString ("v") != nil { // Vertical to point
        do{
          let dy = scanner.scanDouble ()!
          // print ("  v \(dy)")
          currentPoint.y += dy
          self.addLine (to: currentPoint)
        }
        while let dy = scanner.scanDouble () {
          // print ("   +v \(dy)")
          currentPoint.y += dy
          self.addLine (to: currentPoint)
        }
      }else if scanner.scanString ("Z") != nil { // Close path
        self.close ()
      }else if scanner.scanString ("z") != nil { // Close path
        self.close ()
      }else{
        fatalError ("index \(scanner.currentIndex)")
      }
    }
  // Perform a vertical symetry (SVG y goes from top to bottom)
    let midY = self.boundingRect.midY
    let af = CanariAffinity (translationByX: .zero, byY: midY)
      .scaling (x: 1.0, y: -1.0)
      .translating (x: .zero, y: -midY)
    self.transformInPlace (by: af)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
