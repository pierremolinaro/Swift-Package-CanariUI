//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 15/09/2025.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

struct MouseGesture_SelectionRectangle <TypeDictionary : WidgetTypeArrayProtocol> : MouseGestureProtocol {

  let startSelectionSet : Set <UUID>

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func onMouseDragged (geometry inGeometry : MouseGestureGeometryContext,
                       beginOrContinueUndoGrouping inBeginOrContinueUndoGrouping : () -> Void,
                       selection ioSelection : inout Set <UUID>,
                       userSelectionRectangle ioUserSelectionRectangle : inout CanariRect?,
                       widgetsManager ioWidgetsManager : inout WidgetsManager <TypeDictionary>,
                       optionalNextState outOptionalNextState : inout (any MouseGestureProtocol <TypeDictionary>)?) {
  //--- Update selection rectangle
    let selectionRectangle = CanariRect ([inGeometry.unalignedUserStartLocation, inGeometry.unalignedUserCurrentLocation])
    ioUserSelectionRectangle = selectionRectangle
  //--- Compute selection
    ioSelection = self.startSelectionSet
    let shift = NSEvent.modifierFlags.contains (.shift)
    for widget in ioWidgetsManager.widgets {
      if widget.orientedOrigin.globalBoundingRect.intersects (selectionRectangle), widget.orientedOrigin.globalOutline.intersects (selectionRectangle) {
        if !shift {
          ioSelection.insert (widget.id)
        }else if ioSelection.contains (widget.id) {
          ioSelection.remove (widget.id)
        }else{
          ioSelection.insert (widget.id)
        }
      }else if !shift {
        ioSelection.remove (widget.id)
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func onMouseUp (removeUndoGrouping inRemoveUndoGrouping : () -> Void,
                  selection ioSelection : inout Set <UUID>,
                  userSelectionRectangle ioUserSelectionRectangle : inout CanariRect?,
                  widgetsManager ioWidgetsManager : inout WidgetsManager <TypeDictionary>) {
    ioUserSelectionRectangle = nil
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------

