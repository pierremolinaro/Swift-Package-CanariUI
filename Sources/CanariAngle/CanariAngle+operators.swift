//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 08/09/2024.
//--------------------------------------------------------------------------------------------------

import Foundation

//--------------------------------------------------------------------------------------------------
//  Operators
//--------------------------------------------------------------------------------------------------

public func + (_ inLeft : CanariAngle, _ inRight : CanariAngle) -> CanariAngle {
  return CanariAngle (adding: inLeft, inRight)
}

//--------------------------------------------------------------------------------------------------

public func += (_ ioLeft : inout CanariAngle, _ inRight : CanariAngle) {
  ioLeft = CanariAngle (adding: ioLeft, inRight)
}

//--------------------------------------------------------------------------------------------------

public prefix func - (_ inOperand : CanariAngle) -> CanariAngle {
  return CanariAngle (inOperand, multiplyBy: -1.0)
}

//--------------------------------------------------------------------------------------------------

public func - (_ inLeft : CanariAngle, _ inRight : CanariAngle) -> CanariAngle {
  return CanariAngle (adding: inLeft, -inRight)
}

//--------------------------------------------------------------------------------------------------

public func -= (_ ioLeft : inout CanariAngle, _ inRight : CanariAngle) {
  ioLeft = CanariAngle (adding: ioLeft, -inRight)
}

//--------------------------------------------------------------------------------------------------

public func * (_ inLeft : Double, _ inRight : CanariAngle) -> CanariAngle {
  return CanariAngle (inRight, multiplyBy: inLeft)
}

//--------------------------------------------------------------------------------------------------

public func * (_ inLeft : CanariAngle, _ inRight : Double) -> CanariAngle {
  return CanariAngle (inLeft, multiplyBy: inRight)
}

//--------------------------------------------------------------------------------------------------

public func / (_ inLeft : CanariAngle, _ inRight : Double) -> CanariAngle {
  return CanariAngle (inLeft, multiplyBy: 1.0 / inRight)
}

//--------------------------------------------------------------------------------------------------

