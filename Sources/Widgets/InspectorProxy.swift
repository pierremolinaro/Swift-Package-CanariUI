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

  public subscript <T : WidgetUIProtocol <TypeDictionary>, Value : Equatable> (_ inKeyPath : WritableKeyPath <T, Value>) -> Binding <Value?> {
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

  public subscript <T : WidgetUIProtocol <TypeDictionary>, Value : Equatable> (_ inKeyPath : KeyPath <T, Value>) -> Value? {
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

}

//--------------------------------------------------------------------------------------------------

