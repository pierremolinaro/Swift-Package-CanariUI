//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 18/06/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------


struct InspectorOfCanariScaledOrientedOrigin <WidgetTypesDescription : DocumentWidgetsDescriptionProtocol> : View {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @State private var mWidgetsUserInterface : WidgetsUserInterface <WidgetTypesDescription>
  @AppStorage("angle.inspector.expanded") private var mAngleInspectorIsExpanded = true
  @AppStorage("scale.inspector.expanded") private var mScaleInspectorIsExpanded = true
  @AppStorage("bounding.rect.inspector.expanded") private var mBoundingRectInspectorIsExpanded = true
  @AppStorage("center.inspector.expanded") private var mCenterInspectorIsExpanded = true

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  init (widgetsUserInterface inWidgetsUserInterface : WidgetsUserInterface <WidgetTypesDescription>) {
    self.mWidgetsUserInterface = inWidgetsUserInterface
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @ViewBuilder var body : some View {
    ExpandableInspectorOfCanariPointSet (
      title : "Center",
      pointSet: Set (self.mWidgetsUserInterface.selectedWidgetArray ().map { $0.widget.orientedOrigin.mOrigin }),
      setterX: { for id in self.mWidgetsUserInterface.selection { self.mWidgetsUserInterface [proxyID: id]?.widget.orientedOrigin.mOrigin.x = $0 } },
      setterY: { for id in self.mWidgetsUserInterface.selection { self.mWidgetsUserInterface [proxyID: id]?.widget.orientedOrigin.mOrigin.y = $0 } },
      isExpanded: self.$mCenterInspectorIsExpanded
    )
    CanariElementExpandableInspector (title: "Angle", subTitle: "", isExpanded: self.$mAngleInspectorIsExpanded) {
      EditorOfCanariAngleSet (
        angleSet: Set (self.mWidgetsUserInterface.selectedWidgetArray ().map { $0.widget.orientedOrigin.mAngle }),
        setter: { for id in self.mWidgetsUserInterface.selection { self.mWidgetsUserInterface [proxyID: id]?.widget.orientedOrigin.mAngle = $0 } }
      )
    }
    CanariElementExpandableInspector (title: "Scale, Flip", subTitle: "", isExpanded: self.$mScaleInspectorIsExpanded) {
      EditorOfScaleSet (
        valueSet: Set (self.mWidgetsUserInterface.selectedWidgetArray ().map { $0.widget.orientedOrigin.mScale }),
        setter: { for id in self.mWidgetsUserInterface.selection { self.mWidgetsUserInterface [proxyID: id]?.widget.orientedOrigin.mScale = $0 } }
      )
      InspectorOfBoolSet (
        title: "Horizontal Flip",
        valueSet: Set (self.mWidgetsUserInterface.selectedWidgetArray ().map { $0.widget.orientedOrigin.mHorizontalFlip }),
        setter: { for id in self.mWidgetsUserInterface.selection { self.mWidgetsUserInterface [proxyID: id]?.widget.orientedOrigin.mHorizontalFlip = $0 } }
      )
    }
    CanariElementExpandableInspector (title: "Enclosing Rectangle", subTitle: "", isExpanded: self.$mBoundingRectInspectorIsExpanded) {
      ViewerOfCanariRectSet (rectSet: Set (self.mWidgetsUserInterface.selectedWidgetArray ().map { $0.widget.orientedOrigin.globalBoundingRect }))
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
