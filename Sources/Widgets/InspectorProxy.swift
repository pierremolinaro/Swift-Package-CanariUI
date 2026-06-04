//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 04/06/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public final class InspectorProxy <TypeDictionary : WidgetTypeArrayProtocol> {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private let mWidgetsUserInterface : WidgetsUserInterface <TypeDictionary>
  private let mID : UUID

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  init (_ inWidgetsUserInterface : WidgetsUserInterface <TypeDictionary>,
        _ inID : UUID) {
    self.mWidgetsUserInterface = inWidgetsUserInterface
    self.mID = inID
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

//  public func getWidget <T : WidgetUIProtocol <TypeDictionary> > () -> T {
//    self.mWidgetsUserInterface.mWidgetsManager [id: self.mID] as! T
//  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

//  public func setProperty <T : WidgetUIProtocol <TypeDictionary>, Value> (
//          _ inKey : WritableKeyPath <T, Value>,
//          _ inValue : Value) {
//    var newWidget : T = self.getWidget ()
//    newWidget [keyPath: inKey] = inValue
//    self.mWidgetsUserInterface.mWidgetsManager [id: self.mID] = newWidget
//  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

//  public func getProperty <T : WidgetUIProtocol <TypeDictionary>, Value> (
//          _ inKey : KeyPath <T, Value>) -> Value {
//    let newWidget : T = self.getWidget ()
//    return newWidget [keyPath: inKey]
//  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func getBinding <T : WidgetUIProtocol <TypeDictionary>> () -> Binding <T?> {
    let binding = Binding <T?> (
      get: { self.mWidgetsUserInterface.mWidgetsManager [id: self.mID] as? T },
      set: {
        if let widget = $0 {
          self.mWidgetsUserInterface.mWidgetsManager [id: self.mID] = widget
        }
      }
    )
    return binding
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------

