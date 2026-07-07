//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 21/02/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public nonisolated struct CanariBaseShape <ShapeTypesDescription : DocumentShapesDescriptionProtocol> : Sendable {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var orientedOrigin : CanariScaledOrientedOrigin {
    didSet {
      self.orientedOrigin.setLocalOutline (self.shape.localOutlinePath)
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var shape : any CanariShapeUIProtocol <ShapeTypesDescription> {
    didSet {
      self.orientedOrigin.setLocalOutline (self.shape.localOutlinePath)
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (_ inOrientedOrigin : CanariScaledOrientedOrigin,
               _ inShape : any CanariShapeUIProtocol <ShapeTypesDescription>) {
    self.orientedOrigin = inOrientedOrigin
    self.shape = inShape
    self.orientedOrigin.setLocalOutline (self.shape.localOutlinePath)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Knobs
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  var knobs : [ShapeKnob <ShapeTypesDescription>] {
    var result = self.shape.shapeKnobs
    result.append (ShapeKnob (dragAction: Self.dragCenterKnob))
    return result
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private static func dragCenterKnob (_ ioOrientedOrigin : inout CanariScaledOrientedOrigin,
                                      _ ioShape : inout any CanariShapeUIProtocol <ShapeTypesDescription>,
                                      _ inLocalTranslation : CanariPoint,
                                      _ inInitialOptionKeyOn : Bool) {
    ioOrientedOrigin.addLocalTranslation (inLocalTranslation)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
