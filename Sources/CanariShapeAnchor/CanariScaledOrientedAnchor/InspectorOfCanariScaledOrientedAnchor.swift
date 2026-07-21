//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 18/06/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

struct InspectorOfCanariScaledOrientedAnchor <SHAPE_TYPES_DESCRIPTION : DocumentShapesDescriptionProtocol> : View {

  typealias ANCHOR = CanariScaledOrientedAnchor

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
    ExpandableInspectorOfCanariAngleSet (
      title: "Angle",
      isExpanded: self.$mAngleInspectorIsExpanded,
      fractionDigits: 3,
      angleSet: Set (self.mShapesUserInterface.selectedShapeArray ().map { $0.mAnchor.mAngle }),
      setter: { for id in self.mShapesUserInterface.selection { self.mShapesUserInterface [shapeID: id]?.mAnchor.mAngle = $0 } }
    )
    CanariExpandableInspectorView (
      title: "Scale, Flip",
      collapsedSubtitle: self.scaleAndFlipCollapsedSubtitle,
      isExpanded: self.$mScaleInspectorIsExpanded
    ) {
      EditorOfScaleSet (
        valueSet: Set (self.mShapesUserInterface.selectedShapeArray ().map { $0.mAnchor.mScale }),
        setter: { for id in self.mShapesUserInterface.selection { self.mShapesUserInterface [shapeID: id]?.mAnchor.mScale = $0 } }
      )
      InspectorOfBoolSet (
        title: "Horizontal Flip",
        valueSet: Set (self.mShapesUserInterface.selectedShapeArray ().map { $0.mAnchor.mHorizontalFlip }),
        setter: { for id in self.mShapesUserInterface.selection { self.mShapesUserInterface [shapeID: id]?.mAnchor.mHorizontalFlip = $0 } }
      )
    }
    CanariExpandableInspectorView (title: "Enclosing Rectangle", isExpanded: self.$mBoundingRectInspectorIsExpanded) {
      ViewerOfCanariRectSet (
        rectSet: Set (self.mShapesUserInterface.selectedShapeArray ().map { $0.mAnchor.globalBoundingRect }),
        displayUnit: .cm,
        fractionDigits: 3
      )
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  var scaleAndFlipCollapsedSubtitle : String {
    var str = ""
    let scaleSet = self.mShapesUserInterface.selectedShapeArray ().map { $0.mAnchor.mScale }
    if let s = scaleSet.first, scaleSet.count == 1 {
      str = "\(s)"
    }else{
      str = MULTIPLE_VALUES_MARK
    }
    str += ", flip: "
    let flipSet = self.mShapesUserInterface.selectedShapeArray ().map { $0.mAnchor.mHorizontalFlip }
    if let s = flipSet.first, flipSet.count == 1 {
      str += s ? "yes" : "no"
    }else{
      str += MULTIPLE_VALUES_MARK
    }
    return str
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
