//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 29/06/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct CanariOrientedSegment : Equatable, CustomStringConvertible {

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

  var length : CanariLength { self.start.distance (to: self.end) }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  var path : CanariPath {
    var result = CanariPath ()
    result.addMove (to: self.start)
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

  public func hasSameDirection (as inOther : CanariOrientedSegment) -> Bool {
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
//    case singlePoint (CanariOrientedSegment, CanariOrientedSegment, CanariOrientedSegment, CanariOrientedSegment)
//    case splitAB (CanariOrientedSegment, CanariOrientedSegment)
//    case splitCD (CanariOrientedSegment, CanariOrientedSegment)
//    case identicalAC // A == C, intersection only at this common point
//    case identicalAD // A == D, intersection only at this common point
//    case identicalBC // B == C, intersection only at this common point
//    case identicalBD // B == D, intersection only at this common point
//    case abContainsCD
//    case other
//  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

//  public func intersection (with inOther : CanariOrientedSegment) -> IntersectionResult {
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
//        let s0 = CanariOrientedSegment (start: self.start, end: p)
//        let s1 = CanariOrientedSegment (start: p, end: self.end)
//        let s2 = CanariOrientedSegment (start: inOther.start, end: p)
//        let s3 = CanariOrientedSegment (start: p, end: inOther.end)
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

//  private func intersection (withParallel inOther : CanariOrientedSegment) -> IntersectionResult {
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
////        if let s = CanariOrientedSegment (start: pLeft, end: intersectionLeft) {
////          result.append (s)
////        }
////        if let s = CanariOrientedSegment (start: intersectionLeft, end: intersectionRight) {
////          result.append (s)
////        }
////        if let s = CanariOrientedSegment (start: intersectionRight, end: pRight) {
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
//        var result = [CanariOrientedSegment] ()
////          let pBottom = CanariPoint (x: min (self.start.x, inOther.start.x), y: min (self.start.y, inOther.start.y))
////          let intersectionBottom = CanariPoint (x: intersectionBottomY, y: self.start.y)
////          let intersectionRight = CanariPoint (x: intersectionTopY, y: self.start.y)
////          let pTop = CanariPoint (x: max (self.end.x, inOther.end.x), y: max (self.end.y, inOther.end.y))
////          if let s = CanariOrientedSegment (start: pLeft, end: intersectionLeft) {
////            result.append (s)
////          }
////          if let s = CanariOrientedSegment (start: intersectionLeft, end: intersectionRight) {
////            result.append (s)
////          }
////          if let s = CanariOrientedSegment (start: intersectionRight, end: pRight) {
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
    let distance = inPoint.distance (to: H)
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
    public let intersection : CanariOrientedSegment?
    public let remaining0 : CanariOrientedSegment?
    public let remaining1 : CanariOrientedSegment?

    init (_ inIntersection : CanariOrientedSegment?,
          _ inRemaining0 : CanariOrientedSegment?,
          _ inRemaining1 : CanariOrientedSegment?) {
      self.intersection = inIntersection
      self.remaining0 = inRemaining0
      self.remaining1 = inRemaining1
    }

//    init (_ inIntersection : CanariOrientedSegment?, _ inRemaining : CanariOrientedSegment) {
//      self.intersection = inIntersection
//      self.remaining = [inRemaining]
//    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func test (_ inSegmentCD : CanariOrientedSegment,
                    forOverlapping inDistance : CanariLength) -> OverlappingResult {
    let segmentAB = self
  //--- Solve trivial cases
    if segmentAB.end.x < inSegmentCD.start.x {
      return OverlappingResult (nil, inSegmentCD, nil)
    }
    if inSegmentCD.end.x < segmentAB.start.x {
      return OverlappingResult (nil, inSegmentCD, nil)
    }
    let minY_AB = min (segmentAB.start.y, segmentAB.end.y)
    let maxY_CD = max (inSegmentCD.start.y, inSegmentCD.end.y)
    if maxY_CD < minY_AB {
      return OverlappingResult (nil, inSegmentCD, nil)
    }
    let minY_CD = min (inSegmentCD.start.y, inSegmentCD.end.y)
    let maxY_AB = max (segmentAB.start.y, segmentAB.end.y)
    if maxY_AB < minY_CD {
      return OverlappingResult (nil, inSegmentCD, nil)
    }
  //--- Identical ?
    if segmentAB == inSegmentCD {
      return OverlappingResult (inSegmentCD, nil, nil)
    }
  //--- C is between A and B
    if segmentAB.contains (point: inSegmentCD.start, distance: inDistance) {
      if segmentAB.contains (point: inSegmentCD.end, distance: inDistance) {
      //--- D is between A and B --> remove CD
        return OverlappingResult (inSegmentCD, nil, nil)
      }
      if inSegmentCD.contains (point: segmentAB.end, distance: inDistance) {
      //--- B is between C and D --> intersection is BC, remaining BD
        let optSegmentBC = CanariOrientedSegment (start: segmentAB.end, end: inSegmentCD.start)
        let optSegmentBD = CanariOrientedSegment (start: segmentAB.end, end: inSegmentCD.end)
        return OverlappingResult (optSegmentBC, optSegmentBD, nil)
      }else{
        return OverlappingResult (nil, inSegmentCD, nil)
      }
    }
  //--- D is between A and B
    if segmentAB.contains (point: inSegmentCD.start, distance: inDistance) {
      if segmentAB.contains (point: inSegmentCD.end, distance: inDistance) { // § déjà traité
      //--- D is between A and B --> remove CD
        return OverlappingResult (inSegmentCD, nil, nil)
      }
      if inSegmentCD.contains (point: segmentAB.end, distance: inDistance) {
      //--- B is between C and D --> intersection is BC, remaining BD
        let optSegmentBC = CanariOrientedSegment (start: segmentAB.end, end: inSegmentCD.start)
        let optSegmentBD = CanariOrientedSegment (start: segmentAB.end, end: inSegmentCD.end)
        return OverlappingResult (optSegmentBC, optSegmentBD, nil)
      }else{
        return OverlappingResult (nil, inSegmentCD, nil)
      }
    }
  //--- A is between C and D
    if inSegmentCD.contains (point: segmentAB.start, distance: inDistance) {
    //--- C between A and B
      if segmentAB.contains (point: inSegmentCD.end, distance: inDistance) {
      //--- D between A and B : intersection is AD, remaining is AC
        let optSegmentAD = CanariOrientedSegment (start: segmentAB.start, end: inSegmentCD.end)
        let optSegmentAC = CanariOrientedSegment (start: segmentAB.start, end: inSegmentCD.start)
       return OverlappingResult (optSegmentAD, optSegmentAC, nil)
      }
      if inSegmentCD.contains (point: segmentAB.end, distance: inDistance) {
      //--- B between C and D : intersection is AB, remaining AC and BD
        let optSegmentAC = CanariOrientedSegment (start: segmentAB.start, end: inSegmentCD.start)
        let optSegmentBD = CanariOrientedSegment (start: segmentAB.end, end: inSegmentCD.end)
        return OverlappingResult (segmentAB, optSegmentAC, optSegmentBD)
      }
    }
    return OverlappingResult (nil, inSegmentCD, nil)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
