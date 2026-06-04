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

//  private var mBindingDictionary : [ObjectIdentifier : Binding <Any?>] = [:]

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

//  public func propertyBinding <T : WidgetUIProtocol <TypeDictionary>, Value> (keyPath inKeyPath : WritableKeyPath <T, Value>) -> Binding <Value?> {
//    let binding = Binding <Value?> (
//      get: {
//       if let v = self.mWidgetsUserInterface.mWidgetsManager [id: self.mID] as? T {
//         return v [keyPath: inKeyPath]
//       }else{
//         return nil
//       }
//      },
//      set: {
//        if let property = $0, var v = self.mWidgetsUserInterface.mWidgetsManager [id: self.mID] as? T {
//          v [keyPath: inKeyPath] = property
//          self.mWidgetsUserInterface.mWidgetsManager [id: self.mID] = v
//        }
//      }
//    )
//    return binding
//  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

//  public func getBinding <T : WidgetUIProtocol <TypeDictionary>> () -> Binding <T?> {
//    let binding = Binding <T?> (
//      get: { self.mWidgetsUserInterface.mWidgetsManager [id: self.mID] as? T },
//      set: {
//        if let widget = $0 {
//          self.mWidgetsUserInterface.mWidgetsManager [id: self.mID] = widget
//        }
//      }
//    )
//    return binding
//  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public subscript <T : WidgetUIProtocol <TypeDictionary>, Value> (_ inKeyPath : WritableKeyPath <T, Value>) -> Binding <Value?> {
    let binding = Binding <Value?> (
      get: {
        if let v = self.mWidgetsUserInterface.mWidgetsManager [id: self.mID] as? T {
          return v [keyPath: inKeyPath]
        }else{
         return nil
        }
      },
      set: {
        if let property = $0, var v = self.mWidgetsUserInterface.mWidgetsManager [id: self.mID] as? T {
          v [keyPath: inKeyPath] = property
          self.mWidgetsUserInterface.mWidgetsManager [id: self.mID] = v
        }
      }
    )
    return binding
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------

