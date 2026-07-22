//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 07/09/2024.
//--------------------------------------------------------------------------------------------------

import Foundation

//--------------------------------------------------------------------------------------------------
//  Operators
//--------------------------------------------------------------------------------------------------

public func + (_ inLeft : CanariVolume, _ inRight : CanariVolume) -> CanariVolume {
  return CanariVolume (adding: inLeft, inRight)
}

//--------------------------------------------------------------------------------------------------

public func += (_ ioLeft : inout CanariVolume, _ inRight : CanariVolume) {
  ioLeft = CanariVolume (adding: ioLeft, inRight)
}

//--------------------------------------------------------------------------------------------------

public prefix func - (_ inOperand : CanariVolume) -> CanariVolume {
  return inOperand.multipliedBy (int: -1)
}

//--------------------------------------------------------------------------------------------------

public prefix func + (_ inOperand : CanariVolume) -> CanariVolume {
  return inOperand
}

//--------------------------------------------------------------------------------------------------

public func - (_ inLeft : CanariVolume, _ inRight : CanariVolume) -> CanariVolume {
  return CanariVolume (adding: inLeft, -inRight)
}

//--------------------------------------------------------------------------------------------------

public func -= (_ ioLeft : inout CanariVolume, _ inRight : CanariVolume) {
  ioLeft = CanariVolume (adding: ioLeft, -inRight)
}

//--------------------------------------------------------------------------------------------------

public func * (_ inLeft : Double, _ inRight : CanariVolume) -> CanariVolume {
  return CanariVolume (inRight, multipliedByDouble: inLeft)
}

//--------------------------------------------------------------------------------------------------

public func * (_ inLeft : Int128, _ inRight : CanariVolume) -> CanariVolume {
  return CanariVolume (inRight, multipliedByInt: inLeft)
}

//--------------------------------------------------------------------------------------------------

public func * (_ inLeft : CanariVolume, _ inRight : Double) -> CanariVolume {
  return CanariVolume (inLeft, multipliedByDouble: inRight)
}

//--------------------------------------------------------------------------------------------------

public func * (_ inLeft : CanariVolume, _ inRight : Int128) -> CanariVolume {
  return CanariVolume (inLeft, multipliedByInt: inRight)
}

//--------------------------------------------------------------------------------------------------

public func / (_ inLeft : CanariVolume, _ inRight : CanariVolume) -> Double {
  return inLeft.value (in: .mm3) / inRight.value (in: .mm3)
}

//--------------------------------------------------------------------------------------------------

public func / (_ inLeft : CanariVolume, _ inRight : Double) -> CanariVolume {
  return .cu3 (int: Int128 (Double (inLeft.cu3Value) / inRight))
}

//--------------------------------------------------------------------------------------------------

public func / (_ inLeft : CanariVolume, _ inRight : Int128) -> CanariVolume {
  return .cu3 (int: inLeft.cu3Value / inRight)
}

//--------------------------------------------------------------------------------------------------

public func / (_ inLeft : CanariVolume, _ inRight : CanariLength) -> CanariArea {
  return .cu2 (Int (inLeft.cu3Value / Int128 (inRight.cuValue)))
}

//--------------------------------------------------------------------------------------------------

public func / (_ inLeft : CanariVolume, _ inRight : CanariArea) -> CanariLength {
  return .cu (Int (inLeft.cu3Value / Int128 (inRight.cu2Value)))
}

//--------------------------------------------------------------------------------------------------

public func == (_ inLeft : CanariVolume, _ inRight : CanariVolume) -> Bool {
  return inLeft.cu3Value == inRight.cu3Value
}

//--------------------------------------------------------------------------------------------------

public func != (_ inLeft : CanariVolume, _ inRight : CanariVolume) -> Bool {
  return inLeft.cu3Value != inRight.cu3Value
}

//--------------------------------------------------------------------------------------------------

public func <= (_ inLeft : CanariVolume, _ inRight : CanariVolume) -> Bool {
  return inLeft.cu3Value <= inRight.cu3Value
}

//--------------------------------------------------------------------------------------------------

public func >= (_ inLeft : CanariVolume, _ inRight : CanariVolume) -> Bool {
  return inLeft.cu3Value >= inRight.cu3Value
}

//--------------------------------------------------------------------------------------------------

public func < (_ inLeft : CanariVolume, _ inRight : CanariVolume) -> Bool {
  return inLeft.cu3Value < inRight.cu3Value
}

//--------------------------------------------------------------------------------------------------

public func > (_ inLeft : CanariVolume, _ inRight : CanariVolume) -> Bool {
  return inLeft.cu3Value > inRight.cu3Value
}

//--------------------------------------------------------------------------------------------------
