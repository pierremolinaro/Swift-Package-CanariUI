//
//  Scanner+myScanCanariLength.swift
//  editeur-courbes-bezier
//
//  Created by Pierre Molinaro on 19/09/2025.
//
//--------------------------------------------------------------------------------------------------

import AppKit

//--------------------------------------------------------------------------------------------------

extension Scanner {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func myScanCanariLength (_ ioOk : inout Bool) -> CanariLength {
    if ioOk, let v = self.scanInt () {
      return .cu (v)
    }else{
      ioOk = false
      return .zero
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------

