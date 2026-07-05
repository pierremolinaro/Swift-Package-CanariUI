//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 08/08/2025.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

extension CanariRGBColor : RawRepresentable {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public typealias RawValue = String // RawRepresentable

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var rawValue : String { // RawRepresentable
    return "\(self.red) \(self.green) \(self.blue)"
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init? (rawValue inRawValue : String) { // RawRepresentable
    let components = inRawValue.split (separator: " ")
    if components.count == 3,
       let red = UInt8 (components[0]),
       let green = UInt8 (components[1]),
       let blue = UInt8 (components[2]) {
      self.init (red: red, green: green, blue: blue)
    }else{
      return nil
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
