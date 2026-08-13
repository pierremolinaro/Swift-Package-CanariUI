//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 20/02/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct AppIconView : View {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private let title : String
  private let subtitle : any View?

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (title : String, subtitle : any View? = nil) {
    self.title = title
    self.subtitle = subtitle
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var body : some View {
    HStack {
      Image (nsImage: NSApplication.shared.applicationIconImage)
      .resizable ()
      .frame (width: 64, height: 64)
      Spacer ()
      if let view = self.subtitle {
        VStack {
          Text (self.title).bold ().controlSize (.large)
          AnyView (view)
        }
      }else{
        Text (self.title).bold ().controlSize (.large)
      }
      Spacer ()
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
