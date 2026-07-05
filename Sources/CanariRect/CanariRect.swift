//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 20/12/2025.
//--------------------------------------------------------------------------------------------------

import Foundation

//--------------------------------------------------------------------------------------------------
//  struct CanariRect
//--------------------------------------------------------------------------------------------------

public struct CanariRect : Hashable {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public let origin : CanariPoint
  public let size : CanariSize

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init () {
    self.origin = .zero
    self.size = .zero
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (origin inOrigin : CanariPoint, size inSize : CanariSize) {
    self.origin = inOrigin
    self.size = inSize
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (center inCenter : CanariPoint, size inSize : CanariSize) {
    self.origin = CanariPoint (
      x: inCenter.x - inSize.width / 2.0,
      y: inCenter.y - inSize.height / 2.0
    )
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

}

//--------------------------------------------------------------------------------------------------

