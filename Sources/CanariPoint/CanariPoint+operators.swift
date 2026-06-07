//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 15/11/2024.
//--------------------------------------------------------------------------------------------------

import Foundation

//--------------------------------------------------------------------------------------------------

public func + (_ inLeft : CanariPoint, _ inRight : CanariPoint) -> CanariPoint {
  return CanariPoint (x: inLeft.x + inRight.x, y: inLeft.y + inRight.y)
}

//--------------------------------------------------------------------------------------------------

public func + (_ inLeft : CanariPoint, _ inRight : CanariSize) -> CanariPoint {
  return CanariPoint (x: inLeft.x + inRight.width, y: inLeft.y + inRight.height)
}

//--------------------------------------------------------------------------------------------------

public func - (_ inLeft : CanariPoint, _ inRight : CanariPoint) -> CanariPoint {
  return CanariPoint (x: inLeft.x - inRight.x, y: inLeft.y - inRight.y)
}

//--------------------------------------------------------------------------------------------------

public func - (_ inLeft : CanariPoint, _ inRight : CanariSize) -> CanariPoint {
  return CanariPoint (x: inLeft.x - inRight.width, y: inLeft.y - inRight.height)
}

//--------------------------------------------------------------------------------------------------

public prefix func - (_ inOperand : CanariPoint) -> CanariPoint {
  return CanariPoint (x: -inOperand.x, y: -inOperand.y)
}

//--------------------------------------------------------------------------------------------------

public func * (_ inLeft : CGFloat, _ inRight : CanariPoint) -> CanariPoint {
  return CanariPoint (x: inLeft * inRight.x, y: inLeft * inRight.y)
}

//--------------------------------------------------------------------------------------------------

public func / (_ inLeft : CanariPoint, _ inRight : CGFloat) -> CanariPoint {
  return CanariPoint (x: inLeft.x / inRight, y: inLeft.y / inRight)
}

//--------------------------------------------------------------------------------------------------

public func += (_ ioLeft : inout CanariPoint, _ inRight : CanariPoint) {
  ioLeft = ioLeft + inRight
}

//--------------------------------------------------------------------------------------------------

public func += (_ ioLeft : inout CanariPoint, _ inRight : CanariSize) {
  ioLeft = ioLeft + inRight
}

//--------------------------------------------------------------------------------------------------

public func -= (_ ioLeft : inout CanariPoint, _ inRight : CanariPoint) {
  ioLeft = ioLeft - inRight
}

//--------------------------------------------------------------------------------------------------

public func *= (_ ioLeft : inout CanariPoint, _ inRight : CGFloat) {
  ioLeft = inRight * ioLeft
}

//--------------------------------------------------------------------------------------------------

public func /= (_ ioLeft : inout CanariPoint, _ inRight : CGFloat) {
  ioLeft = ioLeft / inRight
}

//--------------------------------------------------------------------------------------------------

public extension Array where Element == CanariPoint {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  var xMirrored : [CanariPoint] {
    var result = [CanariPoint] ()
    for p in self {
      result.append (p.xMirrored)
    }
    return result
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  var yMirrored : [CanariPoint] {
    var result = [CanariPoint] ()
    for p in self {
      result.append (p.yMirrored)
    }
    return result
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
