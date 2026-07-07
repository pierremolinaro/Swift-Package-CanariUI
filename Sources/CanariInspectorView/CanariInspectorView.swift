//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 23/06/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct CanariInspectorView <Content : View> : View { // where Content : View {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private let mTitle : String
  private let mContent : () -> Content

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (title inTitle : String,
               @ViewBuilder content : @escaping () -> Content) {
    self.mTitle = inTitle
    self.mContent = content
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var body : some View {
    HStack {
      Text (self.mTitle).bold ()
      Spacer ()
      self.mContent ()
    }
    .padding (6.0)
    .frame (maxWidth: .infinity)
    .background (RoundedRectangle(cornerRadius: 8.0).fill(.quinary))
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
