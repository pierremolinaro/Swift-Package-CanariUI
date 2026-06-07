//
//  Scanner+myScanCanariLength.swift
//  editeur-courbes-bezier
//
//  Created by Pierre Molinaro on 19/09/2025.
//
//--------------------------------------------------------------------------------------------------

import AppKit

//--------------------------------------------------------------------------------------------------

extension CanariLength : CanariCodableByString {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (scanner inScanner : Scanner, _ ioOk : inout Bool) {
    if ioOk, let v = inScanner.scanInt () {
      self = .cu (v)
    }else{
      ioOk = false
      self = .zero
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func canariCodableEncodedString () -> String {
    return "\(self.cuValue)"
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
