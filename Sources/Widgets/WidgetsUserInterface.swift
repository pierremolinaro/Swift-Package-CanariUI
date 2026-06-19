//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 21/02/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI
import Combine

//--------------------------------------------------------------------------------------------------

@Observable open class WidgetsUserInterface <WidgetTypesDescription : DocumentWidgetsDescriptionProtocol> : MenuCommands {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private let mPasteboardType : NSPasteboard.PasteboardType

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (withPasteboardType inPasteboardType : NSPasteboard.PasteboardType) {
    self.mPasteboardType = inPasteboardType
    super.init ()
    self.mCancellableTimerForUpdateInternalPasteState = Timer.publish (every: 0.5, on: .main, in: .common)
    .autoconnect ()
    .sink { _ in
      self.mInternalPasteIsEnabled = NSPasteboard.general.string (forType: self.mPasteboardType) != nil
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: CanariWidget array
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private var mWidgetsManager = WidgetsManager <WidgetTypesDescription> ()
  public var widgetCount : Int { self.mWidgetsManager.count }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public subscript (widgetIndex inIndex : Int) -> CanariWidget <WidgetTypesDescription> {
    get { self.mWidgetsManager [widgetIndex: inIndex] }
    set { self.mWidgetsManager [widgetIndex: inIndex] = newValue }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  subscript (shapeID inID : UUID) -> (CanariWidget <WidgetTypesDescription>)? {
    get { self.mWidgetsManager [shapeID: inID] }
    set { self.mWidgetsManager [shapeID: inID] = newValue }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func removeLast () {
    self.mWidgetsManager.removeLast ()
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var widgetArray : [CanariWidget <WidgetTypesDescription>] { self.mWidgetsManager.widgetArray }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func contentsIsExactly (_ inWidgets : [CanariWidget <WidgetTypesDescription>]) -> Bool {
    if self.widgetCount != inWidgets.count {
      return false
    }else{
      for i in 0 ..< self.widgetCount {
        if !self.widgetArray [i].shape.isEqual (to: inWidgets [i].shape) {
          return false
        }
      }
      return true
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func setWidgets (_ inWidgets : [CanariWidget <WidgetTypesDescription>]) {
    self.mWidgetsManager.setWidgets (inWidgets)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func append (_ inNewObject : CanariWidget <WidgetTypesDescription>) {
    self.mWidgetsManager.append (inNewObject)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Selection
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private var mSelection = Set <UUID> ()
  public var selection : Set <UUID> { self.mSelection }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func clearSelection () {
    if !self.mSelection.isEmpty {
      self.mSelection.removeAll ()
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func setSelection (withID inID : UUID) {
    if self.mSelection.count != 1, self.mSelection.first != inID {
      self.mSelection.removeAll ()
      self.mSelection.insert (inID)
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func setSelection (withIDs inIDs : Set <UUID>) {
    if self.mSelection != inIDs {
      self.mSelection = inIDs
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func selectedWidgetArray () -> [CanariWidget <WidgetTypesDescription>] {
    var result = [CanariWidget <WidgetTypesDescription>] ()
    for widget in self.widgetArray {
      if self.selection.contains (widget.shape.id) {
        result.append (widget)
      }
    }
    return result
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private var mHoveredObject : UUID? = nil
  private var mSelectionUserRectangle : CanariRect? = nil
  public var selectionUserRectangle : CanariRect? { self.mSelectionUserRectangle }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private var mStartSelectionSet = Set <UUID> ()
  private var mDragGestureState : (any MouseGestureProtocol<WidgetTypesDescription>)? = nil

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: append and set selection to added object
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func appendAndSetSelection (_ inNewObject : CanariWidget <WidgetTypesDescription>) {
    self.mWidgetsManager.append (inNewObject)
    self.mSelection.removeAll ()
    self.mSelection.insert (inNewObject.shape.id)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Object Creator
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func setObjectCreator (_ inNewCreator : @escaping (MouseGestureGeometryContext) -> CanariWidget <WidgetTypesDescription>) {
    self.mObjectCreator = inNewCreator
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private var mObjectCreator : ((MouseGestureGeometryContext) -> CanariWidget <WidgetTypesDescription>)? = nil

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Draw
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func draw (context ioContext : inout GraphicsContext,
                    hoverUserLocationPoint inHoverUserLocationPoint : CanariPoint?,
                    scale inScale : Double) {
    enterTracing ("widgets.user.interface.draw") ; defer { exitTracing ("widgets.user.interface.draw") }
    ioContext.scale (by: inScale)
  //--- Draw widgets
    for widget in self.widgetArray {
      ioContext.translate (by: widget.shape.orientedOrigin.mOrigin)
      ioContext.rotate (by: widget.shape.orientedOrigin.mAngle)
      ioContext.scale (by: widget.shape.orientedOrigin.mScale, horizontalFlip: widget.shape.orientedOrigin.mHorizontalFlip)
      let scale = inScale * widget.shape.orientedOrigin.mScale
      let hovered = widget.shape.id == self.mHoveredObject
      let selected = self.mSelection.contains (widget.shape.id)
      widget.shape.orientedOrigin.withLocalOutline {
        self.drawWidgetBackground (
          context: &ioContext,
          scale: scale,
          hovered: hovered,
          selected : selected,
          localOutline: $0
        )
      }
      widget.shape.drawWidget (
        context: &ioContext,
        scale: scale,
        hovered: hovered,
        selected: selected,
        groupLevel: 0
      )
      widget.shape.orientedOrigin.withLocalOutline {
        self.drawWidgetForeground (
          context: &ioContext,
          scale: scale,
          hovered: hovered,
          selected : selected,
          localOutline: $0
        )
      }
      ioContext.scale (by: 1.0 / widget.shape.orientedOrigin.mScale, horizontalFlip: widget.shape.orientedOrigin.mHorizontalFlip)
      ioContext.rotate (by: -widget.shape.orientedOrigin.mAngle)
      ioContext.translate (by: -widget.shape.orientedOrigin.mOrigin)
    }
  //--- Get alignment points
    var selectedObjetsAlignmentPoints = Set <CanariPoint> ()
    for widget in self.widgetArray {
      if self.mSelection.contains (widget.shape.id) {
        selectedObjetsAlignmentPoints.formUnion (widget.shape.orientedOrigin.localToGlobal (widget.shape.localAlignmentGuidePoints))
      }
    }
  //--- Draw alignment guides
    for p in selectedObjetsAlignmentPoints {
      for widget in self.widgetArray {
        if !self.mSelection.contains (widget.shape.id) {
          for q in widget.shape.orientedOrigin.localToGlobal (widget.shape.localAlignmentGuidePoints) {
            if p.x == q.x, p.y != q.y { // Vertical guide
              var path = CanariPath ()
              path.move (to: p)
              path.addLine (to: q)
              ioContext.stroke (path, with: .color (.orange), lineWidth: .px (1) / inScale)
            }else if p.y == q.y, p.x != q.x { // Horizontal guide
              var path = CanariPath ()
              path.move (to: p)
              path.addLine (to: q)
              ioContext.stroke (path, with: .color (.orange), lineWidth: .px (1) / inScale)
            }
          }
        }
      }
    }
  //--- Draw knobs
    for widget in self.widgetArray {
      if self.mSelection.contains (widget.shape.id), !widget.knobs.isEmpty {
        ioContext.translate (by: widget.shape.orientedOrigin.mOrigin)
        ioContext.rotate (by: widget.shape.orientedOrigin.mAngle)
        ioContext.scale (by: widget.shape.orientedOrigin.mScale)
        for knob in widget.knobs {
          let inside : Bool
          if let p = inHoverUserLocationPoint {
            inside = knob.contains (
              localPoint: widget.shape.orientedOrigin.globalToLocal (p),
              scale: inScale
            )
          }else{
            inside = false
          }
          knob.drawKnob (context: &ioContext, inside: inside, scale: inScale * widget.shape.orientedOrigin.mScale)
        }
        ioContext.scale (by: 1.0 / widget.shape.orientedOrigin.mScale)
        ioContext.rotate (by: -widget.shape.orientedOrigin.mAngle)
        ioContext.translate (by: -widget.shape.orientedOrigin.mOrigin)
      }
    }
    ioContext.scale (by: 1.0 / inScale)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  open func drawWidgetBackground (context ioContext : inout GraphicsContext,
                                  scale inScale : Double,
                                  hovered inHovered : Bool,
                                  selected inSelected : Bool,
                                  localOutline inLocalOutline : CanariPath) {
   }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  open func drawWidgetForeground (context ioContext : inout GraphicsContext,
                                  scale inScale : Double,
                                  hovered inHovered : Bool,
                                  selected inSelected : Bool,
                                  localOutline inLocalOutline : CanariPath) {
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Hover tracking
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func hoverTracking (at inPoint : CanariPoint) {
    enterTracing ("widgets.user.interface.hover.tracking") ; defer { exitTracing ("widgets.user.interface.hover.tracking") }
    for widget in self.widgetArray.reversed () {
      if widget.shape.orientedOrigin.localOutline (containsLocalPoint: widget.shape.orientedOrigin.globalToLocal (inPoint)) {
        self.mHoveredObject = widget.shape.id
        return
      }
    }
    self.mHoveredObject = nil
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func hoverTrackingEnded () {
    self.mHoveredObject = nil
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Mouse down, mouse dragged, mouse up
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @MainActor public func mouseDownOrMouseDragged (geometry inGeometry : MouseGestureGeometryContext) {
    if let dragGestureState = self.mDragGestureState { // Mouse dragged event
      enterTracing ("widgets.user.interface.mouse.dragging") ; defer { exitTracing ("widgets.user.interface.mouse.dragging") }
      var optionalNextState : (any MouseGestureProtocol <WidgetTypesDescription>)? = nil
      dragGestureState.onMouseDragged (
        geometry: inGeometry,
        beginOrContinueUndoGrouping: { self.beginOrContinueUndoGrouping () },
        userSelectionRectangle: &self.mSelectionUserRectangle,
        widgetsManagerInterface: self,
        optionalNextState: &optionalNextState
      )
      if let nextState : any MouseGestureProtocol<WidgetTypesDescription> = optionalNextState {
        self.mDragGestureState = nextState
      }
    }else{ // Mouse down event
      enterTracing ("widgets.user.interface.mouse.down") ; defer { exitTracing ("widgets.user.interface.mouse.down") }
      self.mStartSelectionSet = self.mSelection
      let option = NSEvent.modifierFlags.contains (.option)
      if option {
        let state : any MouseGestureProtocol<WidgetTypesDescription> = self.mouseDownWithOptionKey (geometry: inGeometry)
        self.mDragGestureState = state
      }else{
        let state : any MouseGestureProtocol<WidgetTypesDescription> = self.mouseDownWithoutOptionKey (geometry: inGeometry)
        self.mDragGestureState = state
      }
    }
  }

 // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @MainActor private func mouseDownWithOptionKey (geometry inGeometry : MouseGestureGeometryContext) -> any MouseGestureProtocol<WidgetTypesDescription> {
  //--- Mouse down in a knob of a selected object ?
    for widget in self.widgetArray.reversed () {
      if self.mSelection.contains (widget.shape.id) {
        for knob in widget.knobs {
          if knob.contains (localPoint: widget.shape.orientedOrigin.globalToLocal (inGeometry.unalignedUserStartLocation), scale: inGeometry.scale) {
            return MouseGesture_DragKnob <WidgetTypesDescription> (
              alignedCurrentPoint: inGeometry.alignedUserStartLocation,
              optionKeyInitiallyOn: true,
              widgetID: widget.shape.id,
              dragWidgetKnobAction: knob.dragWidgetKnobAction
            )
          }
        }
      }
    }

    var widgetUnderMouseID : UUID? = nil
    for widget in self.widgetArray.reversed () {
      if widget.shape.orientedOrigin.localOutline (containsLocalPoint: widget.shape.orientedOrigin.globalToLocal (inGeometry.unalignedUserStartLocation)) {
        widgetUnderMouseID = widget.shape.id
        break
      }
    }
    if let widgetID = widgetUnderMouseID {
      if self.mSelection.contains (widgetID) { // option-click on a selected widget
        let selectedArray = self.selectedWidgetArray ()
        self.mSelection.removeAll ()
        for widget in selectedArray {
          if let newWidget = widget.shape.duplicated () {
            self.mWidgetsManager.append (CanariWidget (newWidget))
            self.mSelection.insert (newWidget.id)
          }
        }
        return MouseGesture_DragSelection <WidgetTypesDescription> (alignedCurrentPoint: inGeometry.alignedUserStartLocation)
      }else{ // option-click on a non-selected widget
        if let newWidget = self.mWidgetsManager [shapeID: widgetID]?.shape.duplicated () {
          self.mWidgetsManager.append (CanariWidget (newWidget))
          self.mSelection = [newWidget.id]
          return MouseGesture_DragSelection <WidgetTypesDescription> (alignedCurrentPoint: inGeometry.alignedUserStartLocation)
        }else{
          return MouseGesture_Inactive <WidgetTypesDescription> ()
        }
      }
    }else if let objectCreator = self.mObjectCreator {
      self.beginOrContinueUndoGrouping ()
      let widget = objectCreator (inGeometry)
      self.mWidgetsManager.append (widget)
      self.mSelection = [widget.shape.id]
      return MouseGesture_Creation <WidgetTypesDescription> (objectCreator: objectCreator)
    }else{
      return MouseGesture_Inactive <WidgetTypesDescription> ()
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func mouseDownWithoutOptionKey (geometry inGeometry : MouseGestureGeometryContext) -> any MouseGestureProtocol <WidgetTypesDescription> {
    let control = NSEvent.modifierFlags.contains (.control)
    if control {
      return MouseGesture_Inactive <WidgetTypesDescription> ()
    }else{
      let shift = NSEvent.modifierFlags.contains (.shift)
      if shift {
        return self.mouseDown_shiftKey (geometry: inGeometry)
      }else{
        return self.mouseDown_noKey (geometry: inGeometry)
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func mouseDown_shiftKey (geometry inGeometry : MouseGestureGeometryContext) -> any MouseGestureProtocol <WidgetTypesDescription> {
    var widgetUnderMouseID : UUID? = nil
    for widget in self.widgetArray.reversed () {
      if widget.shape.orientedOrigin.localOutline (containsLocalPoint:widget.shape.orientedOrigin.globalToLocal (inGeometry.unalignedUserStartLocation)) {
        widgetUnderMouseID = widget.shape.id
        break
      }
    }
    if let id = widgetUnderMouseID {
      if self.mSelection.contains (id) {
        self.mSelection.remove (id)
      }else{
        self.mSelection.insert (id)
      }
      return MouseGesture_Inactive <WidgetTypesDescription> ()
    }else{
      return MouseGesture_Inactive <WidgetTypesDescription> ()
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func mouseDown_noKey (geometry inGeometry : MouseGestureGeometryContext) -> any MouseGestureProtocol <WidgetTypesDescription> {
  //--- Mouse down in a knob of a selected object ?
    for widget in self.widgetArray.reversed () {
      if self.mSelection.contains (widget.shape.id) {
        for knob in widget.knobs {
          if knob.contains (localPoint: widget.shape.orientedOrigin.globalToLocal (inGeometry.unalignedUserStartLocation), scale: inGeometry.scale) {
            return MouseGesture_DragKnob <WidgetTypesDescription> (
              alignedCurrentPoint: inGeometry.alignedUserStartLocation,
              optionKeyInitiallyOn: false,
              widgetID: widget.shape.id,
              dragWidgetKnobAction: knob.dragWidgetKnobAction
            )
          }
        }
      }
    }
  //--- Mouse down in a selected object ?
    for widget in self.widgetArray.reversed () {
      if self.mSelection.contains (widget.shape.id), widget.shape.orientedOrigin.localOutline (containsLocalPoint:widget.shape.orientedOrigin.globalToLocal (inGeometry.unalignedUserStartLocation)) {
        return MouseGesture_DragSelection <WidgetTypesDescription> (alignedCurrentPoint: inGeometry.alignedUserStartLocation)
      }
    }
  //--- Mouse down in a non selected object ?
    for widget in self.widgetArray.reversed () {
      if widget.shape.orientedOrigin.localOutline (containsLocalPoint:widget.shape.orientedOrigin.globalToLocal (inGeometry.unalignedUserStartLocation)) {
        self.mSelection = [widget.shape.id]
        return MouseGesture_DragSelection <WidgetTypesDescription> (alignedCurrentPoint: inGeometry.alignedUserStartLocation)
      }
    }
  //--- Mouse down out any selected object
    self.mSelection.removeAll ()
    return MouseGesture_SelectionRectangle <WidgetTypesDescription> (startSelectionSet: self.mSelection)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func contextualMenu (at inUnalignedPoint : CanariPoint, scale inScale : Double) -> any View {
  //--- CMD + Mouse down in a knob of a selected object ?
    for idx in (0 ..< self.mWidgetsManager.count).reversed () {
      let widget = self.mWidgetsManager [widgetIndex: idx]
      if self.mSelection.contains (widget.shape.id) {
        for knob in widget.knobs {
          if knob.contains (localPoint: widget.shape.orientedOrigin.globalToLocal (inUnalignedPoint), scale: inScale) {
            if let menu = knob.menu {
              return menu (ContextualMenuExecutor (self, idx))
            }else{
              return EmptyView ()
            }
          }
        }
      }
    }
  //--- CMD + Mouse down in a selected object ?
    for idx in (0 ..< self.mWidgetsManager.count).reversed () {
      let widget = self.mWidgetsManager [widgetIndex: idx]
      if self.mSelection.contains (widget.shape.id), widget.shape.orientedOrigin.localOutline (containsLocalPoint:widget.shape.orientedOrigin.globalToLocal (inUnalignedPoint)) {
        return widget.shape.contextualMenu (ContextualMenuExecutor (self, idx))
      }
    }
  //---
    return EmptyView ()
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @MainActor public func mouseDraggedEnded () {
//    print ("mouseDraggedEnded")
    self.mSelectionUserRectangle = nil
    if let dragGestureState = self.mDragGestureState {
      dragGestureState.onMouseUp (
        removeUndoGrouping: { self.closeAndRemoveUndoGroupingActions () },
        userSelectionRectangle: &self.mSelectionUserRectangle,
        widgetsManagerInterface: self
      )
      self.closeUndoGroupingIfOpened ()
      self.mDragGestureState = nil
      self.mUndoGroupingIsOpened = false
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: UndoManager
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private var mUndoGroupingIsOpened = false
  private var mUndoManager : UndoManager? = nil

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func setUndoManager (_ inUndoManager : UndoManager?) {
    self.mUndoManager = inUndoManager
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @MainActor private func beginOrContinueUndoGrouping () {
    if !self.mUndoGroupingIsOpened {
      self.mUndoGroupingIsOpened = true
      self.mUndoManager?.beginUndoGrouping ()
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @MainActor private func closeUndoGroupingIfOpened () {
    if self.mUndoGroupingIsOpened {
      self.mUndoGroupingIsOpened = false
      self.mUndoManager?.endUndoGrouping ()
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @MainActor private func closeAndRemoveUndoGroupingActions () {
    if self.mUndoGroupingIsOpened {
      self.mUndoGroupingIsOpened = false
      self.mUndoManager?.endUndoGrouping ()
      self.mUndoManager?.undo ()
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Key actions
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @MainActor public func escapeKeyAction () {
    if self.mDragGestureState != nil {
      self.closeAndRemoveUndoGroupingActions ()
      self.mSelection = self.mStartSelectionSet
      self.mDragGestureState = MouseGesture_Inactive <WidgetTypesDescription> ()
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func backDeleteKeyAction () {
    var idx = 0
    while idx < self.mWidgetsManager.count {
      if self.mSelection.contains (self.mWidgetsManager [widgetIndex: idx].shape.id) {
        self.mWidgetsManager.remove (at: idx)
      }else{
        idx += 1
      }
    }
    self.mSelection.removeAll ()
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func rightArrowKeyAction (magneticGrid inMagneticGrid : CanariLength?, _ inCanvasSize : CanariSize) {
    if let magneticGrid = inMagneticGrid {
      let shift = NSEvent.modifierFlags.contains (.shift)
      let t = CanariPoint (x: magneticGrid * (shift ? 10.0 : 1.0))
      let translation = self.validatedGlobalTranslation (proposedValue: t, canvasSize: inCanvasSize)
      if !translation.isZero {
        var idx = 0
        while idx < self.widgetCount {
          if self.selection.contains (self [widgetIndex: idx].shape.id) {
            self [widgetIndex: idx].shape.orientedOrigin.mOrigin += translation
          }
          idx += 1
        }
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func leftArrowKeyAction (magneticGrid inMagneticGrid : CanariLength?, _ inCanvasSize : CanariSize) {
    if let magneticGrid = inMagneticGrid {
      let shift = NSEvent.modifierFlags.contains (.shift)
      let t = CanariPoint (x: magneticGrid * (shift ? -10.0 : -1.0))
      let translation = self.validatedGlobalTranslation (proposedValue: t, canvasSize: inCanvasSize)
      if !translation.isZero {
        var idx = 0
        while idx < self.widgetCount {
          if self.selection.contains (self [widgetIndex: idx].shape.id) {
            self [widgetIndex: idx].shape.orientedOrigin.mOrigin += translation
          }
          idx += 1
        }
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func upArrowKeyAction (magneticGrid inMagneticGrid : CanariLength?, _ inCanvasSize : CanariSize) {
    if let magneticGrid = inMagneticGrid {
      let shift = NSEvent.modifierFlags.contains (.shift)
      let t = CanariPoint (y: magneticGrid * (shift ? 10.0 : 1.0))
      let translation = self.validatedGlobalTranslation (proposedValue: t, canvasSize: inCanvasSize)
      if !translation.isZero {
        var idx = 0
        while idx < self.widgetCount {
          if self.selection.contains (self [widgetIndex: idx].shape.id) {
            self [widgetIndex: idx].shape.orientedOrigin.mOrigin += translation
          }
          idx += 1
        }
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func downArrowKeyAction (magneticGrid inMagneticGrid : CanariLength?, _ inCanvasSize : CanariSize) {
    if let magneticGrid = inMagneticGrid {
      let shift = NSEvent.modifierFlags.contains (.shift)
      let t = CanariPoint (y: magneticGrid * (shift ? -10.0 : -1.0))
      let translation = self.validatedGlobalTranslation (proposedValue: t, canvasSize:  inCanvasSize)
      if !translation.isZero {
        var idx = 0
        while idx < self.widgetCount {
          if self.selection.contains (self [widgetIndex: idx].shape.id) {
            self [widgetIndex: idx].shape.orientedOrigin.mOrigin += translation
          }
          idx += 1
        }
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Validated translation
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  open func validatedGlobalTranslation (proposedValue inProposedGlobalTranslation : CanariPoint,
                                        canvasSize inCanvasSize : CanariSize) -> CanariPoint {
    return inProposedGlobalTranslation
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: pasteboard
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public override var copyIsEnabled : Bool { !self.mSelection.isEmpty }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public override func performCopy () {
    let selectedProxies = self.selectedWidgetArray ()
    let encoder = JSONEncoder ()
    if let data = try? encoder.encode (selectedProxies), let str = String (data: data, encoding: .utf8) {
    //--- Pasteboard
      let pb = NSPasteboard.general
      pb.declareTypes ([self.mPasteboardType], owner: self)
      pb.setString (str, forType: self.mPasteboardType)
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Actuellement, il n'y a en SwiftUI aucun moyen d'observer si le contenu du pasteboard a changé.
  // Une solution, faute de mieux : utiliser un timer, démarré dans init
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private var mCancellableTimerForUpdateInternalPasteState : AnyCancellable? = nil
  private var mInternalPasteIsEnabled = false

  public override var pasteIsEnabled : Bool { self.mInternalPasteIsEnabled }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public override func performPaste () {
    let pb = NSPasteboard.general
    if let string = pb.string (forType: self.mPasteboardType) {
      let decoder = JSONDecoder ()
      if let decodedWidgets = try? decoder.decode ([CanariWidget <WidgetTypesDescription>].self, from: string.data (using: .utf8)!) {
        self.mSelection.removeAll ()
        for widget in decodedWidgets {
          self.mWidgetsManager.append (widget)
          self.mSelection.insert (widget.shape.id)
        }
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public override var selectAllIsEnabled : Bool { !self.widgetArray.isEmpty }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public override func performSelectAll () {
    for widget in self.widgetArray {
      self.mSelection.insert (widget.shape.id)
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

 public  override var deleteIsEnabled : Bool { !self.widgetArray.isEmpty }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public override func performDelete () {
    let selection = self.mSelection
    self.mSelection.removeAll ()
    for widget in self.widgetArray {
      if selection.contains (widget.shape.id) {
        self.mWidgetsManager.remove (id: widget.shape.id)
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public override var cutIsEnabled : Bool { !self.mSelection.isEmpty }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public override func performCut () {
    self.performCopy ()
    self.performDelete ()
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Grouping
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public override var groupIsEnabled : Bool {
    (self.mSelection.count > 1)
    && (WidgetTypesDescription.shapeTypeArray.first { $0.0 == Shape_Group <WidgetTypesDescription>.self } != nil)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public override func performGroup () {
    let selectedWidgets = self.selectedWidgetArray ()
    let widgetGroup = Shape_Group <WidgetTypesDescription> (grouping: selectedWidgets)
    for widget in selectedWidgets {
      self.mWidgetsManager.remove (id: widget.shape.id)
    }
    self.mWidgetsManager.append (CanariWidget (widgetGroup))
    self.mSelection = [widgetGroup.id]
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public override var ungroupIsEnabled : Bool {
    for widget in self.widgetArray {
      if self.mSelection.contains (widget.shape.id), let w = widget.shape as? Shape_Group <WidgetTypesDescription>, w.mUnGroupIsEnabled {
        return true
      }
    }
    return false
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public override func performUngroup () {
    for widget in self.widgetArray {
      if self.mSelection.contains (widget.shape.id), let group = widget.shape as? Shape_Group <WidgetTypesDescription>, group.mUnGroupIsEnabled {
        let array = group.ungroupedArray ()
        self.mWidgetsManager.replaceWidget (id: group.id, with: array)
        self.mSelection.remove (group.id)
        for p in array {
          self.mSelection.insert (p.shape.id)
        }
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Inspector view
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @MainActor @ViewBuilder public func inspectorViewForCurrentSelection () -> some View {
    if self.mSelection.isEmpty {
      Text ("Empty Selection").frame (maxHeight: .infinity).foregroundStyle (.secondary)
    }else{
      VStack (spacing: 1) {
        InspectorOfCanariScaledOrientedOrigin (widgetsUserInterface: self)
        if let type = self.commonTypeForSelection () {
          Text (type.inspectorTitle).bold ()
          ScrollView (.vertical) {
            AnyView (type.inspectorView (proxy: CanariInspectorProxy (self)).id (self.mSelection))
          }
        }else if self.mSelection.count > 1 {
          Text ("Multiple Selection").frame (maxHeight: .infinity).foregroundStyle (.secondary)
        }else{
          Text ("Single Selection").frame (maxHeight: .infinity).foregroundStyle (.secondary)
        }
      }.padding ()
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func commonTypeForSelection () -> (any CanariShapeUIProtocol <WidgetTypesDescription>.Type)? {
    var result : (any CanariShapeUIProtocol <WidgetTypesDescription>.Type)? = nil
    for id in self.mSelection {
      if let widget = self.mWidgetsManager [shapeID: id] {
        if let r = result {
          if r != type (of: widget.shape) {
            return nil
          }
        }else{
          result = type (of: widget.shape)
        }
      }
    }
    return result
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
