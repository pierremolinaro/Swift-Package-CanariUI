//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 18/06/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

struct InspectorOfCanariXYAnchor <SHAPE_TYPES_DESCRIPTION : DocumentShapesDescriptionProtocol> : View {

  typealias ANCHOR = CanariXYAnchor

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @State private var mShapesUserInterface : ShapesUserInterface <ANCHOR, SHAPE_TYPES_DESCRIPTION>
  @AppStorage("angle.inspector.expanded") private var mAngleInspectorIsExpanded = true
  @AppStorage("scale.inspector.expanded") private var mScaleInspectorIsExpanded = true
  @AppStorage("bounding.rect.inspector.expanded") private var mBoundingRectInspectorIsExpanded = true
  @AppStorage("center.inspector.expanded") private var mCenterInspectorIsExpanded = true

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (shapesUserInterface inShapesUserInterface : ShapesUserInterface <ANCHOR, SHAPE_TYPES_DESCRIPTION>) {
    self.mShapesUserInterface = inShapesUserInterface
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @ViewBuilder public var body : some View {
    ExpandableInspectorOfCanariPointSet (
      title : "Center",
      isExpanded: self.$mCenterInspectorIsExpanded,
      displayUnit: .cm,
      fractionDigits: 3,
      pointSet: Set (self.mShapesUserInterface.selectedShapeArray ().map { $0.mAnchor.mPoint }),
      setterX: { for id in self.mShapesUserInterface.selection { self.mShapesUserInterface [shapeID: id]?.mAnchor.mPoint.x = $0 } },
      setterY: { for id in self.mShapesUserInterface.selection { self.mShapesUserInterface [shapeID: id]?.mAnchor.mPoint.y = $0 } }
    )
    CanariExpandableInspectorView (title: "Enclosing Rectangle", isExpanded: self.$mBoundingRectInspectorIsExpanded) {
      ViewerOfCanariRectSet (
        rectSet: Set (self.mShapesUserInterface.selectedShapeArray ().map { $0.mAnchor.globalBoundingRect }),
        displayUnit: .cm,
        fractionDigits: 3
      )
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
