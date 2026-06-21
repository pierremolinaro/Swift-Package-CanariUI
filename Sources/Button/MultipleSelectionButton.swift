//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 21/06/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct MultipleSelectionButton : View {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private let mAction : @MainActor () -> Void

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (value inAction : @escaping @MainActor () -> Void) {
    self.mAction = inAction
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var body : some View {
    HStack {
      Text (MULTIPLE_VALUES_MARK)
      Button ("", systemImage: "arrowtriangle.down.square") { self.mAction () }
      .labelStyle (.iconOnly)
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------

