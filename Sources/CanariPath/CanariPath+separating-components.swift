//
//  CanariPath+separating-components.swift
//  CanariUI
//
//  Created by Pierre Molinaro on 04/07/2026.
//
//--------------------------------------------------------------------------------------------------

import AppKit

//--------------------------------------------------------------------------------------------------

extension CanariPath {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func separatedComponentsUsingNonZero () -> [CanariPath] {
    let components = self.swiftuiPath.cgPath.componentsSeparated (using: .winding)
    var result = [CanariPath] ()
    for p in components {
      result.append (CanariPath (cgPath: p))
    }
    return result
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func separatedComponentsUsingEvenOdd () -> [CanariPath] {
    let components = self.swiftuiPath.cgPath.componentsSeparated (using: .winding)
    var result = [CanariPath] ()
    for p in components {
      result.append (CanariPath (cgPath: p))
    }
    return result
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
