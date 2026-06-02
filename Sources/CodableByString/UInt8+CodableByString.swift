//
//  Scanner+myScanUInt8.swift
//  editeur-courbes-bezier
//
//  Created by Pierre Molinaro on 18/09/2025.
//
//--------------------------------------------------------------------------------------------------

import AppKit

//--------------------------------------------------------------------------------------------------

extension UInt8 : CodableByString {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (scanner inScanner : Scanner, _ ioOk : inout Bool) {
    if ioOk, let v = inScanner.scanUInt64 (), v <= UInt8.max {
      self = UInt8 (v)
    }else{
      ioOk = false
      self = .zero
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func encodedString () -> String {
    return "\(self)"
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
