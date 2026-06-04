//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 04/06/2026.
//--------------------------------------------------------------------------------------------------

import Foundation

//--------------------------------------------------------------------------------------------------

public final class InspectorProxy <TypeDictionary : WidgetTypeArrayProtocol> {

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

  public func getWidget <T : WidgetUIProtocol <TypeDictionary> > () -> T {
    self.mWidgetsUserInterface.mWidgetsManager [widget: self.mWidgetIndex] as! T
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func setProperty <T : WidgetUIProtocol <TypeDictionary>, Value> (
          _ inKey : WritableKeyPath <T, Value>,
          _ inValue : Value) {
    var newWidget : T = self.getWidget ()
    newWidget [keyPath: inKey] = inValue
    self.mWidgetsUserInterface.mWidgetsManager [widget: self.mWidgetIndex] = newWidget
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func getProperty <T : WidgetUIProtocol <TypeDictionary>, Value> (
          _ inKey : KeyPath <T, Value>) -> Value {
    let newWidget : T = self.getWidget ()
    return newWidget [keyPath: inKey]
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------

