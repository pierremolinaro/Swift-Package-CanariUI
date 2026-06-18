//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 15/09/2025.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

struct MouseGesture_SelectionRectangle <WidgetTypesDescription : DocumentWidgetsDescriptionProtocol> : MouseGestureProtocol {

  let startSelectionSet : Set <UUID>

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func onMouseDragged (geometry inGeometry : MouseGestureGeometryContext,
                       beginOrContinueUndoGrouping inBeginOrContinueUndoGrouping : () -> Void,
                       userSelectionRectangle ioUserSelectionRectangle : inout CanariRect?,
                       widgetsManagerInterface inWidgetsManagerInterface : WidgetsUserInterface <WidgetTypesDescription>,
                       optionalNextState outOptionalNextState : inout (any MouseGestureProtocol <WidgetTypesDescription>)?) {
  //--- Update selection rectangle
    let selectionRectangle = CanariRect ([inGeometry.unalignedUserStartLocation, inGeometry.unalignedUserCurrentLocation])
    ioUserSelectionRectangle = selectionRectangle
  //--- Compute selection
    var newSelection = self.startSelectionSet
    let shift = NSEvent.modifierFlags.contains (.shift)
    for proxy in inWidgetsManagerInterface.proxyArray {
      if proxy.widget.orientedOrigin.globalOutlineIntersects (globalRect: selectionRectangle) {
        if !shift {
          newSelection.insert (proxy.widget.id)
        }else if newSelection.contains (proxy.widget.id) {
          newSelection.remove (proxy.widget.id)
        }else{
          newSelection.insert (proxy.widget.id)
        }
      }else if !shift {
        newSelection.remove (proxy.widget.id)
      }
    }
    inWidgetsManagerInterface.setSelection (withIDs: newSelection)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func onMouseUp (removeUndoGrouping inRemoveUndoGrouping : () -> Void,
                  userSelectionRectangle ioUserSelectionRectangle : inout CanariRect?,
                  widgetsManagerInterface inWidgetsManagerInterface : WidgetsUserInterface <WidgetTypesDescription>) {
    ioUserSelectionRectangle = nil
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------

