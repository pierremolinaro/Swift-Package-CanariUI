//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 25/03/2026.
//--------------------------------------------------------------------------------------------------

import Foundation

//--------------------------------------------------------------------------------------------------

final class WidgetKnobAction <TypeDictionary : WidgetTypeArrayProtocol> {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private let mWidgetsUserInterface : WidgetsUserInterface <TypeDictionary>
  private let mWidgetIndex : Int

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  init (_ inWidgetsUserInterface : WidgetsUserInterface <TypeDictionary>,
        _ inIndex : Int) {
    self.mWidgetsUserInterface = inWidgetsUserInterface
    self.mWidgetIndex = inIndex
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func execute (_ inAction : (inout any WidgetUIProtocol <TypeDictionary>) -> Void) {
    var widget = self.mWidgetsUserInterface.mWidgetsManager [widget: self.mWidgetIndex]
    inAction (&widget)
    self.mWidgetsUserInterface.mWidgetsManager [widget: self.mWidgetIndex] = widget
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------

