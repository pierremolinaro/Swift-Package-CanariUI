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
//   Functions
//--------------------------------------------------------------------------------------------------

public func sin (_ inAngle : CanariAngle) -> Double {
  return sin (inAngle.value (in: .radians))
}

//--------------------------------------------------------------------------------------------------

public func sin (degrees inAngle : Double) -> Double {
  return sin (inAngle * .pi / 180.0)
}

//--------------------------------------------------------------------------------------------------

public func cos (_ inAngle : CanariAngle) -> Double {
  return cos (inAngle.value (in: .radians))
}

//--------------------------------------------------------------------------------------------------

public func cos (degrees inAngle : Double) -> Double {
  return cos (inAngle * .pi / 180.0)
}

//--------------------------------------------------------------------------------------------------

public func tan (_ inAngle : CanariAngle) -> Double {
  return sin (inAngle) / cos (inAngle)
}

//--------------------------------------------------------------------------------------------------

public func tan (degrees inAngle : Double) -> Double {
  return sin (degrees: inAngle) / cos (degrees: inAngle)
}

//--------------------------------------------------------------------------------------------------
