//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 04/06/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public final class InspectorProxy <WidgetTypesDescription : DocumentWidgetsDescriptionProtocol> {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private let mWidgetsUserInterface : WidgetsUserInterface <WidgetTypesDescription>
//  private let mSelection : Set <UUID>

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  init (_ inWidgetsUserInterface : WidgetsUserInterface <WidgetTypesDescription>) {
    self.mWidgetsUserInterface = inWidgetsUserInterface
  }

//  init (_ inWidgetsUserInterface : WidgetsUserInterface <WidgetTypesDescription>,
//        _ inID : Set <UUID>) {
//    self.mWidgetsUserInterface = inWidgetsUserInterface
//    self.mSelection = inID
//  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @MainActor public subscript <T : WidgetUIProtocol <WidgetTypesDescription>, Value : Equatable & Sendable> (bindingFor inKeyPath : WritableKeyPath <T, Value>) -> Binding <Value?> {
    let binding = Binding <Value?> (
      get: {
        var result : Value? = nil
        for id in self.mWidgetsUserInterface.mSelection {
          if let v = self.mWidgetsUserInterface [id: id] as? T {
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
          for id in self.mWidgetsUserInterface.mSelection {
            if var v = self.mWidgetsUserInterface [id: id] as? T {
              v [keyPath: inKeyPath] = property
              self.mWidgetsUserInterface [id: id] = v
            }
          }
        }
      }
    )
    return binding
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func optValueOf <T : WidgetUIProtocol <WidgetTypesDescription>, Value : Equatable> (_ inKeyPath : KeyPath <T, Value>) -> Value? {
    var result : Value? = nil
    for id in self.mWidgetsUserInterface.mSelection {
      if let v = self.mWidgetsUserInterface [id: id] as? T {
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

  public func setOf <T : WidgetUIProtocol <WidgetTypesDescription>, Value : Hashable> (_ inKeyPath : KeyPath <T, Value>) -> Set <Value> {
    var result = Set <Value> ()
    for id in self.mWidgetsUserInterface.mSelection {
      if let v = self.mWidgetsUserInterface [id: id] as? T {
        let property = v [keyPath: inKeyPath]
        result.insert (property)
      }
    }
    return result
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func arrayOf <T : WidgetUIProtocol <WidgetTypesDescription>, Value : Hashable> (_ inKeyPath : KeyPath <T, Value>) -> [Value] {
    return Array (self.setOf (inKeyPath))
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func setProperty <T : WidgetUIProtocol <WidgetTypesDescription>, Value> (_ inKeyPath : WritableKeyPath <T, Value>, _ inValue : Value) {
    for id in self.mWidgetsUserInterface.mSelection {
      if var v = self.mWidgetsUserInterface [id: id] as? T {
        v [keyPath: inKeyPath] = inValue
        self.mWidgetsUserInterface [id: id] = v
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func performWidgetUserInterfaceAction (_ inAction : (WidgetsUserInterface <WidgetTypesDescription>) -> Void) {
    inAction (self.mWidgetsUserInterface)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func performWidgetAction <T : WidgetUIProtocol <WidgetTypesDescription> > (_ inAction : (inout T) -> Void) {
    for id in self.mWidgetsUserInterface.mSelection {
      if var widget = self.mWidgetsUserInterface [id: id] as? T {
        inAction (&widget)
        self.mWidgetsUserInterface [id: id] = widget
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------

