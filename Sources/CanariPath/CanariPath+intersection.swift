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

  func intersects (_ inRect : CanariRect, using inRule : Self.Rule) -> Bool {
  //--- BIZARRE ! le code avec Path renvoie toujours une intersection non vide !!!
//    let r = Path (inRect.ptValue)
//    let intersection = self.mPath.intersection (r)
  //--- Alors, on utilise un CGPath, et là, c'est ok
    let r = unsafe CGPath (rect: inRect.ptValue, transform: nil)
    let intersection = self.mPath.cgPath.intersection (r, using: inRule.cgRule)
    return !intersection.isEmpty
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func intersects (_ inPath : CanariPath, using inRule : Self.Rule) -> Bool {
  //--- On utilise aussi un CGPath
    let intersection = self.mPath.cgPath.intersection (inPath.mPath.cgPath, using: inRule.cgRule)
    return !intersection.isEmpty
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Intersection Computation
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  mutating func intersectionInPlace (_ inPath : CanariPath, using inRule : Self.Rule) {
  //--- On utilise aussi un CGPath
    let cgIntersection = self.mPath.cgPath.intersection (inPath.mPath.cgPath, using: inRule.cgRule)
    self = CanariPath (cgPath: cgIntersection)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func intersecting (_ inPath : CanariPath, using inRule : Self.Rule) -> CanariPath {
  //--- On utilise aussi un CGPath
    let cgIntersection = self.mPath.cgPath.intersection (inPath.mPath.cgPath, using: inRule.cgRule)
    return CanariPath (cgPath: cgIntersection)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Line Intersection
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func lineIntersecting (withClosedPath inClosedPath : CanariPath,
                         using inRule : Self.Rule) -> CanariPath {
  //--- On utilise aussi un CGPath
    let cgIntersection = self.mPath.cgPath.lineIntersection (inClosedPath.mPath.cgPath, using: inRule.cgRule)
    return CanariPath (cgPath: cgIntersection)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
