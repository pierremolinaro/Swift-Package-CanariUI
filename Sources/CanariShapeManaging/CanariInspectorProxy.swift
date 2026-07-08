//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 04/06/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public final class CanariInspectorProxy <SHAPE_TYPES_DESCRIPTION : DocumentShapesDescriptionProtocol> {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private let mShapesUserInterface : ShapesUserInterface <SHAPE_TYPES_DESCRIPTION>

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  init (_ inShapesUserInterface : ShapesUserInterface <SHAPE_TYPES_DESCRIPTION>) {
    self.mShapesUserInterface = inShapesUserInterface
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @MainActor public subscript <T : CanariShapeDecorationProtocol <SHAPE_TYPES_DESCRIPTION>, Value : Equatable> (bindingFor inKeyPath : WritableKeyPath <T, Value>) -> Binding <Value?> {
    let binding = Binding <Value?> (
      get: {
        var result : Value? = nil
        for id in self.mShapesUserInterface.selection {
          if let shape = self.mShapesUserInterface [shapeID: id]?.mDecoration as? T {
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
                    var v = shape.mDecoration as? T {
              v [keyPath: inKeyPath] = property
              self.mShapesUserInterface [shapeID: id] = CanariShapeRoot (shape.mAnchor, v)
            }
          }
        }
      }
    )
    return binding
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func optValueOf <T : CanariShapeDecorationProtocol <SHAPE_TYPES_DESCRIPTION>, Value : Equatable> (_ inKeyPath : KeyPath <T, Value>) -> Value? {
    var result : Value? = nil
    for id in self.mShapesUserInterface.selection {
      if let v = self.mShapesUserInterface [shapeID: id]?.mDecoration as? T {
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

  public func setOf <T : CanariShapeDecorationProtocol <SHAPE_TYPES_DESCRIPTION>, Value : Hashable> (_ inKeyPath : KeyPath <T, Value>) -> Set <Value> {
    var result = Set <Value> ()
    for id in self.mShapesUserInterface.selection {
      if let v = self.mShapesUserInterface [shapeID: id]?.mDecoration as? T {
        let property = v [keyPath: inKeyPath]
        result.insert (property)
      }
    }
    return result
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func arrayOf <T : CanariShapeDecorationProtocol <SHAPE_TYPES_DESCRIPTION>, Value : Hashable> (_ inKeyPath : KeyPath <T, Value>) -> [Value] {
    return Array (self.setOf (inKeyPath))
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func setProperty <T : CanariShapeDecorationProtocol <SHAPE_TYPES_DESCRIPTION>, Value> (_ inKeyPath : WritableKeyPath <T, Value>, _ inValue : Value) {
    for id in self.mShapesUserInterface.selection {
      if let shape = self.mShapesUserInterface [shapeID: id], var v = shape.mDecoration as? T {
        v [keyPath: inKeyPath] = inValue
        self.mShapesUserInterface [shapeID: id] = CanariShapeRoot (shape.mAnchor, v)
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func performUserInterfaceAction (_ inAction : (ShapesUserInterface <SHAPE_TYPES_DESCRIPTION>) -> Void) {
    inAction (self.mShapesUserInterface)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func performAction <T : CanariShapeDecorationProtocol <SHAPE_TYPES_DESCRIPTION> > (_ inAction : (inout T) -> Void) {
    for id in self.mShapesUserInterface.selection {
      if let shape = self.mShapesUserInterface [shapeID: id], var s = shape.mDecoration as? T {
        inAction (&s)
        self.mShapesUserInterface [shapeID: id] = CanariShapeRoot (shape.mAnchor, s)
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
