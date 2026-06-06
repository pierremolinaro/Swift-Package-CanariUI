//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 21/02/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI
import Combine

//--------------------------------------------------------------------------------------------------

@Observable public final class WidgetsUserInterface <TypeDictionary : WidgetTypeArrayProtocol> : MenuCommands {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private let mPasteboardType : NSPasteboard.PasteboardType

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (withPasteboardType inPasteboardType : NSPasteboard.PasteboardType) {
    self.mPasteboardType = inPasteboardType
    super.init ()
    self.mCancellable = Timer.publish (every: 0.5, on: .main, in: .common)
    .autoconnect ()
    .sink { _ in
      self.mInternalPasteIsEnabled = NSPasteboard.general.string (forType: self.mPasteboardType) != nil
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var mWidgetsManager = WidgetsManager <TypeDictionary> ()

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private var mSelection = Set <UUID> ()

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private var mHoveredObject : UUID? = nil
  private var mSelectionUserRectangle : CanariRect? = nil
  public var selectionUserRectangle : CanariRect? { self.mSelectionUserRectangle }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private var mStartSelectionSet = Set <UUID> ()
  private var mDragGestureState : (any MouseGestureProtocol<TypeDictionary>)? = nil

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: append
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func append (_ inNewObject : any WidgetUIProtocol <TypeDictionary>) {
    self.mWidgetsManager.append (inNewObject)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Object Creator
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func setObjectCreator (_ inNewCreator : @escaping (MouseGestureGeometryContext) -> any WidgetUIProtocol <TypeDictionary>) {
    self.mObjectCreator = inNewCreator
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private var mObjectCreator : ((MouseGestureGeometryContext) -> any WidgetUIProtocol <TypeDictionary>)? = nil

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Draw
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func draw (context : inout GraphicsContext, zoom inZoom : Double) {
    enterTracing ("widgets.user.interface.draw") ; defer { exitTracing ("widgets.user.interface.draw") }
  //--- Draw widgets
    for widget in self.mWidgetsManager.widgets {
      widget.draw (
        context: &context,
        zoom: inZoom,
        hovered: widget.id == self.mHoveredObject,
        selected: self.mSelection.contains (widget.id),
        groupLevel: 0
      )
    }
  //--- Get alignment points
    var selectedObjetsAlignmentPoints = Set <CanariPoint> ()
    for widget in self.mWidgetsManager.widgets {
      if self.mSelection.contains (widget.id) {
        selectedObjetsAlignmentPoints.formUnion (widget.alignmentGuidePoints ())
      }
    }
  //--- Draw alignment guides
    for p in selectedObjetsAlignmentPoints {
      for widget in self.mWidgetsManager.widgets {
        if !self.mSelection.contains (widget.id) {
          for q in widget.alignmentGuidePoints () {
            if p.x == q.x, p.y != q.y { // Vertical guide
              var path = CanariPath ()
              path.move (to: p.scaled (by: inZoom))
              path.addLine (to: q.scaled (by: inZoom))
              context.stroke (path, with: .color (.orange), lineWidth: .px (2))
            }else if p.y == q.y, p.x != q.x { // Horizontal guide
              var path = CanariPath ()
              path.move (to: p.scaled (by: inZoom))
              path.addLine (to: q.scaled (by: inZoom))
              context.stroke (path, with: .color (.orange), lineWidth: .px (2))
            }
          }
        }
      }
    }
  //--- Draw knobs
    for widget in self.mWidgetsManager.widgets {
      if self.mSelection.contains (widget.id) {
        for knob in widget.knobs () {
          knob.draw (context: &context, zoom: inZoom)
        }
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Hover tracking
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func hoverTracking (at inPoint : CanariPoint) {
    enterTracing ("widgets.user.interface.hover.tracking") ; defer { exitTracing ("widgets.user.interface.hover.tracking") }
    for widget in self.mWidgetsManager.widgets.reversed () {
      if widget.contains (point: inPoint) {
        self.mHoveredObject = widget.id
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

  public func mouseDownOrMouseDragged (geometry inGeometry : MouseGestureGeometryContext) {
    enterTracing ("widgets.user.interface.mouse.dragging") ; defer { exitTracing ("widgets.user.interface.mouse.dragging") }
    if let dragGestureState = self.mDragGestureState { // Mouse dragged event
      var optionalNextState : (any MouseGestureProtocol <TypeDictionary>)? = nil
      dragGestureState.onMouseDragged (
        geometry: inGeometry,
        beginOrContinueUndoGrouping: { self.beginOrContinueUndoGrouping () },
        selection: &self.mSelection,
        userSelectionRectangle: &self.mSelectionUserRectangle,
        widgetsManager: &self.mWidgetsManager,
        optionalNextState: &optionalNextState
      )
      if let nextState : any MouseGestureProtocol<TypeDictionary> = optionalNextState {
        self.mDragGestureState = nextState
      }
    }else{ // Mouse down event
      self.mStartSelectionSet = self.mSelection
      let option = NSEvent.modifierFlags.contains (.option)
      if option {
        let state : any MouseGestureProtocol<TypeDictionary> = self.mouseDownWithOptionKey (geometry: inGeometry)
        self.mDragGestureState = state
      }else{
        let state : any MouseGestureProtocol<TypeDictionary> = self.mouseDownWithoutOptionKey (geometry: inGeometry)
        self.mDragGestureState = state
      }
    }
  }

 // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func mouseDownWithOptionKey (geometry inGeometry : MouseGestureGeometryContext) -> any MouseGestureProtocol<TypeDictionary> {
  //--- Mouse down in a knob of a selected object ?
    for widget in self.mWidgetsManager.widgets.reversed () {
      if self.mSelection.contains (widget.id) {
        for knob in widget.knobs () {
          if knob.contains (point: inGeometry.unalignedUserStartLocation, zoom: inGeometry.zoom) {
            return MouseGesture_DragKnob <TypeDictionary> (
              alignedCurrentPoint: inGeometry.alignedUserStartLocation,
              optionKeyInitiallyOn: true,
              widgetID: widget.id,
              action: knob.dragAction
            )
          }
        }
      }
    }

    var widgetUnderMouseID : UUID? = nil
    for widget in self.mWidgetsManager.widgets.reversed () {
      if widget.contains (point: inGeometry.unalignedUserStartLocation) {
        widgetUnderMouseID = widget.id
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
        return MouseGesture_DragSelection <TypeDictionary> (alignedCurrentPoint: inGeometry.alignedUserStartLocation)
      }else{ // option-click on a non-selected widget
        if let newWidget = self.mWidgetsManager [id: widgetID]?.duplicated () {
          self.mWidgetsManager.append (newWidget)
          self.mSelection = [newWidget.id]
          return MouseGesture_DragSelection <TypeDictionary> (alignedCurrentPoint: inGeometry.alignedUserStartLocation)
        }else{
          return MouseGesture_Inactive <TypeDictionary> ()
        }
      }
    }else if let objectCreator = self.mObjectCreator {
      self.beginOrContinueUndoGrouping ()
      let widget = objectCreator (inGeometry)
      self.mWidgetsManager.append (widget)
      self.mSelection = [widget.id]
      return MouseGesture_Creation <TypeDictionary> (objectCreator: objectCreator)
    }else{
      return MouseGesture_Inactive <TypeDictionary> ()
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func mouseDownWithoutOptionKey (geometry inGeometry : MouseGestureGeometryContext) -> any MouseGestureProtocol <TypeDictionary> {
    let control = NSEvent.modifierFlags.contains (.control)
    if control {
      return MouseGesture_Inactive <TypeDictionary> ()
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

  private func mouseDown_shiftKey (geometry inGeometry : MouseGestureGeometryContext) -> any MouseGestureProtocol <TypeDictionary> {
    var widgetUnderMouseID : UUID? = nil
    for widget in self.mWidgetsManager.widgets.reversed () {
      if widget.contains (point: inGeometry.unalignedUserStartLocation) {
        widgetUnderMouseID = widget.id
        break
      }
    }
    if let id = widgetUnderMouseID {
      if self.mSelection.contains (id) {
        self.mSelection.remove (id)
      }else{
        self.mSelection.insert (id)
      }
      return MouseGesture_Inactive <TypeDictionary> ()
    }else{
      return MouseGesture_Inactive <TypeDictionary> ()
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func mouseDown_noKey (geometry inGeometry : MouseGestureGeometryContext) -> any MouseGestureProtocol <TypeDictionary> {
  //--- Mouse down in a knob of a selected object ?
    for widget in self.mWidgetsManager.widgets.reversed () {
      if self.mSelection.contains (widget.id) {
        for knob in widget.knobs () {
          if knob.contains (point: inGeometry.unalignedUserStartLocation, zoom: inGeometry.zoom) {
            return MouseGesture_DragKnob <TypeDictionary> (
              alignedCurrentPoint: inGeometry.alignedUserStartLocation,
              optionKeyInitiallyOn: false,
              widgetID: widget.id,
              action: knob.dragAction
            )
          }
        }
      }
    }
  //--- Mouse down in a selected object ?
    for widget in self.mWidgetsManager.widgets.reversed () {
      if self.mSelection.contains (widget.id), widget.contains (point: inGeometry.unalignedUserStartLocation) {
        return MouseGesture_DragSelection <TypeDictionary> (alignedCurrentPoint: inGeometry.alignedUserStartLocation)
      }
    }
  //--- Mouse down in a non selected object ?
    for widget in self.mWidgetsManager.widgets.reversed () {
      if widget.contains (point: inGeometry.unalignedUserStartLocation) {
        self.mSelection = [widget.id]
        return MouseGesture_DragSelection <TypeDictionary> (alignedCurrentPoint: inGeometry.alignedUserStartLocation)
      }
    }
  //--- Mouse down out any selected object
    self.mSelection.removeAll ()
    return MouseGesture_SelectionRectangle <TypeDictionary> (startSelectionSet: self.mSelection)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func contextualMenu (at inUnalignedPoint : CanariPoint, zoom inZoom : Double) -> any View {
  //--- CMD + Mouse down in a knob of a selected object ?
    for idx in (0 ..< self.mWidgetsManager.count).reversed () {
      let widget = self.mWidgetsManager [widget: idx]
      if self.mSelection.contains (widget.id) {
        for knob in widget.knobs () {
          if knob.contains (point: inUnalignedPoint, zoom: inZoom) {
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
      let widget = self.mWidgetsManager [widget: idx]
      if self.mSelection.contains (widget.id), widget.contains (point: inUnalignedPoint) {
        return widget.contextualMenu (ContextualMenuExecutor (self, idx))
      }
    }
  //---
    return EmptyView ()
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func mouseDraggedEnded () {
//    print ("mouseDraggedEnded")
    self.mSelectionUserRectangle = nil
    if let dragGestureState = self.mDragGestureState {
      dragGestureState.onMouseUp (
        removeUndoGrouping: { self.closeAndRemoveUndoGroupingActions () },
        selection: &self.mSelection,
        userSelectionRectangle: &self.mSelectionUserRectangle,
        widgetsManager: &self.mWidgetsManager
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

  private func beginOrContinueUndoGrouping () {
    if !self.mUndoGroupingIsOpened {
      self.mUndoGroupingIsOpened = true
      self.mUndoManager?.beginUndoGrouping ()
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func closeUndoGroupingIfOpened () {
    if self.mUndoGroupingIsOpened {
      self.mUndoGroupingIsOpened = false
      self.mUndoManager?.endUndoGrouping ()
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func closeAndRemoveUndoGroupingActions () {
    if self.mUndoGroupingIsOpened {
      self.mUndoGroupingIsOpened = false
      self.mUndoManager?.endUndoGrouping ()
      self.mUndoManager?.undo ()
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Key actions
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func escapeKeyAction () {
    if self.mDragGestureState != nil {
      self.closeAndRemoveUndoGroupingActions ()
      self.mSelection = self.mStartSelectionSet
      self.mDragGestureState = MouseGesture_Inactive <TypeDictionary> ()
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func backDeleteKeyAction () {
    var idx = 0
    while idx < self.mWidgetsManager.count {
      if self.mSelection.contains (self.mWidgetsManager [widget: idx].id) {
        self.mWidgetsManager.remove (at: idx)
      }else{
        idx += 1
      }
    }
    self.mSelection.removeAll ()
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func rightArrowKeyAction (magneticGrid inMagneticGrid : CanariLength?) {
    if let magneticGrid = inMagneticGrid {
      let shift = NSEvent.modifierFlags.contains (.shift)
      var translation = CanariPoint (x: magneticGrid * (shift ? 10.0 : 1.0))
      for i in 0 ..< self.mWidgetsManager.count {
        if self.mSelection.contains (self.mWidgetsManager [widget: i].id) {
          self.mWidgetsManager [widget: i].limitTranslation (&translation)
        }
      }
      var idx = 0
      while idx < self.mWidgetsManager.count {
        if self.mSelection.contains (self.mWidgetsManager [widget: idx].id) {
          self.mWidgetsManager [widget: idx].performTranslation (by: translation)
        }
        idx += 1
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func leftArrowKeyAction (magneticGrid inMagneticGrid : CanariLength?) {
    if let magneticGrid = inMagneticGrid {
      let shift = NSEvent.modifierFlags.contains (.shift)
      var translation = CanariPoint (x: magneticGrid * (shift ? -10.0 : -1.0))
      for i in 0 ..< self.mWidgetsManager.count {
        if self.mSelection.contains (self.mWidgetsManager [widget: i].id) {
          self.mWidgetsManager [widget: i].limitTranslation (&translation)
        }
      }
      var idx = 0
      while idx < self.mWidgetsManager.count {
        if self.mSelection.contains (self.mWidgetsManager [widget: idx].id) {
          self.mWidgetsManager [widget: idx].performTranslation (by: translation)
        }
        idx += 1
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func upArrowKeyAction (magneticGrid inMagneticGrid : CanariLength?) {
    if let magneticGrid = inMagneticGrid {
      let shift = NSEvent.modifierFlags.contains (.shift)
      var translation = CanariPoint (y: magneticGrid * (shift ? 10.0 : 1.0))
      for i in 0 ..< self.mWidgetsManager.count {
        if self.mSelection.contains (self.mWidgetsManager [widget: i].id) {
          self.mWidgetsManager [widget: i].limitTranslation (&translation)
        }
      }
      var idx = 0
      while idx < self.mWidgetsManager.count {
        if self.mSelection.contains (self.mWidgetsManager [widget: idx].id) {
          self.mWidgetsManager [widget: idx].performTranslation (by: translation)
        }
        idx += 1
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func downArrowKeyAction (magneticGrid inMagneticGrid : CanariLength?) {
    if let magneticGrid = inMagneticGrid {
      let shift = NSEvent.modifierFlags.contains (.shift)
      var translation = CanariPoint (y: magneticGrid * (shift ? -10.0 : -1.0))
      for i in 0 ..< self.mWidgetsManager.count {
        if self.mSelection.contains (self.mWidgetsManager [widget: i].id) {
          self.mWidgetsManager [widget: i].limitTranslation (&translation)
        }
      }
      var idx = 0
      while idx < self.mWidgetsManager.count {
        if self.mSelection.contains (self.mWidgetsManager [widget: idx].id) {
          self.mWidgetsManager [widget: idx].performTranslation (by: translation)
        }
        idx += 1
      }
    }
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

  private var mCancellable : AnyCancellable? = nil
  private var mInternalPasteIsEnabled = false

  public override var pasteIsEnabled : Bool { self.mInternalPasteIsEnabled }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public override func performPaste () {
    let pb = NSPasteboard.general
    if let string = pb.string (forType: self.mPasteboardType) {
      let decoder = JSONDecoder ()
      if let decodedWidgets = try? decoder.decode ([WidgetProxy <TypeDictionary>].self, from: string.data (using: .utf8)!) {
        self.mSelection.removeAll ()
        for proxy in decodedWidgets {
          self.mWidgetsManager.append (proxy.widget)
          self.mSelection.insert (proxy.widget.id)
        }
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public override var selectAllIsEnabled : Bool { !self.mWidgetsManager.widgets.isEmpty }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public override func performSelectAll () {
    for widget in self.mWidgetsManager.widgets {
      self.mSelection.insert (widget.id)
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

 public  override var deleteIsEnabled : Bool { !self.mWidgetsManager.widgets.isEmpty }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public override func performDelete () {
    let selection = self.mSelection
    self.mSelection.removeAll ()
    for widget in self.mWidgetsManager.widgets {
      if selection.contains (widget.id) {
        self.mWidgetsManager.remove (id: widget.id)
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
    && (TypeDictionary.array.first { $0 == WidgetGroup <TypeDictionary>.self } != nil)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public override func performGroup () {
    let selectedWidgets = self.mWidgetsManager.widgetArray (fromSelection: self.mSelection)
    let widgetGroup = WidgetGroup <TypeDictionary> (selectedWidgets)
    for widget in selectedWidgets {
      self.mWidgetsManager.remove (id: widget.id)
    }
    self.mWidgetsManager.append (widgetGroup)
    self.mSelection = [widgetGroup.id]
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public override var ungroupIsEnabled : Bool {
    for widget in self.mWidgetsManager.widgets {
      if self.mSelection.contains (widget.id), let w = widget as? WidgetGroup <TypeDictionary>, w.mUnGroupIsEnabled {
        return true
      }
    }
    return false
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public override func performUngroup () {
    for widget in self.mWidgetsManager.widgets {
      if self.mSelection.contains (widget.id), let group = widget as? WidgetGroup <TypeDictionary>, group.mUnGroupIsEnabled {
        self.mWidgetsManager.replaceWidget (id: widget.id, with: group.widgetArray)
        self.mSelection.remove (widget.id)
        for p in group.widgetArray {
          self.mSelection.insert (p.id)
        }
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Detail view
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @ViewBuilder func editorDetailViewForCurrentSelection () -> some View {
    if self.mSelection.isEmpty {
      Text ("Empty Selection").frame (maxHeight: .infinity).foregroundStyle (.secondary)
    }else if let type = self.commonTypeForSelection () {
      AnyView (type.inspectorView (proxy: InspectorProxy (self, self.mSelection)).id (self.mSelection))
    }else if self.mSelection.count > 1 {
      Text ("Multiple Selection").frame (maxHeight: .infinity).foregroundStyle (.secondary)
    }else{
      Text ("Single Selection").frame (maxHeight: .infinity).foregroundStyle (.secondary)
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func commonTypeForSelection () -> (WidgetUIProtocol <TypeDictionary>).Type? {
    var result : (WidgetUIProtocol <TypeDictionary>).Type? = nil
    for id in self.mSelection {
      if let widget = self.mWidgetsManager [id: id] {
        if let r = result {
          if r != type (of: widget) {
            return nil
          }
        }else{
          result = type (of: widget)
        }
      }
    }
    return result // WidgetGroup <TypeDictionary>.self
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------

