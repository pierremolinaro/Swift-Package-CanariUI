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

  public func execute <T : CanariDecoratorUIProtocol <WidgetTypesDescription>> (_ inAction : (inout T) -> Void) {
    var widget = self.mWidgetsUserInterface [widgetIndex: self.mWidgetIndex]
    if var decorator = widget.decorator as? T {
      inAction (&decorator)
      widget.decorator = decorator
      self.mWidgetsUserInterface [widgetIndex: self.mWidgetIndex] = widget
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
