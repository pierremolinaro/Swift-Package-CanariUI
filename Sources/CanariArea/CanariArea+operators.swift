//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 07/09/2024.
//--------------------------------------------------------------------------------------------------

import Foundation

//--------------------------------------------------------------------------------------------------
//  Operators
//--------------------------------------------------------------------------------------------------

public func + (_ inLeft : CanariArea, _ inRight : CanariArea) -> CanariArea {
  return CanariArea (adding: inLeft, inRight)
}

//--------------------------------------------------------------------------------------------------

public func += (_ ioLeft : inout CanariArea, _ inRight : CanariArea) {
  ioLeft = CanariArea (adding: ioLeft, inRight)
}

//--------------------------------------------------------------------------------------------------

public prefix func - (_ inOperand : CanariArea) -> CanariArea {
  return inOperand.multipliedBy (-1)
}

//--------------------------------------------------------------------------------------------------

public prefix func + (_ inOperand : CanariArea) -> CanariArea {
  return inOperand
}

//--------------------------------------------------------------------------------------------------

public func - (_ inLeft : CanariArea, _ inRight : CanariArea) -> CanariArea {
  return CanariArea (adding: inLeft, -inRight)
}

//--------------------------------------------------------------------------------------------------

public func -= (_ ioLeft : inout CanariArea, _ inRight : CanariArea) {
  ioLeft = CanariArea (adding: ioLeft, -inRight)
}

//--------------------------------------------------------------------------------------------------

public func * (_ inLeft : Double, _ inRight : CanariArea) -> CanariArea {
  return CanariArea (inRight, multipliedByDouble: inLeft)
}

//--------------------------------------------------------------------------------------------------

public func * (_ inLeft : Int, _ inRight : CanariArea) -> CanariArea {
  return CanariArea (inRight, multipliedByInt: inLeft)
}

//--------------------------------------------------------------------------------------------------

public func * (_ inLeft : CanariArea, _ inRight : Double) -> CanariArea {
  return CanariArea (inLeft, multipliedByDouble: inRight)
}

//--------------------------------------------------------------------------------------------------

public func * (_ inLeft : CanariArea, _ inRight : CanariLength) -> CanariVolume {
  return .cu3 (int: Int128 (inLeft.cu2Value) * Int128 (inRight.cuValue))
}

//--------------------------------------------------------------------------------------------------

public func * (_ inLeft : CanariLength, _ inRight : CanariArea) -> CanariVolume {
  return .cu3 (int: Int128 (inLeft.cuValue) * Int128 (inRight.cu2Value))
}

//--------------------------------------------------------------------------------------------------

public func * (_ inLeft : CanariArea, _ inRight : Int) -> CanariArea {
  return CanariArea (inLeft, multipliedByInt: inRight)
}

//--------------------------------------------------------------------------------------------------

public func / (_ inLeft : CanariArea, _ inRight : CanariArea) -> Double {
  return inLeft.value (in: .mm2) / inRight.value (in: .mm2)
}

//--------------------------------------------------------------------------------------------------

public func / (_ inLeft : CanariArea, _ inRight : Double) -> CanariArea {
  return .cu2 (Int (Double (inLeft.cu2Value) / inRight))
}

//--------------------------------------------------------------------------------------------------

public func / (_ inLeft : CanariArea, _ inRight : Int) -> CanariArea {
  return .cu2 (inLeft.cu2Value / inRight)
}

//--------------------------------------------------------------------------------------------------

public func / (_ inLeft : CanariArea, _ inRight : CanariLength) -> CanariLength {
  return .cu (inLeft.cu2Value / inRight.cuValue)
}

//--------------------------------------------------------------------------------------------------

public func == (_ inLeft : CanariArea, _ inRight : CanariArea) -> Bool {
  return inLeft.cu2Value == inRight.cu2Value
}

//--------------------------------------------------------------------------------------------------

public func != (_ inLeft : CanariArea, _ inRight : CanariArea) -> Bool {
  return inLeft.cu2Value != inRight.cu2Value
}

//--------------------------------------------------------------------------------------------------

public func <= (_ inLeft : CanariArea, _ inRight : CanariArea) -> Bool {
  return inLeft.cu2Value <= inRight.cu2Value
}

//--------------------------------------------------------------------------------------------------

public func >= (_ inLeft : CanariArea, _ inRight : CanariArea) -> Bool {
  return inLeft.cu2Value >= inRight.cu2Value
}

//--------------------------------------------------------------------------------------------------

public func < (_ inLeft : CanariArea, _ inRight : CanariArea) -> Bool {
  return inLeft.cu2Value < inRight.cu2Value
}

//--------------------------------------------------------------------------------------------------

public func > (_ inLeft : CanariArea, _ inRight : CanariArea) -> Bool {
  return inLeft.cu2Value > inRight.cu2Value
}

//--------------------------------------------------------------------------------------------------
