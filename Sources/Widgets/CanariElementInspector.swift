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
  @State private var mIsExpanded = true

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
    DisclosureGroup (isExpanded: self.$mIsExpanded) {
      self.mContent ()
    } label: {
      HStack {
        Text (self.mTitle).bold ()
        Spacer ()
        if !self.mSubTitle.isEmpty, self.mIsExpanded {
          Text (self.mSubTitle)
        }
      }
    }
    .padding (6.0)
    .frame (maxWidth: .infinity)
    .background (RoundedRectangle(cornerRadius: 6.0).fill(Color.gray.opacity(0.1)))
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
