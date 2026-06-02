//
//  StrokeContext.swift
//  CanariGeometry
//
//  Created by Pierre Molinaro on 02/06/2026.
//
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct CanariStrokeStyle : Equatable {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var lineCapStyle : CGLineCap
  public var lineJoinStyle : CGLineJoin
  public var lineWidth : CanariLength
  public var miterLimit : CanariLength

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init () {
    self.lineCapStyle = .round
    self.lineJoinStyle = .round
    self.lineWidth = CanariLength.px (1.0)
    self.miterLimit = CanariLength.px (10.0)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (scanner inScanner : Scanner, _ ioOk : inout Bool) {
    if let v = CGLineCap (rawValue: inScanner.myScanInt32 (&ioOk)) {
      self.lineCapStyle = v
    }else{
      self.lineCapStyle = .round
    }
    if let v = CGLineJoin (rawValue: inScanner.myScanInt32 (&ioOk)) {
      self.lineJoinStyle = v
    }else{
      self.lineJoinStyle = .round
    }
    self.lineWidth = inScanner.myScanCanariLength (&ioOk)
    self.miterLimit = inScanner.myScanCanariLength (&ioOk)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var strokeStyle : StrokeStyle {
    StrokeStyle (
      lineWidth: self.lineWidth.pxValue,
      lineCap: self.lineCapStyle,
      lineJoin: self.lineJoinStyle,
      miterLimit: self.miterLimit.pxValue
    )
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
