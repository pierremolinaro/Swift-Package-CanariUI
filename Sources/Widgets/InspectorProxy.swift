//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 04/06/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public final class InspectorProxy <TypeDictionary : WidgetTypeArrayProtocol> {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private let mWidgetsUserInterface : WidgetsUserInterface <TypeDictionary>
  private let mSelection : Set <UUID>

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  init (_ inWidgetsUserInterface : WidgetsUserInterface <TypeDictionary>,
        _ inID : Set <UUID>) {
    self.mWidgetsUserInterface = inWidgetsUserInterface
    self.mSelection = inID
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public subscript <T : WidgetUIProtocol <TypeDictionary>, Value : Equatable> (bindingFor inKeyPath : WritableKeyPath <T, Value>) -> Binding <Value?> {
    let binding = Binding <Value?> (
      get: {
        var result : Value? = nil
        for id in self.mSelection {
          if let v = self.mWidgetsUserInterface.mWidgetsManager [id: id] as? T {
            let property = v [keyPath: inKeyPath]
            if let r = result {
              if r != property {
                return nil
              }
            }else{
              result = property
            }
          }
        }
        return result
      },
      set: {
        if let property = $0 {
          for id in self.mSelection {
            if var v = self.mWidgetsUserInterface.mWidgetsManager [id: id] as? T {
              v [keyPath: inKeyPath] = property
              self.mWidgetsUserInterface.mWidgetsManager [id: id] = v
            }
          }
        }
      }
    )
    return binding
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func optValueOf <T : WidgetUIProtocol <TypeDictionary>, Value : Equatable> (_ inKeyPath : KeyPath <T, Value>) -> Value? {
    var result : Value? = nil
    for id in self.mSelection {
      if let v = self.mWidgetsUserInterface.mWidgetsManager [id: id] as? T {
        let property = v [keyPath: inKeyPath]
        if let r = result {
          if r != property {
            return nil
          }
        }else{
          result = property
        }
      }
    }
    return result
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func setOf <T : WidgetUIProtocol <TypeDictionary>, Value : Hashable> (_ inKeyPath : KeyPath <T, Value>) -> Set <Value> {
    var result = Set <Value> ()
    for id in self.mSelection {
      if let v = self.mWidgetsUserInterface.mWidgetsManager [id: id] as? T {
        let property = v [keyPath: inKeyPath]
        result.insert (property)
      }
    }
    return result
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func arrayOf <T : WidgetUIProtocol <TypeDictionary>, Value : Hashable> (_ inKeyPath : KeyPath <T, Value>) -> [Value] {
    return Array (self.setOf (inKeyPath))
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func setProperty <T : WidgetUIProtocol <TypeDictionary>, Value> (_ inKeyPath : WritableKeyPath <T, Value>, _ inValue : Value) {
    for id in self.mSelection {
      if var v = self.mWidgetsUserInterface.mWidgetsManager [id: id] as? T {
        v [keyPath: inKeyPath] = inValue
        self.mWidgetsUserInterface.mWidgetsManager [id: id] = v
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func performWidgetUserInterfaceAction (_ inAction : (WidgetsUserInterface <TypeDictionary>) -> Void) {
    inAction (self.mWidgetsUserInterface)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func performWidgetAction <T : WidgetUIProtocol <TypeDictionary> > (_ inAction : (inout T) -> Void) {
    for id in self.mSelection {
      if var widget = self.mWidgetsUserInterface.mWidgetsManager [id: id] as? T {
        inAction (&widget)
        self.mWidgetsUserInterface.mWidgetsManager [id: id] = widget
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------

