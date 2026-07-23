//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 08/08/2025.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

extension CanariRGBAColor : RawRepresentable {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public typealias RawValue = String // RawRepresentable

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init? (rawValue inRawValue : String) { // RawRepresentable
    let components = inRawValue.split (separator: " ")
    if components.count == 4,
       let red = UInt8 (components[0]),
       let green = UInt8 (components[1]),
       let blue = UInt8 (components[2]),
       let alpha = UInt8 (components[3]) {
      self.init (red: red, green: green, blue: blue, alpha: alpha)
    }else{
      return nil
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var rawValue : String { // RawRepresentable
    return "\(self.red) \(self.green) \(self.blue) \(self.alpha)"
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
