//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 07/06/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct CanariElementInspector <Content> : View where Content : View {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private let mTitle : String
  private let mSubTitle : String
  private let mContent : () -> Content

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (title inTitle : String,
               subTitle inSubTitle : String,
               @ViewBuilder content : @escaping () -> Content) {
    self.mTitle = inTitle
    self.mSubTitle = inSubTitle
    self.mContent = content
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var body : some View {
    VStack {
      HStack {
        Text (self.mTitle).bold ()
        Spacer ()
        if !self.mSubTitle.isEmpty {
          Text (self.mSubTitle)
        }
      }
      self.mContent ()
    }
    .padding (6.0)
    .frame (maxWidth: .infinity)
    .background (RoundedRectangle(cornerRadius: 6.0).fill(Color.gray.opacity(0.1)))
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
