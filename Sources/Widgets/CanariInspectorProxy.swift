//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 04/06/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public final class CanariInspectorProxy <WidgetTypesDescription : DocumentWidgetsDescriptionProtocol> {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private let mWidgetsUserInterface : WidgetsUserInterface <WidgetTypesDescription>

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  init (_ inWidgetsUserInterface : WidgetsUserInterface <WidgetTypesDescription>) {
    self.mWidgetsUserInterface = inWidgetsUserInterface
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @MainActor public subscript <T : CanariShapeUIProtocol <WidgetTypesDescription>, Value : Equatable> (bindingFor inKeyPath : WritableKeyPath <T, Value>) -> Binding <Value?> {
    let binding = Binding <Value?> (
      get: {
        var result : Value? = nil
        for id in self.mWidgetsUserInterface.selection {
          if let shape = self.mWidgetsUserInterface [shapeID: id]?.shape as? T {
            let property = shape [keyPath: inKeyPath]
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
          for id in self.mWidgetsUserInterface.selection {
            if var v = self.mWidgetsUserInterface [shapeID: id]?.shape as? T {
              v [keyPath: inKeyPath] = property
              self.mWidgetsUserInterface [shapeID: id] = CanariWidget (v)
            }
          }
        }
      }
    )
    return binding
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func optValueOf <T : CanariShapeUIProtocol <WidgetTypesDescription>, Value : Equatable> (_ inKeyPath : KeyPath <T, Value>) -> Value? {
    var result : Value? = nil
    for id in self.mWidgetsUserInterface.selection {
      if let v = self.mWidgetsUserInterface [shapeID: id]?.shape as? T {
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

  public func setOf <T : CanariShapeUIProtocol <WidgetTypesDescription>, Value : Hashable> (_ inKeyPath : KeyPath <T, Value>) -> Set <Value> {
    var result = Set <Value> ()
    for id in self.mWidgetsUserInterface.selection {
      if let v = self.mWidgetsUserInterface [shapeID: id]?.shape as? T {
        let property = v [keyPath: inKeyPath]
        result.insert (property)
      }
    }
    return result
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func arrayOf <T : CanariShapeUIProtocol <WidgetTypesDescription>, Value : Hashable> (_ inKeyPath : KeyPath <T, Value>) -> [Value] {
    return Array (self.setOf (inKeyPath))
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func setProperty <T : CanariShapeUIProtocol <WidgetTypesDescription>, Value> (_ inKeyPath : WritableKeyPath <T, Value>, _ inValue : Value) {
    for id in self.mWidgetsUserInterface.selection {
      if var v = self.mWidgetsUserInterface [shapeID: id]?.shape as? T {
        v [keyPath: inKeyPath] = inValue
        self.mWidgetsUserInterface [shapeID: id] = CanariWidget (v)
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func performWidgetUserInterfaceAction (_ inAction : (WidgetsUserInterface <WidgetTypesDescription>) -> Void) {
    inAction (self.mWidgetsUserInterface)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func performWidgetAction <T : CanariShapeUIProtocol <WidgetTypesDescription> > (_ inAction : (inout T) -> Void) {
    for id in self.mWidgetsUserInterface.selection {
      if var shape = self.mWidgetsUserInterface [shapeID: id]?.shape as? T {
        inAction (&shape)
        self.mWidgetsUserInterface [shapeID: id] = CanariWidget (shape)
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
