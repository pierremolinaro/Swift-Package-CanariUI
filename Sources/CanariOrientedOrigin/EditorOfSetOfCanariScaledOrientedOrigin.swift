//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 16/06/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

//fileprivate struct EditorOfSetOfCanariScaledOrientedOrigin : View {
//
//  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//
//  private var mSetOfOrigins : Set <CanariScaledOrientedOrigin>
//
//  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//
//  init (proxy inProxy : InspectorProxy <WidgetTypesDescription>) {
//    self.mProxy = inProxy
//  }
//
//  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//
//  var body : some View {
//    InspectorOfCanariPointSet (
//      title: "Center",
//      pointSet: self.mProxy.setOf (\T.orientedOrigin.mOrigin),
//      setterX: { newX in
//        self.mProxy.performWidgetAction { (widget : inout T) in
//          widget.orientedOrigin.mOrigin.x = newX
//        }
//      },
//      setterY: { newY in
//        self.mProxy.performWidgetAction { (widget : inout T) in
//          widget.orientedOrigin.mOrigin.y = newY
//        }
//      }
//    )
//    CanariElementInspector (title: "Angle", subTitle: "") {
//      EditorOfCanariAngleSet (
//        angleSet: self.mProxy.setOf (\T.orientedOrigin.mAngle),
//        setter: { newAngle in
//          self.mProxy.performWidgetAction { (widget : inout T) in
//            widget.orientedOrigin.mAngle = newAngle
//          }
//        }
//      )
//    }
//    CanariElementInspector (title: "Scale", subTitle: "") {
//      EditorOfScaleSet (
//        valueSet: self.mProxy.setOf (\T.orientedOrigin.mScale),
//        setter: { newScale in
//          self.mProxy.performWidgetAction { (widget : inout T) in
//            widget.orientedOrigin.mScale = newScale
//          }
//        }
//      )
//    }
//  }
//
//  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//
//}

//--------------------------------------------------------------------------------------------------
