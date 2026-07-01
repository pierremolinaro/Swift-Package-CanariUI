//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 29/06/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct CanariSegment : Equatable, CustomStringConvertible {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public let start : CanariPoint
  public let end : CanariPoint

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init? (start inStart : CanariPoint, end inEnd : CanariPoint) {
    if inStart == inEnd {
      return nil
    }else if inStart.x < inEnd.x {
      self.start = inStart
      self.end = inEnd
    }else if inStart.x == inEnd.x, inStart.y < inEnd.y {
      self.start = inStart
      self.end = inEnd
    }else{
      self.start = inEnd
      self.end = inStart
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init? (x inStartX : CanariLength,
                y inStartY : CanariLength,
                dx inDX : CanariLength = .zero,
                dy inDY : CanariLength = .zero) {
    let p1 = CanariPoint (x: inStartX, y: inStartY)
    let p2 = CanariPoint (x: inStartX + inDX, y: inStartY + inDY)
    self.init (start: p1, end: p2)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var description : String { "[\(self.start) -> \(self.end)]" }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  var length : CanariLength { CanariPoint.distance (self.start, self.end) }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  var path : CanariPath {
    var result = CanariPath ()
    result.move (to: self.start)
    result.addLine (to: self.end)
    return result
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func orientation (of inPoint : CanariPoint) -> Int {
    let d = (self.end.x - self.start.x).cuValue * (inPoint.y - self.start.y).cuValue
          - (self.end.y - self.start.y).cuValue * (inPoint.x - self.start.x).cuValue
    if d > 0 {
      return 1 // On Right
    }else if d < 0 {
      return -1 // On Left
    }else{
      return 0 // Aligned
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Intersection
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Current segment: start -> A, end -> B
  // Other segment  : start -> C, end -> D
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public enum IntersectionResult : Equatable {
    case disjoint // No intersection
    case identical
    case singlePoint (CanariSegment, CanariSegment, CanariSegment, CanariSegment)
    case splitAB (CanariSegment, CanariSegment)
    case splitCD (CanariSegment, CanariSegment)
    case identicalAC // A == C, intersection only at this common point
    case identicalAD // A == D, intersection only at this common point
    case identicalBC // B == C, intersection only at this common point
    case identicalBD // B == D, intersection only at this common point
    case abContainsCD
    case other
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func intersection (with inOther : CanariSegment) -> IntersectionResult {
    guard self != inOther else { return .identical }
    let xAB = (self.end.x - self.start.x).cuValue
    let yAB = (self.end.y - self.start.y).cuValue
    let xCD = (inOther.end.x - inOther.start.x).cuValue
    let yCD = (inOther.end.y - inOther.start.y).cuValue
    let denominator = xAB * yCD - yAB * xCD
    if denominator == 0 { // Parallel segments
      return self.intersection (withParallel: inOther)
    }else{
      let xAC = (inOther.start.x - self.start.x).cuValue
      let yAC = (inOther.start.y - self.start.y).cuValue
      let h = Double (xAC * yCD - yAC * xCD) / Double (denominator)
      let u = Double (xAC * yAB - yAC * xAB) / Double (denominator)
      if 0.0 <= u, u <= 1.0, 0.0 <= h, h <= 1.0 {
        let p = CanariPoint (x: self.start.x + h * .cu (xAB), y: self.start.y + h * .cu (yAB))
        let s0 = CanariSegment (start: self.start, end: p)
        let s1 = CanariSegment (start: p, end: self.end)
        let s2 = CanariSegment (start: inOther.start, end: p)
        let s3 = CanariSegment (start: p, end: inOther.end)
        if s0 == nil {
          if s2 == nil {
            return .identicalAC
          }else if s3 == nil {
            return .identicalAD
          }else{
            return .splitCD (s2!, s3!)
          }
        }else if s1 == nil {
          if s2 == nil {
            return .identicalBC
          }else if s3 == nil {
            return .identicalBD
          }else{
            return .splitCD (s2!, s3!)
          }
        }else if s2 == nil {
          return .splitAB (s0!, s1!)
        }else if s3 == nil {
          return .splitAB (s0!, s1!)
        }else{
          return .singlePoint (s0!, s1!, s2!, s3!)
        }
      }else{
        return .disjoint
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func intersection (withParallel inOther : CanariSegment) -> IntersectionResult {
    let orientationABC = self.orientation (of: inOther.start)
    if orientationABC != 0 {
      return .disjoint
    }else if self.end.y == self.start.y { // Horizontal segments
      let intersectionLeftX = max (self.start.x, inOther.start.x)
      let intersectionRightX = min (self.end.x, inOther.end.x)
      if intersectionRightX < intersectionLeftX {
        return .disjoint
      }else if intersectionLeftX >= self.start.x, intersectionRightX <= self.end.x {
        return .abContainsCD
      }else{
        let pLeft = CanariPoint (x: min (self.start.x, inOther.start.x), y: self.start.y)
        let intersectionLeft = CanariPoint (x: intersectionLeftX, y: self.start.y)
        let intersectionRight = CanariPoint (x: intersectionRightX, y: self.start.y)
        let pRight = CanariPoint (x: max (self.end.x, inOther.end.x), y: self.start.y)
//        if let s = CanariSegment (start: pLeft, end: intersectionLeft) {
//          result.append (s)
//        }
//        if let s = CanariSegment (start: intersectionLeft, end: intersectionRight) {
//          result.append (s)
//        }
//        if let s = CanariSegment (start: intersectionRight, end: pRight) {
//          result.append (s)
//        }
        return .other
      }
    }else{
      let intersectionBottomY = max (self.start.y, inOther.start.y)
      let intersectionTopY = min (self.end.y, inOther.end.y)
      if intersectionTopY < intersectionBottomY {
        return .disjoint
      }else{
        var result = [CanariSegment] ()
//          let pBottom = CanariPoint (x: min (self.start.x, inOther.start.x), y: min (self.start.y, inOther.start.y))
//          let intersectionBottom = CanariPoint (x: intersectionBottomY, y: self.start.y)
//          let intersectionRight = CanariPoint (x: intersectionTopY, y: self.start.y)
//          let pTop = CanariPoint (x: max (self.end.x, inOther.end.x), y: max (self.end.y, inOther.end.y))
//          if let s = CanariSegment (start: pLeft, end: intersectionLeft) {
//            result.append (s)
//          }
//          if let s = CanariSegment (start: intersectionLeft, end: intersectionRight) {
//            result.append (s)
//          }
//          if let s = CanariSegment (start: intersectionRight, end: pRight) {
//            result.append (s)
//          }
        return .other
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func distance (of inPoint : CanariPoint) -> (CanariPoint, CanariLength, Double) {
    let xAP = (inPoint.x - self.start.x).cuValue
    let yAP = (inPoint.y - self.start.y).cuValue
    let xAB = (self.end.x - self.start.x).cuValue
    let yAB = (self.end.y - self.start.y).cuValue
    let h = Double (xAP * xAB + yAP * yAB) / Double (xAB * xAB + yAB * yAB)
    let H = self.start + h * CanariPoint (x: .cu (xAB), y: .cu (yAB))
    let distance = CanariPoint.distance (inPoint, H)
    return (H, distance, h)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
