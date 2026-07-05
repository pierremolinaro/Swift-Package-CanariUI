//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 21/02/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct CanariPath : Equatable, Sendable {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  internal var mPath : Path

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init () {
    self.mPath = Path ()
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (_ inCanariPathArray : [CanariPath]) {
    self.init ()
    for path in inCanariPathArray {
      self.addPath (path)
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  internal init (cgPath inCGPath : CGPath) {
    self.mPath = Path (inCGPath)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  internal init (swiftuiPath inPath : Path) {
    self.mPath = inPath
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
    self.addMove (to: inStart)
    self.addLine (to: inTarget)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (points inPoints : [CanariPoint], isClosed inIsClosed : Bool) {
    self.init ()
    self.addMove (to: inPoints [0])
    for i in 1 ..< inPoints.count {
      self.addLine (to: inPoints [i])
    }
    if inIsClosed {
      self.addClosePath ()
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (ellipse inRect : CanariRect) {
    self.mPath = Path (ellipseIn: inRect.pxValue)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func rotated (by inAngle : CanariAngle) -> CanariPath {
    let af = CGAffineTransform (rotationAngle: inAngle.radians)
    var result = CanariPath ()
    result.mPath = self.mPath.applying (af)
    return result
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var xMirrored : Self {
    self.transformed (using: CanariAffinity (scale: 1.0, horizontalFlip: true))
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

//  public func clipped (inRect inRect : NSRect) -> CanariPath {
//    var result = CanariPath ()
//    result.mPath = self.mPath.applying (inTransform)
//    return result
//  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var isEmpty : Bool { self.mPath.isEmpty }
  
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func separatedOpenPathAndClosedPaths () -> (CanariPath, [CanariPath]) {
    var openPath = CanariPath ()
    var closedPathArray = [CanariPath] ()
    var currentPath = CanariPath ()
    var startPoint = CGPoint ()
    self.mPath.forEach {
      switch $0 {
      case .move (to: let p) :
        if !currentPath.isEmpty {
          openPath.addPath (currentPath)
          currentPath = CanariPath ()
        }
        currentPath.addMove (to: p)
        startPoint = p
      case .line (to: let p):
        currentPath.addLine (to: p)
      case .closeSubpath :
        currentPath.addClosePath ()
        closedPathArray.append (currentPath)
        currentPath = CanariPath ()
        currentPath.addMove (to: startPoint)
      case .curve (let target, let ctrl1, let ctrl2) :
        currentPath.addCubicCurve (to: target, control1: ctrl1, control2: ctrl2)
      case .quadCurve (let target, let ctrl) :
        currentPath.addQuadCurve (to: target, control: ctrl)
      }
    }
    if !currentPath.isEmpty {
      openPath.addPath (currentPath)
    }
    return (openPath, closedPathArray)
  }

   // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func pathOutside (closedPath inClosedPath : CanariPath) -> CanariPath {
    let path = self.mPath.cgPath.lineSubtracting (inClosedPath.mPath.cgPath, using: .winding)
    return CanariPath (cgPath: path)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func forEach (_ inBody : (Path.Element) -> Void) {
    self.mPath.forEach (inBody)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var boundingRect : CanariRect {
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
          self.addMove (to: currentPoint)
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
          self.addMove (to: currentPoint)
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
          self.addCubicCurve (
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
          self.addCubicCurve (
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
          self.addCubicCurve (
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
          self.addCubicCurve (
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
        self.addClosePath ()
      }else if scanner.scanString ("z") != nil { // Close path
        self.addClosePath ()
      }else{
        fatalError ("index \(scanner.currentIndex)")
      }
    }
  // Perform a vertical symetry (SVG y goes from top to bottom)
    let midY = self.boundingRect.midY
    let af = CanariAffinity (translationByX: .zero, byY: midY)
      .scaling (x: 1.0, y: -1.0)
      .translating (x: .zero, y: -midY)
    self.transformInPlace (using: af)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
