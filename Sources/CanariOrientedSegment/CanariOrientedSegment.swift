//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 29/06/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct CanariOrientedSegment : Equatable, Hashable, CustomStringConvertible {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public let src : CanariPoint
  public let tgt : CanariPoint

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (_ inA : CanariPoint, _ inB : CanariPoint) {
    if inA.x < inB.x {
      self.src = inA
      self.tgt = inB
    }else if inA.x > inB.x {
      self.src = inB
      self.tgt = inA
    }else if inA.y < inB.y {
      self.src = inA
      self.tgt = inB
    }else if inA.y > inB.y {
      self.src = inB
      self.tgt = inA
    }else{
      fatalError ()
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init? (opt inA : CanariPoint, _ inB : CanariPoint) {
    if inA == inB {
      return nil
    }else if inA.x < inB.x {
      self.src = inA
      self.tgt = inB
    }else if inA.x == inB.x, inA.y < inB.y {
      self.src = inA
      self.tgt = inB
    }else{
      self.src = inB
      self.tgt = inA
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init? (x inStartX : CanariLength,
                y inStartY : CanariLength,
                dx inDX : CanariLength = .zero,
                dy inDY : CanariLength = .zero) {
    let p1 = CanariPoint (x: inStartX, y: inStartY)
    let p2 = CanariPoint (x: inStartX + inDX, y: inStartY + inDY)
    self.init (opt: p1, p2)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var description : String { "[\(self.src) -> \(self.tgt)]" }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  var length : CanariLength { self.src.distance (to: self.tgt) }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  var path : CanariPath {
    var result = CanariPath ()
    result.addMove (to: self.src)
    result.addLine (to: self.tgt)
    return result
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func angle_0_2π () -> Double {
    let angle = self.src.angle (to: self.tgt)
    var angle_rd = angle.radians
    while angle_rd < 0.0 {
      angle_rd += 2.0 * .pi
    }
    return angle_rd
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func orientation (of inPoint : CanariPoint) -> Int {
    let d = (self.tgt.x.cuValue - self.src.x.cuValue) * (inPoint.y.cuValue - self.src.y.cuValue)
          - (self.tgt.y.cuValue - self.src.y.cuValue) * (inPoint.x.cuValue - self.src.x.cuValue)
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
    let xAB = self.tgt.x.cuValue - self.src.x.cuValue
    let yAB = self.tgt.y.cuValue - self.src.y.cuValue
    let xCD = inOther.tgt.x.cuValue - inOther.src.x.cuValue
    let yCD = inOther.tgt.y.cuValue - inOther.src.y.cuValue
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
    let xAP = (inPoint.x - self.src.x).cuValue
    let yAP = (inPoint.y - self.src.y).cuValue
    let xAB = (self.tgt.x - self.src.x).cuValue
    let yAB = (self.tgt.y - self.src.y).cuValue
    let h = Double (xAP * xAB + yAP * yAB) / Double (xAB * xAB + yAB * yAB)
    let H = self.src + h * CanariPoint (x: .cu (xAB), y: .cu (yAB))
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
    if segmentAB.tgt.x < inSegmentCD.src.x {
      return OverlappingResult (nil, inSegmentCD, nil)
    }
    if inSegmentCD.tgt.x < segmentAB.src.x {
      return OverlappingResult (nil, inSegmentCD, nil)
    }
    let minY_AB = min (segmentAB.src.y, segmentAB.tgt.y)
    let maxY_CD = max (inSegmentCD.src.y, inSegmentCD.tgt.y)
    if maxY_CD < minY_AB {
      return OverlappingResult (nil, inSegmentCD, nil)
    }
    let minY_CD = min (inSegmentCD.src.y, inSegmentCD.tgt.y)
    let maxY_AB = max (segmentAB.src.y, segmentAB.tgt.y)
    if maxY_AB < minY_CD {
      return OverlappingResult (nil, inSegmentCD, nil)
    }
  //--- Identical ?
    if segmentAB == inSegmentCD {
      return OverlappingResult (inSegmentCD, nil, nil)
    }
  //--- C is between A and B
    if segmentAB.contains (point: inSegmentCD.src, distance: inDistance) {
      if segmentAB.contains (point: inSegmentCD.tgt, distance: inDistance) {
      //--- D is between A and B --> remove CD
        return OverlappingResult (inSegmentCD, nil, nil)
      }
      if inSegmentCD.contains (point: segmentAB.tgt, distance: inDistance) {
      //--- B is between C and D --> intersection is BC, remaining BD
        let optSegmentBC = CanariOrientedSegment (opt: segmentAB.tgt, inSegmentCD.src)
        let optSegmentBD = CanariOrientedSegment (opt: segmentAB.tgt, inSegmentCD.tgt)
        return OverlappingResult (optSegmentBC, optSegmentBD, nil)
      }else{
        return OverlappingResult (nil, inSegmentCD, nil)
      }
    }
  //--- D is between A and B
    if segmentAB.contains (point: inSegmentCD.src, distance: inDistance) {
      if segmentAB.contains (point: inSegmentCD.tgt, distance: inDistance) { // § déjà traité
      //--- D is between A and B --> remove CD
        return OverlappingResult (inSegmentCD, nil, nil)
      }
      if inSegmentCD.contains (point: segmentAB.tgt, distance: inDistance) {
      //--- B is between C and D --> intersection is BC, remaining BD
        let optSegmentBC = CanariOrientedSegment (opt: segmentAB.tgt, inSegmentCD.src)
        let optSegmentBD = CanariOrientedSegment (opt: segmentAB.tgt, inSegmentCD.tgt)
        return OverlappingResult (optSegmentBC, optSegmentBD, nil)
      }else{
        return OverlappingResult (nil, inSegmentCD, nil)
      }
    }
  //--- A is between C and D
    if inSegmentCD.contains (point: segmentAB.src, distance: inDistance) {
    //--- C between A and B
      if segmentAB.contains (point: inSegmentCD.tgt, distance: inDistance) {
      //--- D between A and B : intersection is AD, remaining is AC
        let optSegmentAD = CanariOrientedSegment (opt: segmentAB.src, inSegmentCD.tgt)
        let optSegmentAC = CanariOrientedSegment (opt: segmentAB.src, inSegmentCD.src)
       return OverlappingResult (optSegmentAD, optSegmentAC, nil)
      }
      if inSegmentCD.contains (point: segmentAB.tgt, distance: inDistance) {
      //--- B between C and D : intersection is AB, remaining AC and BD
        let optSegmentAC = CanariOrientedSegment (opt: segmentAB.src, inSegmentCD.src)
        let optSegmentBD = CanariOrientedSegment (opt: segmentAB.tgt, inSegmentCD.tgt)
        return OverlappingResult (segmentAB, optSegmentAC, optSegmentBD)
      }
    }
    return OverlappingResult (nil, inSegmentCD, nil)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: INTERSECTION
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public enum IntersectionResult {
    case disjointOrConsecutive
    case identical
    case pointAinCD
    case pointBinCD
    case pointCinAB
    case pointDinAB
    case singlePoint (CanariPoint)
    case overlapping (CanariOrientedSegment, [CanariOrientedSegment])
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  nonisolated public static func intersection (AB inAB : Self,
                                               CD inCD : Self) -> Self.IntersectionResult {
  //--- Rectangle are disjoint ?
    let A = inAB.src
    let B = inAB.tgt
    let C = inCD.src
    let D = inCD.tgt
    if A.x > D.x {
      return .disjointOrConsecutive
    }else if B.x < C.x {
      return .disjointOrConsecutive
    }else if A.y > D.y {
      return .disjointOrConsecutive
    }else if B.y < C.y {
      return .disjointOrConsecutive
    }else{
    //--- Segments are parallel ?
      let ABx = A.x - B.x
      let ABy = A.y - B.y
      let d = ABx * (C.y - D.y) - ABy * (C.x - D.x)
      if d == .zero { // Yes, parallel
      //--- Détecter si ils sont alignés
        let C_on_AB = ABx * (C.y - A.y) == ABy * (C.x - A.x) // true if C is on AB line
        if !C_on_AB {
          return .disjointOrConsecutive // parallel, not aligned
        }else if A.x == B.x { // aligned, vertical
        //--- Check if intersection
          let intersectionBottom  = max (min (A.y, B.y), min (C.y, D.y))
          let intersectionTop     = min (max (A.y, B.y), max (C.y, D.y))
          if intersectionBottom > intersectionTop {
            return .disjointOrConsecutive // aligned, vertical, disjoint
          }else{ // Intersection not empty
            var array = [A, B, C, D]
            array.sort { ($0.y < $1.y) || (($0.y == $1.y) && ($0.x < $1.x)) }
            let firstEndPoint = array [0]
            let intersectionFirst = array [1]
            let intersectionLast = array [2]
            let lastEndPoint  = array [3]
            if intersectionFirst == intersectionLast {
              return .disjointOrConsecutive
            }else{
              let intersectionSegment = CanariOrientedSegment (intersectionFirst, intersectionLast)
              var others = [CanariOrientedSegment] ()
              if let s = CanariOrientedSegment (opt: firstEndPoint, intersectionFirst) {
                others.append (s)
              }
              if let s = CanariOrientedSegment (opt: intersectionLast, lastEndPoint) {
                others.append (s)
              }
              return .overlapping (intersectionSegment, others)
            }
          }
        }else{ // Not vertical
        //--- Check if intersection
          var array = [A, B, C, D]
          array.sort { ($0.y < $1.y) || (($0.y == $1.y) && ($0.x < $1.x)) }
          let firstEndPoint = array [0]
          let intersectionFirst = array [1]
          let intersectionLast = array [2]
          let lastEndPoint  = array [3]
          if intersectionFirst == intersectionLast {
            return .disjointOrConsecutive
          }else{
            let intersectionSegment = CanariOrientedSegment (intersectionFirst, intersectionLast)
            var others = [CanariOrientedSegment] ()
            if let s = CanariOrientedSegment (opt: firstEndPoint, intersectionFirst) {
              others.append (s)
            }
            if let s = CanariOrientedSegment (opt: intersectionLast, lastEndPoint) {
              others.append (s)
            }
            return .overlapping (intersectionSegment, others)
          }
        }
      }else{ // Not parallel
        let nx = (A.x * B.y - A.y * B.x) * (C.x - D.x) - ABx * (C.x * D.y - C.y * D.x)
        let ny = (A.x * B.y - A.y * B.x) * (C.y - D.y) - ABy * (C.x * D.y - C.y * D.x)
        let x = (nx / d).µmAligned
        let y = (ny / d).µmAligned
        if x >= min (A.x, B.x), x <= max (A.x, B.x),
           x >= min (C.x, D.x), x <= max (C.x, D.x),
           y >= min (A.y, B.y), y <= max (A.y, B.y),
           y >= min (C.y, D.y), y <= max (C.y, D.y) {
          let intersection = CanariPoint (x: x, y: y)
          if intersection == A, intersection == C {
            return .disjointOrConsecutive
          }else if intersection == A, intersection == D {
            return .disjointOrConsecutive
          }else if intersection == B, intersection == C {
            return .disjointOrConsecutive
          }else if intersection == B, intersection == D {
            return .disjointOrConsecutive
          }else if intersection == A {
            return .pointAinCD
          }else if intersection == B {
            return .pointBinCD
          }else if intersection == C {
            return .pointCinAB
          }else if intersection == D {
            return .pointDinAB
          }else{
            return .singlePoint (intersection)
          }
        }else{
          return .disjointOrConsecutive // Intersection point is outside segments
        }
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
