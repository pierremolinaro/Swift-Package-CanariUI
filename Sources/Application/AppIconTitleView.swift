//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 13/08/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct AppIconTitleView <TitleView> : View where TitleView : View {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private let titleView : TitleView

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (titleView : TitleView) {
    self.titleView = titleView
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var body : some View {
    HStack {
      Image (nsImage: NSApplication.shared.applicationIconImage)
      .resizable ()
      .frame (width: 64, height: 64)
      Spacer ()
      self.titleView
      Spacer ()
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
