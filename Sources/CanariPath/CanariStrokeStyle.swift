//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 02/06/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI
import CanariGeometry

//--------------------------------------------------------------------------------------------------

public struct CanariStrokeStyle : Equatable, Sendable, CanariCodableByString {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var lineCapStyle : CGLineCap
  public var lineJoinStyle : CGLineJoin
  public var lineWidth : CanariLength
  public var miterLimit : CanariLength

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init () {
    self.lineCapStyle = .round
    self.lineJoinStyle = .round
    self.lineWidth = CanariLength.pt (1.0)
    self.miterLimit = CanariLength.pt (10.0)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (lineWidth inLineWidth : CanariLength) {
    self.lineCapStyle = .round
    self.lineJoinStyle = .round
    self.lineWidth = inLineWidth
    self.miterLimit = CanariLength.pt (10.0)
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
    if let v = inScanner.scanCanariLengthEncodedWithUnit () {
      self.lineWidth = v
    }else{
      self.lineWidth = .pt (1)
      ioOk = false
    }
    if let v = inScanner.scanCanariLengthEncodedWithUnit () {
      self.miterLimit = v
    }else{
      self.miterLimit = .pt (1)
      ioOk = false
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func canariCodableEncodedString () -> String {
    var str = "\(self.lineCapStyle.rawValue) \(self.lineJoinStyle.rawValue) "
    str += self.lineWidth.valueEncodedWithUnit
    str += " "
    str += self.miterLimit.valueEncodedWithUnit
    return str
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var swiftui : StrokeStyle {
    StrokeStyle (
      lineWidth: self.lineWidth.ptValue,
      lineCap: self.lineCapStyle,
      lineJoin: self.lineJoinStyle,
      miterLimit: self.miterLimit.ptValue
    )
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func scaled (by inScale : Double) -> CanariStrokeStyle {
    var r = CanariStrokeStyle ()
    r.lineWidth = self.lineWidth * inScale
    r.lineCapStyle = self.lineCapStyle
    r.lineJoinStyle = self.lineJoinStyle
    r.miterLimit = self.miterLimit * inScale
    return r
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
