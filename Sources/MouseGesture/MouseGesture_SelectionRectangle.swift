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
    for widget in inWidgetsManagerInterface.widgetArray {
      if widget.decorator.orientedOrigin.globalOutlineIntersects (globalRect: selectionRectangle) {
        if !shift {
          newSelection.insert (widget.decorator.id)
        }else if newSelection.contains (widget.decorator.id) {
          newSelection.remove (widget.decorator.id)
        }else{
          newSelection.insert (widget.decorator.id)
        }
      }else if !shift {
        newSelection.remove (widget.decorator.id)
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

