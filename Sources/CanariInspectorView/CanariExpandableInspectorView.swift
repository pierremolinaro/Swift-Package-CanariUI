//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 07/06/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct CanariExpandableInspectorView <Content : View> : View { // where Content : View {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private let mTitle : String
  private let mExpandedSubTitle : (() -> any View)?
  private let mCollapsedSubTitle : (() -> any View)?
  private let mContent : () -> Content
  @Binding private var mIsExpanded : Bool

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (title inTitle : String,
               isExpanded inIsExpanded : Binding <Bool>,
               expandedSubtitle inExpandedSubTitle : (() -> any View)? = nil,
               collapsedSubtitle inCollapsedSubTitle : (() -> any View)? = nil,
               @ViewBuilder content : @escaping () -> Content) {
    self.mTitle = inTitle
    self.mExpandedSubTitle = inExpandedSubTitle
    self.mCollapsedSubTitle = inCollapsedSubTitle
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
        if self.mIsExpanded, let v = self.mExpandedSubTitle {
          AnyView (v ())
        }else if !self.mIsExpanded, let v = self.mCollapsedSubTitle {
          AnyView (v ())
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
