//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 08/09/2024.
//--------------------------------------------------------------------------------------------------

import Foundation

//--------------------------------------------------------------------------------------------------
//  struct CanariSize
//--------------------------------------------------------------------------------------------------

public struct CanariSize : Hashable, CustomStringConvertible, Sendable, RawRepresentable {

  public typealias RawValue = String // RawRepresentable

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var width : CanariLength
  public var height : CanariLength

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

//  public init () {
//    self.init (width: .zero, height: .zero)
//  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (px inSize : NSSize) {
    self.init (width: .px (inSize.width), height: .px (inSize.height))
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public static var zero : CanariSize { CanariSize () }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (width inWidth : CanariLength = .zero, height inHeight : CanariLength = .zero) {
    self.width = inWidth
    self.height = inHeight
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func aligning (to inUnit : CanariLength?) -> CanariSize {
    return CanariSize (width: self.width.aligning (to: inUnit), height: self.height.aligning (to: inUnit))
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var pxValue : CGSize { CGSize (width: self.width.pxValue, height: self.height.pxValue) }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var isZero : Bool { self.width.isZero && self.height.isZero }
  
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  /**
    A textual representation of this instance.
  */

  public var description : String { // CustomStringConvertible protocol
    return "width: \(self.width), height: \(self.height)"
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func isAligned (_ inUnit : CanariLength) -> Bool {
    return self.width.isAligned (inUnit) && self.height.isAligned (inUnit)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func string (in inUnit : CanariLength.Unit, fractionDigits inCount : Int = 3) -> String {
    return "(\(self.width.string (in: inUnit, fractionDigits: inCount)) x \(self.height.string (in: inUnit, fractionDigits: inCount)))"
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: RawRepresentable
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var rawValue : String { // RawRepresentable
    return "\(self.width.cuValue) \(self.height.cuValue)"
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init? (rawValue inRawValue : String) { // RawRepresentable
    let components = inRawValue.split (separator: " ")
    if components.count == 2,
       let width = Int (components[0]),
       let height = Int (components[1]) {
      self.init (width: .cu (width), height: .cu (height))
    }else{
      return nil
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
