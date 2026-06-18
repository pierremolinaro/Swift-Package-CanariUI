//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 07/06/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct CanariElementExpandableInspector <Content> : View where Content : View {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private let mTitle : String
  private let mSubTitle : String
  private let mContent : () -> Content
  @Binding private var mIsExpanded : Bool

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (title inTitle : String,
               subTitle inSubTitle : String,
               isExpanded inIsExpanded : Binding <Bool>,
               @ViewBuilder content : @escaping () -> Content) {
    self.mTitle = inTitle
    self.mSubTitle = inSubTitle
    self._mIsExpanded = inIsExpanded
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
    .background (RoundedRectangle(cornerRadius: 8.0).fill(.quinary))
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
