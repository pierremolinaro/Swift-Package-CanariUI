//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 25/03/2026.
//--------------------------------------------------------------------------------------------------

import Foundation

//--------------------------------------------------------------------------------------------------

public final class ContextualMenuExecutor <WidgetTypesDescription : DocumentWidgetsDescriptionProtocol> {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private let mWidgetsUserInterface : WidgetsUserInterface <WidgetTypesDescription>
  private let mWidgetIndex : Int

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  init (_ inWidgetsUserInterface : WidgetsUserInterface <WidgetTypesDescription>,
        _ inIndex : Int) {
    self.mWidgetsUserInterface = inWidgetsUserInterface
    self.mWidgetIndex = inIndex
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func execute <T : WidgetUIProtocol <WidgetTypesDescription>> (_ inAction : (inout T) -> Void) {
    if var widget = self.mWidgetsUserInterface [proxyIndex: self.mWidgetIndex].widget as? T {
      inAction (&widget)
      self.mWidgetsUserInterface [proxyIndex: self.mWidgetIndex] = WidgetProxy (widget)
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
