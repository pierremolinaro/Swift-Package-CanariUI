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

  public func hasSameDirection (as inOther : CanariSegment) -> Bool {
    let xAB = (self.end.x - self.start.x).cuValue
    let yAB = (self.end.y - self.start.y).cuValue
    let xCD = (inOther.end.x - inOther.start.x).cuValue
    let yCD = (inOther.end.y - inOther.start.y).cuValue
    let p = xAB * yCD - yAB * xCD
    return p == 0
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Intersection
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Current segment: start -> A, end -> B
  // Other segment  : start -> C, end -> D
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

//  public enum IntersectionResult : Equatable {
//    case disjoint // No intersection
//    case identical
//    case singlePoint (CanariSegment, CanariSegment, CanariSegment, CanariSegment)
//    case splitAB (CanariSegment, CanariSegment)
//    case splitCD (CanariSegment, CanariSegment)
//    case identicalAC // A == C, intersection only at this common point
//    case identicalAD // A == D, intersection only at this common point
//    case identicalBC // B == C, intersection only at this common point
//    case identicalBD // B == D, intersection only at this common point
//    case abContainsCD
//    case other
//  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

//  public func intersection (with inOther : CanariSegment) -> IntersectionResult {
//    guard self != inOther else { return .identical }
//    let xAB = (self.end.x - self.start.x).cuValue
//    let yAB = (self.end.y - self.start.y).cuValue
//    let xCD = (inOther.end.x - inOther.start.x).cuValue
//    let yCD = (inOther.end.y - inOther.start.y).cuValue
//    let denominator = xAB * yCD - yAB * xCD
//    if denominator == 0 { // Parallel segments
//      return self.intersection (withParallel: inOther)
//    }else{
//      let xAC = (inOther.start.x - self.start.x).cuValue
//      let yAC = (inOther.start.y - self.start.y).cuValue
//      let h = Double (xAC * yCD - yAC * xCD) / Double (denominator)
//      let u = Double (xAC * yAB - yAC * xAB) / Double (denominator)
//      if 0.0 <= u, u <= 1.0, 0.0 <= h, h <= 1.0 {
//        let p = CanariPoint (x: self.start.x + h * .cu (xAB), y: self.start.y + h * .cu (yAB))
//        let s0 = CanariSegment (start: self.start, end: p)
//        let s1 = CanariSegment (start: p, end: self.end)
//        let s2 = CanariSegment (start: inOther.start, end: p)
//        let s3 = CanariSegment (start: p, end: inOther.end)
//        if s0 == nil {
//          if s2 == nil {
//            return .identicalAC
//          }else if s3 == nil {
//            return .identicalAD
//          }else{
//            return .splitCD (s2!, s3!)
//          }
//        }else if s1 == nil {
//          if s2 == nil {
//            return .identicalBC
//          }else if s3 == nil {
//            return .identicalBD
//          }else{
//            return .splitCD (s2!, s3!)
//          }
//        }else if s2 == nil {
//          return .splitAB (s0!, s1!)
//        }else if s3 == nil {
//          return .splitAB (s0!, s1!)
//        }else{
//          return .singlePoint (s0!, s1!, s2!, s3!)
//        }
//      }else{
//        return .disjoint
//      }
//    }
//  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

//  private func intersection (withParallel inOther : CanariSegment) -> IntersectionResult {
//    let orientationABC = self.orientation (of: inOther.start)
//    if orientationABC != 0 {
//      return .disjoint
//    }else if self.end.y == self.start.y { // Horizontal segments
//      let intersectionLeftX = max (self.start.x, inOther.start.x)
//      let intersectionRightX = min (self.end.x, inOther.end.x)
//      if intersectionRightX < intersectionLeftX {
//        return .disjoint
//      }else if intersectionLeftX >= self.start.x, intersectionRightX <= self.end.x {
//        return .abContainsCD
//      }else{
//        let pLeft = CanariPoint (x: min (self.start.x, inOther.start.x), y: self.start.y)
//        let intersectionLeft = CanariPoint (x: intersectionLeftX, y: self.start.y)
//        let intersectionRight = CanariPoint (x: intersectionRightX, y: self.start.y)
//        let pRight = CanariPoint (x: max (self.end.x, inOther.end.x), y: self.start.y)
////        if let s = CanariSegment (start: pLeft, end: intersectionLeft) {
////          result.append (s)
////        }
////        if let s = CanariSegment (start: intersectionLeft, end: intersectionRight) {
////          result.append (s)
////        }
////        if let s = CanariSegment (start: intersectionRight, end: pRight) {
////          result.append (s)
////        }
//        return .other
//      }
//    }else{
//      let intersectionBottomY = max (self.start.y, inOther.start.y)
//      let intersectionTopY = min (self.end.y, inOther.end.y)
//      if intersectionTopY < intersectionBottomY {
//        return .disjoint
//      }else{
//        var result = [CanariSegment] ()
////          let pBottom = CanariPoint (x: min (self.start.x, inOther.start.x), y: min (self.start.y, inOther.start.y))
////          let intersectionBottom = CanariPoint (x: intersectionBottomY, y: self.start.y)
////          let intersectionRight = CanariPoint (x: intersectionTopY, y: self.start.y)
////          let pTop = CanariPoint (x: max (self.end.x, inOther.end.x), y: max (self.end.y, inOther.end.y))
////          if let s = CanariSegment (start: pLeft, end: intersectionLeft) {
////            result.append (s)
////          }
////          if let s = CanariSegment (start: intersectionLeft, end: intersectionRight) {
////            result.append (s)
////          }
////          if let s = CanariSegment (start: intersectionRight, end: pRight) {
////            result.append (s)
////          }
//        return .other
//      }
//    }
//  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public struct PointStatus {
    public let point : CanariPoint
    public let distance : CanariLength
    public let h : Double
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func status (of inPoint : CanariPoint) -> PointStatus {
    let xAP = (inPoint.x - self.start.x).cuValue
    let yAP = (inPoint.y - self.start.y).cuValue
    let xAB = (self.end.x - self.start.x).cuValue
    let yAB = (self.end.y - self.start.y).cuValue
    let h = Double (xAP * xAB + yAP * yAB) / Double (xAB * xAB + yAB * yAB)
    let H = self.start + h * CanariPoint (x: .cu (xAB), y: .cu (yAB))
    let distance = CanariPoint.distance (inPoint, H)
    return PointStatus (point: H, distance: distance, h: h)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func contains (point inPoint : CanariPoint, distance inDistance : CanariLength) -> Bool {
    let s = self.status (of: inPoint)
    return (0.0 <= s.h) && (s.h <= 1.0) && (s.distance <= inDistance)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Test for overlapping
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public struct OverlappingResult {
    public let intersection : CanariSegment?
    public let remaining : [CanariSegment]

    init (_ inIntersection : CanariSegment?, _ inRemaining : [CanariSegment?]) {
      self.intersection = inIntersection
      var array = [CanariSegment] ()
      for optSegment in inRemaining {
        if let s = optSegment {
          array.append (s)
        }
      }
      self.remaining = array
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func test (_ inSegmentCD : CanariSegment,
                    forOverlapping inDistance : CanariLength) -> OverlappingResult {
    let segmentAB = self
  //--- Indentical ?
    if segmentAB == inSegmentCD {
      return OverlappingResult (inSegmentCD, [])
    }
  //--- C is between A and B
    if segmentAB.contains (point: inSegmentCD.start, distance: inDistance) {
      if segmentAB.contains (point: inSegmentCD.end, distance: inDistance) {
      //--- D is between A and B --> remove CD
        return OverlappingResult (inSegmentCD, [])
      }
      if inSegmentCD.contains (point: segmentAB.end, distance: inDistance) {
      //--- B is between C and D --> intersection is BC, remaining BD
        let optSegmentBC = CanariSegment (start: segmentAB.end, end: inSegmentCD.start)
        let optSegmentBD = CanariSegment (start: segmentAB.end, end: inSegmentCD.end)
        return OverlappingResult (optSegmentBC, [optSegmentBD])
      }else{
        return OverlappingResult (nil, [inSegmentCD])
      }
    }
  //--- D is between A and B
    if segmentAB.contains (point: inSegmentCD.start, distance: inDistance) {
      if segmentAB.contains (point: inSegmentCD.end, distance: inDistance) { // § déjà traité
      //--- D is between A and B --> remove CD
        return OverlappingResult (inSegmentCD, [])
      }
      if inSegmentCD.contains (point: segmentAB.end, distance: inDistance) {
      //--- B is between C and D --> intersection is BC, remaining BD
        let optSegmentBC = CanariSegment (start: segmentAB.end, end: inSegmentCD.start)
        let optSegmentBD = CanariSegment (start: segmentAB.end, end: inSegmentCD.end)
        return OverlappingResult (optSegmentBC, [optSegmentBD])
      }else{
        return OverlappingResult (nil, [inSegmentCD])
      }
    }
  //--- A is between C and D
    if inSegmentCD.contains (point: segmentAB.start, distance: inDistance) {
    //--- C between A and B
      if segmentAB.contains (point: inSegmentCD.end, distance: inDistance) {
      //--- D between A and B : intersection is AD, remaining is AC
        let optSegmentAD = CanariSegment (start: segmentAB.start, end: inSegmentCD.end)
        let optSegmentAC = CanariSegment (start: segmentAB.start, end: inSegmentCD.start)
       return OverlappingResult (optSegmentAD, [optSegmentAC])
      }
      if inSegmentCD.contains (point: segmentAB.end, distance: inDistance) {
      //--- B between C and D : intersection is AB, remaining AC and BD
        let optSegmentAC = CanariSegment (start: segmentAB.start, end: inSegmentCD.start)
        let optSegmentBD = CanariSegment (start: segmentAB.end, end: inSegmentCD.end)
        return OverlappingResult (segmentAB, [optSegmentAC, optSegmentBD])
      }
    }
    return OverlappingResult (nil, [inSegmentCD])
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
