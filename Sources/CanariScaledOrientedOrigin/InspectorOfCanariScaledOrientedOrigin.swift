//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 18/06/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

struct InspectorOfCanariScaledOrientedOrigin <SHAPE_TYPES_DESCRIPTION : DocumentShapesDescriptionProtocol> : View {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @State private var mShapesUserInterface : ShapesUserInterface <SHAPE_TYPES_DESCRIPTION>
  @AppStorage("angle.inspector.expanded") private var mAngleInspectorIsExpanded = true
  @AppStorage("scale.inspector.expanded") private var mScaleInspectorIsExpanded = true
  @AppStorage("bounding.rect.inspector.expanded") private var mBoundingRectInspectorIsExpanded = true
  @AppStorage("center.inspector.expanded") private var mCenterInspectorIsExpanded = true

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  init (shapesUserInterface inShapesUserInterface : ShapesUserInterface <SHAPE_TYPES_DESCRIPTION>) {
    self.mShapesUserInterface = inShapesUserInterface
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @ViewBuilder var body : some View {
    ExpandableInspectorOfCanariPointSet (
      title : "Center",
      pointSet: Set (self.mShapesUserInterface.selectedShapeArray ().map { $0.mOrigin.mPoint }),
      setterX: { for id in self.mShapesUserInterface.selection { self.mShapesUserInterface [shapeID: id]?.mOrigin.mPoint.x = $0 } },
      setterY: { for id in self.mShapesUserInterface.selection { self.mShapesUserInterface [shapeID: id]?.mOrigin.mPoint.y = $0 } },
      isExpanded: self.$mCenterInspectorIsExpanded
    )
    CanariExpandableInspectorView (title: "Angle", isExpanded: self.$mAngleInspectorIsExpanded) {
      EditorOfCanariAngleSet (
        angleSet: Set (self.mShapesUserInterface.selectedShapeArray ().map { $0.mOrigin.mAngle }),
        setter: { for id in self.mShapesUserInterface.selection { self.mShapesUserInterface [shapeID: id]?.mOrigin.mAngle = $0 } }
      )
    }
    CanariExpandableInspectorView (title: "Scale, Flip", isExpanded: self.$mScaleInspectorIsExpanded) {
      EditorOfScaleSet (
        valueSet: Set (self.mShapesUserInterface.selectedShapeArray ().map { $0.mOrigin.mScale }),
        setter: { for id in self.mShapesUserInterface.selection { self.mShapesUserInterface [shapeID: id]?.mOrigin.mScale = $0 } }
      )
      InspectorOfBoolSet (
        title: "Horizontal Flip",
        valueSet: Set (self.mShapesUserInterface.selectedShapeArray ().map { $0.mOrigin.mHorizontalFlip }),
        setter: { for id in self.mShapesUserInterface.selection { self.mShapesUserInterface [shapeID: id]?.mOrigin.mHorizontalFlip = $0 } }
      )
    }
    CanariExpandableInspectorView (title: "Enclosing Rectangle", isExpanded: self.$mBoundingRectInspectorIsExpanded) {
      ViewerOfCanariRectSet (
        rectSet: Set (self.mShapesUserInterface.selectedShapeArray ().map { $0.mOrigin.globalBoundingRect }),
        unit: .mm,
        fractionDigits: 2
      )
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
