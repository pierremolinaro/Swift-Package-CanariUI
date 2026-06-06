//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 22/03/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public extension Button {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @ViewBuilder func customCancelActionDecoration (disabled inDisabled : Bool = false) -> some View {
    if inDisabled {
      self.disabled (true)
    }else{
      self
      .keyboardShortcut (.cancelAction)
      .overlay (RoundedRectangle (cornerRadius: 6).stroke (.purple, lineWidth: 1.5))
    }
  }

  //       .tint (.red.opacity (0.75))
  //       .buttonStyle (.borderedProminent)
  //       .buttonStyle (.bordered)
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
