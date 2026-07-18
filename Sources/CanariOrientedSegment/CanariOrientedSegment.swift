//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 29/06/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct CanariOrientedSegment : Equatable, CustomStringConvertible {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public let source : CanariPoint
  public let target : CanariPoint

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init? (_ inStart : CanariPoint, _ inTarget : CanariPoint) {
    if inStart == inTarget {
      return nil
    }else if inStart.x < inTarget.x {
      self.source = inStart
      self.target = inTarget
    }else if inStart.x == inTarget.x, inStart.y < inTarget.y {
      self.source = inStart
      self.target = inTarget
    }else{
      self.source = inTarget
      self.target = inStart
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init? (x inStartX : CanariLength,
                y inStartY : CanariLength,
                dx inDX : CanariLength = .zero,
                dy inDY : CanariLength = .zero) {
    let p1 = CanariPoint (x: inStartX, y: inStartY)
    let p2 = CanariPoint (x: inStartX + inDX, y: inStartY + inDY)
    self.init (p1, p2)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var description : String { "[\(self.source) -> \(self.target)]" }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  var length : CanariLength { self.source.distance (to: self.target) }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  var path : CanariPath {
    var result = CanariPath ()
    result.addMove (to: self.source)
    result.addLine (to: self.target)
    return result
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func orientation (of inPoint : CanariPoint) -> Int {
    let d = (self.target.x.cuValue - self.source.x.cuValue) * (inPoint.y.cuValue - self.source.y.cuValue)
          - (self.target.y.cuValue - self.source.y.cuValue) * (inPoint.x.cuValue - self.source.x.cuValue)
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
    let xAB = self.target.x.cuValue - self.source.x.cuValue
    let yAB = self.target.y.cuValue - self.source.y.cuValue
    let xCD = inOther.target.x.cuValue - inOther.source.x.cuValue
    let yCD = inOther.target.y.cuValue - inOther.source.y.cuValue
    let p = xAB * yCD - yAB * xCD
    return p == 0
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public struct PointStatus {
    public let point : CanariPoint
    public let distance : CanariLength
    public let h : Double
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func status (of inPoint : CanariPoint) -> PointStatus {
    let xAP = (inPoint.x - self.source.x).cuValue
    let yAP = (inPoint.y - self.source.y).cuValue
    let xAB = (self.target.x - self.source.x).cuValue
    let yAB = (self.target.y - self.source.y).cuValue
    let h = Double (xAP * xAB + yAP * yAB) / Double (xAB * xAB + yAB * yAB)
    let H = self.source + h * CanariPoint (x: .cu (xAB), y: .cu (yAB))
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

  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func test (_ inSegmentCD : CanariOrientedSegment,
                    forOverlapping inDistance : CanariLength) -> OverlappingResult {
    let segmentAB = self
  //--- Solve trivial cases
    if segmentAB.target.x < inSegmentCD.source.x {
      return OverlappingResult (nil, inSegmentCD, nil)
    }
    if inSegmentCD.target.x < segmentAB.source.x {
      return OverlappingResult (nil, inSegmentCD, nil)
    }
    let minY_AB = min (segmentAB.source.y, segmentAB.target.y)
    let maxY_CD = max (inSegmentCD.source.y, inSegmentCD.target.y)
    if maxY_CD < minY_AB {
      return OverlappingResult (nil, inSegmentCD, nil)
    }
    let minY_CD = min (inSegmentCD.source.y, inSegmentCD.target.y)
    let maxY_AB = max (segmentAB.source.y, segmentAB.target.y)
    if maxY_AB < minY_CD {
      return OverlappingResult (nil, inSegmentCD, nil)
    }
  //--- Identical ?
    if segmentAB == inSegmentCD {
      return OverlappingResult (inSegmentCD, nil, nil)
    }
  //--- C is between A and B
    if segmentAB.contains (point: inSegmentCD.source, distance: inDistance) {
      if segmentAB.contains (point: inSegmentCD.target, distance: inDistance) {
      //--- D is between A and B --> remove CD
        return OverlappingResult (inSegmentCD, nil, nil)
      }
      if inSegmentCD.contains (point: segmentAB.target, distance: inDistance) {
      //--- B is between C and D --> intersection is BC, remaining BD
        let optSegmentBC = CanariOrientedSegment (segmentAB.target, inSegmentCD.source)
        let optSegmentBD = CanariOrientedSegment (segmentAB.target, inSegmentCD.target)
        return OverlappingResult (optSegmentBC, optSegmentBD, nil)
      }else{
        return OverlappingResult (nil, inSegmentCD, nil)
      }
    }
  //--- D is between A and B
    if segmentAB.contains (point: inSegmentCD.source, distance: inDistance) {
      if segmentAB.contains (point: inSegmentCD.target, distance: inDistance) { // § déjà traité
      //--- D is between A and B --> remove CD
        return OverlappingResult (inSegmentCD, nil, nil)
      }
      if inSegmentCD.contains (point: segmentAB.target, distance: inDistance) {
      //--- B is between C and D --> intersection is BC, remaining BD
        let optSegmentBC = CanariOrientedSegment (segmentAB.target, inSegmentCD.source)
        let optSegmentBD = CanariOrientedSegment (segmentAB.target, inSegmentCD.target)
        return OverlappingResult (optSegmentBC, optSegmentBD, nil)
      }else{
        return OverlappingResult (nil, inSegmentCD, nil)
      }
    }
  //--- A is between C and D
    if inSegmentCD.contains (point: segmentAB.source, distance: inDistance) {
    //--- C between A and B
      if segmentAB.contains (point: inSegmentCD.target, distance: inDistance) {
      //--- D between A and B : intersection is AD, remaining is AC
        let optSegmentAD = CanariOrientedSegment (segmentAB.source, inSegmentCD.target)
        let optSegmentAC = CanariOrientedSegment (segmentAB.source, inSegmentCD.source)
       return OverlappingResult (optSegmentAD, optSegmentAC, nil)
      }
      if inSegmentCD.contains (point: segmentAB.target, distance: inDistance) {
      //--- B between C and D : intersection is AB, remaining AC and BD
        let optSegmentAC = CanariOrientedSegment (segmentAB.source, inSegmentCD.source)
        let optSegmentBD = CanariOrientedSegment (segmentAB.target, inSegmentCD.target)
        return OverlappingResult (segmentAB, optSegmentAC, optSegmentBD)
      }
    }
    return OverlappingResult (nil, inSegmentCD, nil)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
