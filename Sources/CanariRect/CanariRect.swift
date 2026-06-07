//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 20/12/2025.
//--------------------------------------------------------------------------------------------------

import Foundation
import CanariGeometry

//--------------------------------------------------------------------------------------------------
//  struct CanariRect
//--------------------------------------------------------------------------------------------------

public struct CanariRect : Hashable, CustomStringConvertible, Sendable, Codable {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private let origin : CanariPoint
  public let size : CanariSize

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (origin inOrigin : CanariPoint, size inSize : CanariSize) {
    self.origin = inOrigin
    self.size = inSize
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (center inCenter : CanariPoint, size inSize : CanariSize) {
    self.origin = CanariPoint (x: inCenter.x - inSize.width / 2.0, y: inCenter.y - inSize.height / 2.0)
    self.size = inSize
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (left inLeft : CanariLength,
               bottom inBottom : CanariLength,
               width inWidth : CanariLength,
               height inHeight : CanariLength) {
    self.origin = CanariPoint (x: inLeft, y: inBottom)
    self.size = CanariSize (width: inWidth, height: inHeight)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (px inRect : NSRect) {
    self.init (origin: CanariPoint (px: inRect.origin), size: CanariSize (px: inRect.size))
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (_ inPoints : [CanariPoint]) {
    if inPoints.isEmpty {
      self = Self.empty
    }else{
      var minX = inPoints [0].x
      var maxX = inPoints [0].x
      var minY = inPoints [0].y
      var maxY = inPoints [0].y
      for p in inPoints {
        minX = min (minX, p.x)
        maxX = max (maxX, p.x)
        minY = min (minY, p.y)
        maxY = max (maxY, p.y)
      }
      self.init (left: minX, bottom: minY, width: maxX - minX, height: maxY - minY)
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (from inDecoder : any Decoder) throws { // Decodable
    let container = try inDecoder.singleValueContainer ()
    let string = try container.decode (String.self)
    let components = string.split (separator: " ")
    if components.count == 4,
       let x = Int (components [0]),
       let y = Int (components [1]),
       let width = Int (components [2]),
       let height = Int (components [3]) {
      self.origin = CanariPoint (x: .cu (x), y: .cu (y))
      self.size = CanariSize (width: .cu (width), height: .cu (height))
    }else {
      throw DecodingError.dataCorruptedError (in: container, debugDescription: "Invalid rectangle string")
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func encode (to inEncoder : any Encoder) throws { // Encodable
    var container = inEncoder.singleValueContainer ()
    try container.encode ("\(self.origin.x.cuValue) \(self.origin.y.cuValue) \(self.size.width.cuValue) \(self.size.height.cuValue)")
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public static var empty : CanariRect { CanariRect (origin: .zero, size: .zero) }
  public var isEmpty : Bool { (self.size.width <= .zero) || (self.size.height <= .zero) }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func aligned (to inUnit : CanariLength?) -> CanariRect {
    return CanariRect (origin: self.origin.aligning (to: inUnit), size: self.size.aligning (to: inUnit))
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var pxValue : NSRect { NSRect (origin: self.origin.pxValue, size: self.size.pxValue) }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var width : CanariLength { self.size.width }
  public var height : CanariLength { self.size.height }
  public var midX : CanariLength { self.origin.x + self.size.width / 2.0 }
  public var midY : CanariLength { self.origin.y + self.size.height / 2.0 }
  public var minX : CanariLength { self.origin.x }
  public var maxX : CanariLength { self.origin.x + self.size.width }
  public var minY : CanariLength { self.origin.y }
  public var maxY : CanariLength { self.origin.y + self.size.height }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var bottomLeft : CanariPoint { self.origin }
  public var bottomRight : CanariPoint { CanariPoint (x: self.maxX, y: self.minY) }
  public var topLeft : CanariPoint { CanariPoint (x: self.minX, y: self.maxY) }
  public var topRight : CanariPoint { CanariPoint (x: self.maxX, y: self.maxY) }
  public var topMiddle : CanariPoint { CanariPoint (x: self.midX, y: self.maxY) }
  public var bottomMiddle : CanariPoint { CanariPoint (x: self.midX, y: self.minY) }
  public var middleLeft : CanariPoint { CanariPoint (x: self.minX, y: self.midY) }
  public var middleRight : CanariPoint { CanariPoint (x: self.maxX, y: self.midY) }
  public var center : CanariPoint { CanariPoint (x: self.midX, y: self.midY) }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var vertices : [CanariPoint] { [self.topLeft, self.topRight, self.bottomRight, self.bottomLeft] }
  
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  /**
    A textual representation of this instance.
  */

  public var description : String { // CustomStringConvertible protocol
    return "origin: \(self.origin), size: \(self.size)"
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func contains (_ inPoint : CanariPoint) -> Bool {
    var result = inPoint.x >= self.minX
    if result {
      result = inPoint.x <= self.maxX
    }
    if result {
      result = inPoint.y >= self.minY
    }
    if result {
      result = inPoint.y <= self.maxY
    }
    return result
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func intersects (_ inRect : CanariRect) -> Bool {
    let minX = max (self.minX, inRect.minX)
    let maxX = min (self.maxX, inRect.maxX)
    var result = minX < maxX
    if result {
      let minY = max (self.minY, inRect.minY)
      let maxY = min (self.maxY, inRect.maxY)
      result = minY < maxY
    }
    return result
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func scaled (by inScale : CGFloat) -> CanariRect {
    return CanariRect (
      origin: CanariPoint (x: self.origin.x * inScale, y: self.origin.y * inScale),
      size: CanariSize (width: self.size.width * inScale, height: self.size.height * inScale)
    )
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func isAligned (_ inUnit : CanariLength) -> Bool {
    return self.origin.isAligned (inUnit) && self.size.isAligned (inUnit)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func aligning (to inUnit : CanariLength?) -> Self {
    return Self (origin: self.origin.aligning (to: inUnit), size: self.size.aligning (to: inUnit))
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func unioning (_ inOtherRect : CanariRect) -> CanariRect {
    if self.isEmpty {
      return inOtherRect
    }else if inOtherRect.isEmpty {
      return self
    }else{
      return CanariRect ([self.bottomLeft, self.topRight, inOtherRect.bottomLeft, inOtherRect.topRight])
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func moved (x inX : CanariLength, y inY : CanariLength) -> CanariRect {
    CanariRect (left: self.origin.x + inX, bottom: self.origin.y + inY, width: self.width, height: self.height)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------

