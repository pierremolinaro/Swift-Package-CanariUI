//
//  CanariPath+intersection.swift
//  CanariUI
//
//  Created by Pierre Molinaro on 04/07/2026.
//
//--------------------------------------------------------------------------------------------------

import AppKit

//--------------------------------------------------------------------------------------------------

public extension CanariPath {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Intersection test
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func intersectsUsingNonZeroRule (_ inRect : CanariRect) -> Bool {
  //--- BIZARRE ! le code avec Path renvoie toujours une intersection non vide !!!
//    let r = Path (inRect.pxValue)
//    let intersection = self.mPath.intersection (r)
  //--- Alors, on utilise un CGPath, et là, c'est ok
    let r = unsafe CGPath (rect: inRect.pxValue, transform: nil)
    let intersection = self.mPath.cgPath.intersection (r, using: .winding)
    return !intersection.isEmpty
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func intersectsUsingEvenOddRule (_ inRect : CanariRect) -> Bool {
  //--- BIZARRE ! le code avec Path renvoie toujours une intersection non vide !!!
//    let r = Path (inRect.pxValue)
//    let intersection = self.mPath.intersection (r)
  //--- Alors, on utilise un CGPath, et là, c'est ok
    let r = unsafe CGPath (rect: inRect.pxValue, transform: nil)
    let intersection = self.mPath.cgPath.intersection (r, using: .evenOdd)
    return !intersection.isEmpty
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func intersectsUsingNonZeroRule (_ inPath : CanariPath) -> Bool {
  //--- On utilise aussi un CGPath
    let intersection = self.mPath.cgPath.intersection (inPath.mPath.cgPath, using: .winding)
    return !intersection.isEmpty
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func intersectsUsingEvenOddRule (_ inPath : CanariPath) -> Bool {
  //--- On utilise aussi un CGPath
    let intersection = self.mPath.cgPath.intersection (inPath.mPath.cgPath, using: .evenOdd)
    return !intersection.isEmpty
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Intersection Computation
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  mutating func intersectionInPlaceUsingNonZeroRule (_ inPath : CanariPath) {
  //--- On utilise aussi un CGPath
    let cgIntersection = self.mPath.cgPath.intersection (inPath.mPath.cgPath, using: .winding)
    self = CanariPath (cgPath: cgIntersection)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  mutating func intersectionInPlaceUsingEvenOddRule (_ inPath : CanariPath) {
  //--- On utilise aussi un CGPath
    let cgIntersection = self.mPath.cgPath.intersection (inPath.mPath.cgPath, using: .evenOdd)
    self = CanariPath (cgPath: cgIntersection)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func intersectingUsingNonZeroRule (_ inPath : CanariPath) -> CanariPath {
  //--- On utilise aussi un CGPath
    let cgIntersection = self.mPath.cgPath.intersection (inPath.mPath.cgPath, using: .winding)
    return CanariPath (cgPath: cgIntersection)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func intersectingUsingEvenOddRule (_ inPath : CanariPath) -> CanariPath {
  //--- On utilise aussi un CGPath
    let cgIntersection = self.mPath.cgPath.intersection (inPath.mPath.cgPath, using: .evenOdd)
    return CanariPath (cgPath: cgIntersection)
  }

   // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Line Intersection
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func lineIntersectingUsingNonZeroRule (withClosedPath inClosedPath : CanariPath) -> CanariPath {
  //--- On utilise aussi un CGPath
    let cgIntersection = self.mPath.cgPath.lineIntersection (inClosedPath.mPath.cgPath, using: .winding)
    return CanariPath (cgPath: cgIntersection)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func lineIntersectingUsingEvenOddRule (withClosedPath inClosedPath : CanariPath) -> CanariPath {
  //--- On utilise aussi un CGPath
    let cgIntersection = self.mPath.cgPath.lineIntersection (inClosedPath.mPath.cgPath, using: .evenOdd)
    return CanariPath (cgPath: cgIntersection)
  }

 // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

//  func intersectsLines (of inRect : CanariRect) -> Bool {
//  //--- BIZARRE ! le code avec Path renvoie toujours une intersection non vide !!!
////    let r = Path (inRect.pxValue)
////    let intersection = self.mPath.intersection (r)
//  //--- Alors, on utilise un CGPath, et là, c'est ok
//    let r = unsafe CGPath (rect: inRect.pxValue, transform: nil)
//    let intersection = self.mPath.cgPath.lineIntersection (r)
//    return !intersection.isEmpty
//  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
