//
//  CanariPath+intersection.swift
//  CanariUI
//
//  Created by Pierre Molinaro on 04/07/2026.
//
//--------------------------------------------------------------------------------------------------

import AppKit

//--------------------------------------------------------------------------------------------------

extension CanariPath {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func intersects (_ inRect : CanariRect) -> Bool {
  //--- BIZARRE ! le code avec Path renvoie toujours une intersection non vide !!!
//    let r = Path (inRect.pxValue)
//    let intersection = self.swiftuiPath.intersection (r)
  //--- Alors, on utilise un CGPath, et là, c'est ok
    let r = unsafe CGPath (rect: inRect.pxValue, transform: nil)
    let intersection = self.swiftuiPath.cgPath.intersection (r)
    return !intersection.isEmpty
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func intersectsLines (of inRect : CanariRect) -> Bool {
  //--- BIZARRE ! le code avec Path renvoie toujours une intersection non vide !!!
//    let r = Path (inRect.pxValue)
//    let intersection = self.swiftuiPath.intersection (r)
  //--- Alors, on utilise un CGPath, et là, c'est ok
    let r = unsafe CGPath (rect: inRect.pxValue, transform: nil)
    let intersection = self.swiftuiPath.cgPath.lineIntersection (r)
    return !intersection.isEmpty
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func intersects (_ inPath : CanariPath) -> Bool {
  //--- On utilise aussi un CGPath
    let intersection = self.swiftuiPath.cgPath.intersection (inPath.swiftuiPath.cgPath)
    return !intersection.isEmpty
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func lineIntersection (withClosedPath inClosedPath : CanariPath) -> CanariPath {
  //--- On utilise aussi un CGPath
    let cgIntersection = self.swiftuiPath.cgPath.lineIntersection (inClosedPath.swiftuiPath.cgPath)
    return CanariPath (cgPath: cgIntersection)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func intersection (_ inPath : CanariPath) -> CanariPath {
  //--- On utilise aussi un CGPath
    let cgIntersection = self.swiftuiPath.cgPath.intersection (inPath.swiftuiPath.cgPath)
    return CanariPath (cgPath: cgIntersection)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
