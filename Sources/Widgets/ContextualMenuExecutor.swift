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

  public func execute <T : CanariShapeUIProtocol <WidgetTypesDescription>> (_ inAction : (inout T) -> Void) {
    var widget = self.mWidgetsUserInterface [widgetIndex: self.mWidgetIndex]
    if var shape = widget.shape as? T {
      inAction (&shape)
      widget.shape = shape
      self.mWidgetsUserInterface [widgetIndex: self.mWidgetIndex] = widget
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
