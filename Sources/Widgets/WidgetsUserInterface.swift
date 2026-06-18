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
  //MARK: Widget array
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private var mWidgetsManager = WidgetsManager <WidgetTypesDescription> ()
  public var widgetCount : Int { self.mWidgetsManager.count }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public subscript (widgetIndex inIndex : Int) -> any WidgetUIProtocol <WidgetTypesDescription> {
    get { self.mWidgetsManager [widgetIndex: inIndex] }
    set { self.mWidgetsManager [widgetIndex: inIndex] = newValue }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  subscript (widgetID inID : UUID) -> (any WidgetUIProtocol <WidgetTypesDescription>)? {
    get { self.mWidgetsManager [widgetID: inID] }
    set { self.mWidgetsManager [widgetID: inID] = newValue }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func removeLast () {
    self.mWidgetsManager.removeLast ()
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var proxyArray : [WidgetProxy <WidgetTypesDescription>] { self.mWidgetsManager.proxyArray }
//    var array = [WidgetProxy <WidgetTypesDescription>] ()
//    for widget in self.mWidgetsManager.widgets {
//      array.append (WidgetProxy (widget))
//    }
//    return array
//  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func contentsIsExactly (_ inWidgets : [WidgetProxy <WidgetTypesDescription>]) -> Bool {
    if self.widgetCount != inWidgets.count {
      return false
    }else{
      for i in 0 ..< self.widgetCount {
        if !self.proxyArray [i].widget.isEqual (to: inWidgets [i].widget) {
          return false
        }
      }
      return true
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func setWidgets (fromProxies inProxies : [WidgetProxy <WidgetTypesDescription>]) {
    self.mWidgetsManager.setWidgets (fromProxies: inProxies)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func append (_ inNewObject : any WidgetUIProtocol <WidgetTypesDescription>) {
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

  private var mHoveredObject : UUID? = nil
  private var mSelectionUserRectangle : CanariRect? = nil
  public var selectionUserRectangle : CanariRect? { self.mSelectionUserRectangle }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private var mStartSelectionSet = Set <UUID> ()
  private var mDragGestureState : (any MouseGestureProtocol<WidgetTypesDescription>)? = nil

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: append and set selection to added object
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func appendAndSetSelection (_ inNewObject : any WidgetUIProtocol <WidgetTypesDescription>) {
    self.mWidgetsManager.append (inNewObject)
    self.mSelection.removeAll ()
    self.mSelection.insert (inNewObject.id)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Object Creator
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func setObjectCreator (_ inNewCreator : @escaping (MouseGestureGeometryContext) -> any WidgetUIProtocol <WidgetTypesDescription>) {
    self.mObjectCreator = inNewCreator
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private var mObjectCreator : ((MouseGestureGeometryContext) -> any WidgetUIProtocol <WidgetTypesDescription>)? = nil

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Draw
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func draw (context ioContext : inout GraphicsContext,
                    hoverUserLocationPoint inHoverUserLocationPoint : CanariPoint?,
                    scale inScale : Double) {
    enterTracing ("widgets.user.interface.draw") ; defer { exitTracing ("widgets.user.interface.draw") }
    ioContext.scale (by: inScale)
  //--- Draw widgets
    for proxy in self.mWidgetsManager.proxyArray {
      proxy.widget.drawFromGlobal (
        context: &ioContext,
        scale: inScale * proxy.widget.orientedOrigin.mScale,
        hovered: proxy.widget.id == self.mHoveredObject,
        selected: self.mSelection.contains (proxy.widget.id),
        groupLevel: 0
      )
    }
  //--- Get alignment points
    var selectedObjetsAlignmentPoints = Set <CanariPoint> ()
    for proxy in self.mWidgetsManager.proxyArray {
      if self.mSelection.contains (proxy.widget.id) {
        selectedObjetsAlignmentPoints.formUnion (proxy.widget.orientedOrigin.localToGlobal (proxy.widget.localAlignmentGuidePoints))
      }
    }
  //--- Draw alignment guides
    for p in selectedObjetsAlignmentPoints {
      for proxy in self.mWidgetsManager.proxyArray {
        if !self.mSelection.contains (proxy.widget.id) {
          for q in proxy.widget.orientedOrigin.localToGlobal (proxy.widget.localAlignmentGuidePoints) {
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
    for proxy in self.mWidgetsManager.proxyArray {
      if self.mSelection.contains (proxy.widget.id), !proxy.widget.knobs.isEmpty {
        ioContext.translate (by: proxy.widget.orientedOrigin.mOrigin)
        ioContext.rotate (by: proxy.widget.orientedOrigin.mAngle)
        ioContext.scale (by: proxy.widget.orientedOrigin.mScale)
        for knob in proxy.widget.knobs {
          let inside : Bool
          if let p = inHoverUserLocationPoint {
            inside = knob.contains (
              localPoint: proxy.widget.orientedOrigin.globalToLocal (p),
              scale: inScale
            )
          }else{
            inside = false
          }
          knob.drawKnob (context: &ioContext, inside: inside, scale: inScale * proxy.widget.orientedOrigin.mScale)
        }
        ioContext.scale (by: 1.0 / proxy.widget.orientedOrigin.mScale)
        ioContext.rotate (by: -proxy.widget.orientedOrigin.mAngle)
        ioContext.translate (by: -proxy.widget.orientedOrigin.mOrigin)
      }
    }
    ioContext.scale (by: 1.0 / inScale)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Hover tracking
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func hoverTracking (at inPoint : CanariPoint) {
    enterTracing ("widgets.user.interface.hover.tracking") ; defer { exitTracing ("widgets.user.interface.hover.tracking") }
    for proxy in self.mWidgetsManager.proxyArray.reversed () {
      if proxy.widget.containsLocalPoint (proxy.widget.orientedOrigin.globalToLocal (inPoint)) {
        self.mHoveredObject = proxy.widget.id
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
    for proxy in self.mWidgetsManager.proxyArray.reversed () {
      if self.mSelection.contains (proxy.widget.id) {
        for knob in proxy.widget.knobs {
          if knob.contains (localPoint: proxy.widget.orientedOrigin.globalToLocal (inGeometry.unalignedUserStartLocation), scale: inGeometry.scale) {
            return MouseGesture_DragKnob <WidgetTypesDescription> (
              alignedCurrentPoint: inGeometry.alignedUserStartLocation,
              optionKeyInitiallyOn: true,
              widgetID: proxy.widget.id,
              dragWidgetKnobAction: knob.dragWidgetKnobAction
            )
          }
        }
      }
    }

    var widgetUnderMouseID : UUID? = nil
    for proxy in self.mWidgetsManager.proxyArray.reversed () {
      if proxy.widget.containsLocalPoint (proxy.widget.orientedOrigin.globalToLocal (inGeometry.unalignedUserStartLocation)) {
        widgetUnderMouseID = proxy.widget.id
        break
      }
    }
    if let widgetID = widgetUnderMouseID {
      if self.mSelection.contains (widgetID) { // option-click on a selected widget
        let selectedArray = self.mWidgetsManager.widgetArray (fromSelection: self.mSelection)
        self.mSelection.removeAll ()
        for widget in selectedArray {
          if let newWidget = widget.duplicated () {
            self.mWidgetsManager.append (newWidget)
            self.mSelection.insert (newWidget.id)
          }
        }
        return MouseGesture_DragSelection <WidgetTypesDescription> (alignedCurrentPoint: inGeometry.alignedUserStartLocation)
      }else{ // option-click on a non-selected widget
        if let newWidget = self.mWidgetsManager [widgetID: widgetID]?.duplicated () {
          self.mWidgetsManager.append (newWidget)
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
      self.mSelection = [widget.id]
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
    for proxy in self.mWidgetsManager.proxyArray.reversed () {
      if proxy.widget.containsLocalPoint (proxy.widget.orientedOrigin.globalToLocal (inGeometry.unalignedUserStartLocation)) {
        widgetUnderMouseID = proxy.widget.id
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
    for proxy in self.mWidgetsManager.proxyArray.reversed () {
      if self.mSelection.contains (proxy.widget.id) {
        for knob in proxy.widget.knobs {
          if knob.contains (localPoint: proxy.widget.orientedOrigin.globalToLocal (inGeometry.unalignedUserStartLocation), scale: inGeometry.scale) {
            return MouseGesture_DragKnob <WidgetTypesDescription> (
              alignedCurrentPoint: inGeometry.alignedUserStartLocation,
              optionKeyInitiallyOn: false,
              widgetID: proxy.widget.id,
              dragWidgetKnobAction: knob.dragWidgetKnobAction
            )
          }
        }
      }
    }
  //--- Mouse down in a selected object ?
    for proxy in self.mWidgetsManager.proxyArray.reversed () {
      if self.mSelection.contains (proxy.widget.id), proxy.widget.containsLocalPoint (proxy.widget.orientedOrigin.globalToLocal (inGeometry.unalignedUserStartLocation)) {
        return MouseGesture_DragSelection <WidgetTypesDescription> (alignedCurrentPoint: inGeometry.alignedUserStartLocation)
      }
    }
  //--- Mouse down in a non selected object ?
    for proxy in self.mWidgetsManager.proxyArray.reversed () {
      if proxy.widget.containsLocalPoint (proxy.widget.orientedOrigin.globalToLocal (inGeometry.unalignedUserStartLocation)) {
        self.mSelection = [proxy.widget.id]
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
      if self.mSelection.contains (widget.id) {
        for knob in widget.knobs {
          if knob.contains (localPoint: widget.orientedOrigin.globalToLocal (inUnalignedPoint), scale: inScale) {
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
      if self.mSelection.contains (widget.id), widget.containsLocalPoint (widget.orientedOrigin.globalToLocal (inUnalignedPoint)) {
        return widget.contextualMenu (ContextualMenuExecutor (self, idx))
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
      if self.mSelection.contains (self.mWidgetsManager [widgetIndex: idx].id) {
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
      let translation = self.validatedTranslation (proposedValue: t, canvasSize: inCanvasSize)
      if !translation.isZero {
        var idx = 0
        while idx < self.widgetCount {
          if self.selection.contains (self [widgetIndex: idx].id) {
            self [widgetIndex: idx].translate (by: translation)
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
      let translation = self.validatedTranslation (proposedValue: t, canvasSize: inCanvasSize)
      if !translation.isZero {
        var idx = 0
        while idx < self.widgetCount {
          if self.selection.contains (self [widgetIndex: idx].id) {
            self [widgetIndex: idx].translate (by: translation)
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
      let translation = self.validatedTranslation (proposedValue: t, canvasSize: inCanvasSize)
      if !translation.isZero {
        var idx = 0
        while idx < self.widgetCount {
          if self.selection.contains (self [widgetIndex: idx].id) {
            self [widgetIndex: idx].translate (by: translation)
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
      let translation = self.validatedTranslation (proposedValue: t, canvasSize:  inCanvasSize)
      if !translation.isZero {
        var idx = 0
        while idx < self.widgetCount {
          if self.selection.contains (self [widgetIndex: idx].id) {
            self [widgetIndex: idx].translate (by: translation)
          }
          idx += 1
        }
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Validated translation
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  open func validatedTranslation (proposedValue inProposedTranslation : CanariPoint,
                                  canvasSize inCanvasSize : CanariSize) -> CanariPoint {
    return inProposedTranslation
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: pasteboard
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public override var copyIsEnabled : Bool { !self.mSelection.isEmpty }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public override func performCopy () {
    let selectedProxies = self.mWidgetsManager.proxyArray (fromSelection: self.mSelection)
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
      if let decodedWidgets = try? decoder.decode ([WidgetProxy <WidgetTypesDescription>].self, from: string.data (using: .utf8)!) {
        self.mSelection.removeAll ()
        for proxy in decodedWidgets {
          self.mWidgetsManager.append (proxy.widget)
          self.mSelection.insert (proxy.widget.id)
        }
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public override var selectAllIsEnabled : Bool { !self.mWidgetsManager.proxyArray.isEmpty }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public override func performSelectAll () {
    for proxy in self.mWidgetsManager.proxyArray {
      self.mSelection.insert (proxy.widget.id)
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

 public  override var deleteIsEnabled : Bool { !self.mWidgetsManager.proxyArray.isEmpty }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public override func performDelete () {
    let selection = self.mSelection
    self.mSelection.removeAll ()
    for proxy in self.mWidgetsManager.proxyArray {
      if selection.contains (proxy.widget.id) {
        self.mWidgetsManager.remove (id: proxy.widget.id)
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
    && (WidgetTypesDescription.widgetTypeArray.first { $0.0 == WidgetGroup <WidgetTypesDescription>.self } != nil)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public override func performGroup () {
    let selectedWidgets = self.mWidgetsManager.widgetArray (fromSelection: self.mSelection)
    let widgetGroup = WidgetGroup <WidgetTypesDescription> (selectedWidgets)
    for widget in selectedWidgets {
      self.mWidgetsManager.remove (id: widget.id)
    }
    self.mWidgetsManager.append (widgetGroup)
    self.mSelection = [widgetGroup.id]
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public override var ungroupIsEnabled : Bool {
    for proxy in self.mWidgetsManager.proxyArray {
      if self.mSelection.contains (proxy.widget.id), let w = proxy.widget as? WidgetGroup <WidgetTypesDescription>, w.mUnGroupIsEnabled {
        return true
      }
    }
    return false
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public override func performUngroup () {
    for proxy in self.mWidgetsManager.proxyArray {
      if self.mSelection.contains (proxy.widget.id), let group = proxy.widget as? WidgetGroup <WidgetTypesDescription>, group.mUnGroupIsEnabled {
        let array = group.ungroupedArray ()
        self.mWidgetsManager.replaceWidget (id: group.id, with: array)
        self.mSelection.remove (group.id)
        for p in array {
          self.mSelection.insert (p.id)
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
    }else if let type = self.commonTypeForSelection () {
      AnyView (type.inspectorView (proxy: InspectorProxy (self)).id (self.mSelection))
    }else if self.mSelection.count > 1 {
      Text ("Multiple Selection").frame (maxHeight: .infinity).foregroundStyle (.secondary)
    }else{
      Text ("Single Selection").frame (maxHeight: .infinity).foregroundStyle (.secondary)
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func commonTypeForSelection () -> (any WidgetUIProtocol <WidgetTypesDescription>.Type)? {
    var result : (any WidgetUIProtocol <WidgetTypesDescription>.Type)? = nil
    for id in self.mSelection {
      if let widget = self.mWidgetsManager [widgetID: id] {
        if let r = result {
          if r != type (of: widget) {
            return nil
          }
        }else{
          result = type (of: widget)
        }
      }
    }
    return result // WidgetGroup <WidgetTypesDescription>.self
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------

//extension Array : Equatable where Element == [any WidgetUIProtocol <any DocumentWidgetsDescriptionProtocol>] {
//
////  public static func == (inLeft : Self, inRight : Self) -> Bool {
////    if inLeft.count != inRight.count {
////      return false
////    }else{
////      for i in 0 ..< inLeft.count {
////        if !inLeft [i].isEqual (to: inRight [i]) {
////          return false
////        }
////      }
////      return true
////    }
////  }
//}
