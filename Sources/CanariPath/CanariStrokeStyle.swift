//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 02/06/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct CanariStrokeStyle : Equatable, CanariCodableByString, Sendable {

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
    if let v = CGLineCap (rawValue: Int32 (scanner: inScanner, &ioOk)) {
      self.lineCapStyle = v
    }else{
      self.lineCapStyle = .round
    }
    if let v = CGLineJoin (rawValue: Int32 (scanner: inScanner, &ioOk)) {
      self.lineJoinStyle = v
    }else{
      self.lineJoinStyle = .round
    }
    self.lineWidth = CanariLength (scanner: inScanner, &ioOk)
    self.miterLimit = CanariLength (scanner: inScanner, &ioOk)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init? (widthString inWidthString : String,
                linejoinString inLinejoinString: String,
                lineCapString inLineCapString : String) {
    if let lineWidth_px = Double (inWidthString) {
      if inLineCapString == "round" {
        self.lineCapStyle = .round
      }else{
        fatalError ("inLinejoinString not handled yet")
      }
      if inLinejoinString == "round" {
        self.lineJoinStyle = .round
      }else{
        fatalError ("inLinejoinString not handled yet")
      }
      self.lineWidth = CanariLength.px (lineWidth_px)
      self.miterLimit = CanariLength.px (10.0)
    }else{
      return nil
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func canariCodableEncodedString () -> String {
    var str = "\(self.lineCapStyle.rawValue) \(self.lineJoinStyle.rawValue) "
    str += self.lineWidth.canariCodableEncodedString ()
    str += " "
    str += self.miterLimit.canariCodableEncodedString ()
    return str
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
