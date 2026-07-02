//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 30/06/2026.
//--------------------------------------------------------------------------------------------------

import Testing
@testable import CanariUI

//--------------------------------------------------------------------------------------------------
// ⌘U exécute tous les tests.
// cliquer sur le losange situé à côté d'une méthode de test ou d'une classe de tests pour
//   ne lancer que ceux-ci.
//
//--------------------------------------------------------------------------------------------------

@Test func test1 () {
  let segment1 = CanariSegment (x: .cm (1), y: .cm (1), dx: .cm (2), dy: .cm (2))!
  let segment2 = CanariSegment (x: .cm (2), y: .cm (1), dx: .cm (2), dy: .cm (2))!
  #expect (segment1.intersection (with: segment2) == .disjoint)
}

//--------------------------------------------------------------------------------------------------

@Test func fullIntersectionTest () {
  let strokeWidth = CanariLength.mm (0.05)
  let testSize = 5
  for xA in 0 ... testSize {
    for yA in 0 ... testSize {
      for xB in xA + 1 ... testSize + 2 {
        for yB in yA + 1 ... testSize + 2 {
          let segment0 = CanariSegment (x: .cm (xA), y: .cm (yA), dx: .cm (xB - xA), dy: .cm (yB - yA))!
          let path0 = segment0.path.stroked (with: strokeWidth)
          for xC in 0 ... 7 {
            for yC in 0 ... 7 {
              for xD in xC + 1 ... 9 {
                for yD in yC + 1 ... 9 {
                  let segment1 = CanariSegment (x: .cm (xC), y: .cm (yC), dx: .cm (xD - xC), dy: .cm (yD - yC))!
                  let path1 = segment1.path.stroked (with: strokeWidth)
                  let segmentIntersection = segment0.intersection (with: segment1)
                  let pathIntersection = path0.intersection (path1)
                  switch segmentIntersection {
                  case .disjoint :
                    if !pathIntersection.isEmpty {
                      print ("DISJOINT \(segment0) \(segment1)")
                      fatalError ()
                    }
                  case .identical :
                    if segment0 != segment1 {
                      print ("IDENTICAL \(segment0) \(segment1)")
                      fatalError ()
                    }
                  case .other :
                    ()
                  case .identicalAC :
                    if segment0.start != segment1.start { fatalError() }
                  case .identicalAD :
                    if segment0.start != segment1.end { fatalError() }
                  case .identicalBC :
                    if segment0.end != segment1.start { fatalError() }
                  case .identicalBD :
                    if segment0.end != segment1.end { fatalError() }
                  case .splitCD (let s2, let s3) :
                    if s2.start != segment1.start { fatalError() }
                    if s2.end != s3.start { fatalError() }
                    if s3.end != segment1.end { fatalError() }
                    if !path0.contains (s2.end) { fatalError() }
                    if !path1.contains (s2.end) { fatalError() }
                  case .splitAB (let s0, let s1) :
                    if s0.start != segment0.start { fatalError() }
                    if s0.end != s1.start { fatalError() }
                    if s1.end != segment0.end { fatalError() }
                    if !path0.contains (s0.end) { fatalError() }
                    if !path1.contains (s0.end) { fatalError() }
                  case .singlePoint (let s0, let s1, let s2, let s3) :
                    if s0.start != segment0.start { fatalError() }
                    if s0.end != s1.start { fatalError() }
                    if s1.end != segment0.end { fatalError() }
                    if s2.start != segment1.start { fatalError() }
                    if s2.end != s3.start { fatalError() }
                    if s3.end != segment1.end { fatalError() }
                    if !path0.contains (s0.end) { fatalError() }
                    if !path1.contains (s0.end) { fatalError() }
                  case .abContainsCD :
                    if !path0.contains (segment1.start) { fatalError() }
                    if !path0.contains (segment1.end) { fatalError() }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

//--------------------------------------------------------------------------------------------------

@Test func overlappingTest () {
  let strokeWidth = CanariLength.mm (0.05)
  let testSize = 10
  for xA in 0 ... testSize {
    for yA in 0 ... testSize {
      for xB in xA + 1 ... testSize + 2 {
        for yB in yA + 1 ... testSize + 2 {
          let segment0 = CanariSegment (x: .cm (xA), y: .cm (yA), dx: .cm (xB - xA), dy: .cm (yB - yA))!
          let path0 = segment0.path.stroked (with: strokeWidth)
          for xC in 0 ... 7 {
            for yC in 0 ... 7 {
              for xD in xC + 1 ... 9 {
                for yD in yC + 1 ... 9 {
                  let segment1 = CanariSegment (x: .cm (xC), y: .cm (yC), dx: .cm (xD - xC), dy: .cm (yD - yC))!
                  let overlappingResult = segment0.test (segment1, forOverlapping: strokeWidth)
                  let sameDirection = segment0.hasSameDirection (as: segment1)
                  if sameDirection {
                    let path1 = segment1.path.stroked (with: strokeWidth)
                  //--- Test intersection
                    var pathIntersection = path1.intersection (path0)
                    if !pathIntersection.isEmpty {
                      let r = pathIntersection.boundingRect
                      if r.size.width < .mm (1), r.size.height < .mm (1) {
                        pathIntersection = CanariPath ()
                      }
                    }
                    if let segmentIntersection = overlappingResult.intersection {
                      if !pathIntersection.contains (segmentIntersection.start) || !pathIntersection.contains (segmentIntersection.end) {
                        print (segment0)
                        print (segment1)
                        print ("\(overlappingResult.intersection, default: "nil")")
                        print ("\(pathIntersection)")
                        fatalError ()
                      }
                    }else if !pathIntersection.isEmpty {
                      print (segment0)
                      print (segment1)
                      print ("\(overlappingResult.intersection, default: "nil")")
                      fatalError ()
                    }
                  //--- Test remaining
                  }else if (overlappingResult.intersection != nil)
                     || (overlappingResult.remaining.count != 1)
                     || (overlappingResult.remaining [0] != segment1) {
                    print (segment0)
                    print (segment1)
                    print ("\(overlappingResult.intersection, default: "nil")")
                    for s in overlappingResult.remaining {
                      print ("\(s)")
                    }
                    fatalError ()
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

//--------------------------------------------------------------------------------------------------
