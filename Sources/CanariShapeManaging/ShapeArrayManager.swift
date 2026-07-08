//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 27/02/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct ShapeArrayManager <SHAPE_TYPES_DESCRIPTION : DocumentShapesDescriptionProtocol> {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private var mShapeArray : [CanariShapeRoot <SHAPE_TYPES_DESCRIPTION>] // at 0: back, at count - 1: front

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init () {
    self.mShapeArray = []
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  var count : Int { self.mShapeArray.count }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public mutating func setShapes (_ inShapes : [CanariShapeRoot <SHAPE_TYPES_DESCRIPTION>]) {
    self.mShapeArray = inShapes
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var shapeArray : [CanariShapeRoot <SHAPE_TYPES_DESCRIPTION>] {
    return self.mShapeArray
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Subscripts
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public subscript (shapeIndex inIndex : Int) -> CanariShapeRoot <SHAPE_TYPES_DESCRIPTION> {
    get { self.mShapeArray [inIndex] }
    set { self.mShapeArray [inIndex] = newValue }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  subscript (shapeID inID : UUID) -> (CanariShapeRoot <SHAPE_TYPES_DESCRIPTION>)? {
    get {
      self.mShapeArray.first { $0.id == inID }
    }
    set {
      if let v = newValue, let idx = self.mShapeArray.firstIndex (where: { $0.id == inID } ) {
        self.mShapeArray [idx] = v
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Mutating functions
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  mutating func append (_ inNewObject : CanariShapeRoot <SHAPE_TYPES_DESCRIPTION>) {
    self.mShapeArray.append (inNewObject)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  mutating func removeLast () {
    self.mShapeArray.removeLast ()
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  mutating func remove (at inIndex : Int) {
    self.mShapeArray.remove (at: inIndex)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  mutating func remove (id inID : UUID) {
    if let idx = self.mShapeArray.firstIndex (where: { $0.id == inID } ) {
      self.mShapeArray.remove (at: idx)
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  mutating func replaceShape (withID inID : UUID, by inArray : [CanariShapeRoot <SHAPE_TYPES_DESCRIPTION>]) {
    var idx = self.mShapeArray.firstIndex { $0.id == inID }!
    self.mShapeArray.remove (at: idx)
    for shape in inArray {
      self.mShapeArray.insert (shape, at: idx)
      idx += 1
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
