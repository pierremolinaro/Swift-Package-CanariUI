//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 18/06/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

struct InspectorOfCanariScaledOrientedOrigin <ShapeTypesDescription : DocumentShapesDescriptionProtocol> : View {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @State private var mShapesUserInterface : ShapesUserInterface <ShapeTypesDescription>
  @AppStorage("angle.inspector.expanded") private var mAngleInspectorIsExpanded = true
  @AppStorage("scale.inspector.expanded") private var mScaleInspectorIsExpanded = true
  @AppStorage("bounding.rect.inspector.expanded") private var mBoundingRectInspectorIsExpanded = true
  @AppStorage("center.inspector.expanded") private var mCenterInspectorIsExpanded = true

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  init (shapesUserInterface inShapesUserInterface : ShapesUserInterface <ShapeTypesDescription>) {
    self.mShapesUserInterface = inShapesUserInterface
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @ViewBuilder var body : some View {
    ExpandableInspectorOfCanariPointSet (
      title : "Center",
      pointSet: Set (self.mShapesUserInterface.selectedShapeArray ().map { $0.orientedOrigin.mOrigin }),
      setterX: { for id in self.mShapesUserInterface.selection { self.mShapesUserInterface [shapeID: id]?.orientedOrigin.mOrigin.x = $0 } },
      setterY: { for id in self.mShapesUserInterface.selection { self.mShapesUserInterface [shapeID: id]?.orientedOrigin.mOrigin.y = $0 } },
      isExpanded: self.$mCenterInspectorIsExpanded
    )
    CanariExpandableInspectorView (title: "Angle", isExpanded: self.$mAngleInspectorIsExpanded) {
      EditorOfCanariAngleSet (
        angleSet: Set (self.mShapesUserInterface.selectedShapeArray ().map { $0.orientedOrigin.mAngle }),
        setter: { for id in self.mShapesUserInterface.selection { self.mShapesUserInterface [shapeID: id]?.orientedOrigin.mAngle = $0 } }
      )
    }
    CanariExpandableInspectorView (title: "Scale, Flip", isExpanded: self.$mScaleInspectorIsExpanded) {
      EditorOfScaleSet (
        valueSet: Set (self.mShapesUserInterface.selectedShapeArray ().map { $0.orientedOrigin.mScale }),
        setter: { for id in self.mShapesUserInterface.selection { self.mShapesUserInterface [shapeID: id]?.orientedOrigin.mScale = $0 } }
      )
      InspectorOfBoolSet (
        title: "Horizontal Flip",
        valueSet: Set (self.mShapesUserInterface.selectedShapeArray ().map { $0.orientedOrigin.mHorizontalFlip }),
        setter: { for id in self.mShapesUserInterface.selection { self.mShapesUserInterface [shapeID: id]?.orientedOrigin.mHorizontalFlip = $0 } }
      )
    }
    CanariExpandableInspectorView (title: "Enclosing Rectangle", isExpanded: self.$mBoundingRectInspectorIsExpanded) {
      ViewerOfCanariRectSet (
        rectSet: Set (self.mShapesUserInterface.selectedShapeArray ().map { $0.orientedOrigin.globalBoundingRect }),
        unit: .mm,
        fractionDigits: 2
      )
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
