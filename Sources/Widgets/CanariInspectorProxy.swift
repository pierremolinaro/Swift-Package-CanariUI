//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 04/06/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public final class CanariInspectorProxy <ShapeTypesDescription : DocumentShapesDescriptionProtocol> {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private let mShapesUserInterface : ShapesUserInterface <ShapeTypesDescription>

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  init (_ inShapesUserInterface : ShapesUserInterface <ShapeTypesDescription>) {
    self.mShapesUserInterface = inShapesUserInterface
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @MainActor public subscript <T : CanariShapeUIProtocol <ShapeTypesDescription>, Value : Equatable> (bindingFor inKeyPath : WritableKeyPath <T, Value>) -> Binding <Value?> {
    let binding = Binding <Value?> (
      get: {
        var result : Value? = nil
        for id in self.mShapesUserInterface.selection {
          if let shape = self.mShapesUserInterface [shapeID: id]?.shape as? T {
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
          for id in self.mShapesUserInterface.selection {
            if let shape = self.mShapesUserInterface [shapeID: id],
                    var v = shape.shape as? T {
              v [keyPath: inKeyPath] = property
              self.mShapesUserInterface [shapeID: id] = CanariBaseShape (shape.orientedOrigin, v)
            }
          }
        }
      }
    )
    return binding
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func optValueOf <T : CanariShapeUIProtocol <ShapeTypesDescription>, Value : Equatable> (_ inKeyPath : KeyPath <T, Value>) -> Value? {
    var result : Value? = nil
    for id in self.mShapesUserInterface.selection {
      if let v = self.mShapesUserInterface [shapeID: id]?.shape as? T {
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

  public func setOf <T : CanariShapeUIProtocol <ShapeTypesDescription>, Value : Hashable> (_ inKeyPath : KeyPath <T, Value>) -> Set <Value> {
    var result = Set <Value> ()
    for id in self.mShapesUserInterface.selection {
      if let v = self.mShapesUserInterface [shapeID: id]?.shape as? T {
        let property = v [keyPath: inKeyPath]
        result.insert (property)
      }
    }
    return result
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func arrayOf <T : CanariShapeUIProtocol <ShapeTypesDescription>, Value : Hashable> (_ inKeyPath : KeyPath <T, Value>) -> [Value] {
    return Array (self.setOf (inKeyPath))
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func setProperty <T : CanariShapeUIProtocol <ShapeTypesDescription>, Value> (_ inKeyPath : WritableKeyPath <T, Value>, _ inValue : Value) {
    for id in self.mShapesUserInterface.selection {
      if let shape = self.mShapesUserInterface [shapeID: id], var v = shape.shape as? T {
        v [keyPath: inKeyPath] = inValue
        self.mShapesUserInterface [shapeID: id] = CanariBaseShape (shape.orientedOrigin, v)
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func performUserInterfaceAction (_ inAction : (ShapesUserInterface <ShapeTypesDescription>) -> Void) {
    inAction (self.mShapesUserInterface)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func performAction <T : CanariShapeUIProtocol <ShapeTypesDescription> > (_ inAction : (inout T) -> Void) {
    for id in self.mShapesUserInterface.selection {
      if let shape = self.mShapesUserInterface [shapeID: id], var s = shape.shape as? T {
        inAction (&s)
        self.mShapesUserInterface [shapeID: id] = CanariBaseShape (shape.orientedOrigin, s)
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
