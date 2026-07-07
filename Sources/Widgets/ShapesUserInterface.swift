//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 21/02/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI
import Combine

//--------------------------------------------------------------------------------------------------

@Observable open class ShapesUserInterface <ShapeTypesDescription : DocumentShapesDescriptionProtocol> : MenuCommands {

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
  //MARK: CanariBaseShape array
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private var mShapeArrayManager = ShapeArrayManager <ShapeTypesDescription> ()
  public var shapeCount : Int { self.mShapeArrayManager.count }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public subscript (shapeIndex inIndex : Int) -> CanariBaseShape <ShapeTypesDescription> {
    get { self.mShapeArrayManager [shapeIndex: inIndex] }
    set { self.mShapeArrayManager [shapeIndex: inIndex] = newValue }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  subscript (shapeID inID : UUID) -> (CanariBaseShape <ShapeTypesDescription>)? {
    get { self.mShapeArrayManager [shapeID: inID] }
    set { self.mShapeArrayManager [shapeID: inID] = newValue }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func removeLast () {
    self.mShapeArrayManager.removeLast ()
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var shapeArray : [CanariBaseShape <ShapeTypesDescription>] { self.mShapeArrayManager.shapeArray }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func contentsIsExactly (_ inWidgets : [CanariBaseShape <ShapeTypesDescription>]) -> Bool {
    if self.shapeCount != inWidgets.count {
      return false
    }else{
      for i in 0 ..< self.shapeCount {
        if self.mShapeArrayManager.shapeArray [i] != inWidgets [i] {
          return false
        }
      }
      return true
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func setShapes (_ inShapes : [CanariBaseShape <ShapeTypesDescription>]) {
    self.mShapeArrayManager.setShapes (inShapes)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func append (_ inNewObject : CanariBaseShape <ShapeTypesDescription>) {
    self.mShapeArrayManager.append (inNewObject)
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

  func selectedShapeArray () -> [CanariBaseShape <ShapeTypesDescription>] {
    var result = [CanariBaseShape <ShapeTypesDescription>] ()
    for shape in self.shapeArray {
      if self.selection.contains (shape.shape.id) {
        result.append (shape)
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
  private var mDragGestureState : (any MouseGestureProtocol<ShapeTypesDescription>)? = nil

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: append and set selection to added object
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func appendAndSetSelection (_ inNewObject : CanariBaseShape <ShapeTypesDescription>) {
    self.mShapeArrayManager.append (inNewObject)
    self.mSelection.removeAll ()
    self.mSelection.insert (inNewObject.shape.id)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Object Creator
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func setObjectCreator (_ inNewCreator : @escaping (MouseGestureGeometryContext) -> CanariBaseShape <ShapeTypesDescription>) {
    self.mObjectCreator = inNewCreator
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private var mObjectCreator : ((MouseGestureGeometryContext) -> CanariBaseShape <ShapeTypesDescription>)? = nil

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Draw
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func draw (context ioContext : inout GraphicsContext,
                    hoverUserLocationPoint inHoverUserLocationPoint : CanariPoint?,
                    scale inScale : Double) {
    enterTracing ("widgets.user.interface.draw") ; defer { exitTracing ("widgets.user.interface.draw") }
    ioContext.scale (by: inScale)
  //--- Draw widgets
    for shape in self.shapeArray {
      ioContext.translate (by: shape.orientedOrigin.mOrigin)
      ioContext.rotate (by: shape.orientedOrigin.mAngle)
      ioContext.scale (by: shape.orientedOrigin.mScale, horizontalFlip: shape.orientedOrigin.mHorizontalFlip)
      let scale = inScale * shape.orientedOrigin.mScale
      let hovered = shape.shape.id == self.mHoveredObject
      let selected = self.mSelection.contains (shape.shape.id)
      shape.orientedOrigin.withLocalOutline {
        self.drawShapesBackground (
          context: &ioContext,
          scale: scale,
          hovered: hovered,
          selected : selected,
          localOutline: $0
        )
      }
      shape.shape.drawShape (
        context: &ioContext,
        canvasScale: scale,
        hovered: hovered,
        selected: selected,
        groupLevel: 0
      )
      shape.orientedOrigin.withLocalOutline {
        self.drawShapesForeground (
          context: &ioContext,
          scale: scale,
          hovered: hovered,
          selected : selected,
          localOutline: $0
        )
      }
      ioContext.scale (by: 1.0 / shape.orientedOrigin.mScale, horizontalFlip: shape.orientedOrigin.mHorizontalFlip)
      ioContext.rotate (by: -shape.orientedOrigin.mAngle)
      ioContext.translate (by: -shape.orientedOrigin.mOrigin)
    }
  //--- Get alignment points
    var selectedObjetsAlignmentPoints = Set <CanariPoint> ()
    for shape in self.shapeArray {
      if self.mSelection.contains (shape.shape.id) {
        selectedObjetsAlignmentPoints.formUnion (shape.orientedOrigin.localToGlobal (shape.shape.localAlignmentGuidePoints))
      }
    }
  //--- Draw alignment guides
    for p in selectedObjetsAlignmentPoints {
      for shape in self.shapeArray {
        if !self.mSelection.contains (shape.shape.id) {
          for q in shape.orientedOrigin.localToGlobal (shape.shape.localAlignmentGuidePoints) {
            if p.x == q.x, p.y != q.y { // Vertical guide
              var path = CanariPath ()
              path.addMove (to: p)
              path.addLine (to: q)
              ioContext.stroke (path, with: .color (.orange), lineWidth: .px (1) / inScale)
            }else if p.y == q.y, p.x != q.x { // Horizontal guide
              var path = CanariPath ()
              path.addMove (to: p)
              path.addLine (to: q)
              ioContext.stroke (path, with: .color (.orange), lineWidth: .px (1) / inScale)
            }
          }
        }
      }
    }
  //--- Draw knobs
    for shape in self.shapeArray {
      if self.mSelection.contains (shape.shape.id), !shape.knobs.isEmpty {
        ioContext.translate (by: shape.orientedOrigin.mOrigin)
        ioContext.rotate (by: shape.orientedOrigin.mAngle)
        ioContext.scale (by: shape.orientedOrigin.mScale)
        for knob in shape.knobs {
          let inside : Bool
          if let p = inHoverUserLocationPoint {
            inside = knob.contains (
              localPoint: shape.orientedOrigin.globalToLocal (p),
              scale: inScale
            )
          }else{
            inside = false
          }
          knob.drawKnob (context: &ioContext, inside: inside, scale: inScale * shape.orientedOrigin.mScale)
        }
        ioContext.scale (by: 1.0 / shape.orientedOrigin.mScale)
        ioContext.rotate (by: -shape.orientedOrigin.mAngle)
        ioContext.translate (by: -shape.orientedOrigin.mOrigin)
      }
    }
    ioContext.scale (by: 1.0 / inScale)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  open func drawShapesBackground (context ioContext : inout GraphicsContext,
                                  scale inScale : Double,
                                  hovered inHovered : Bool,
                                  selected inSelected : Bool,
                                  localOutline inLocalOutline : CanariPath) {
   }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  open func drawShapesForeground (context ioContext : inout GraphicsContext,
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
    for shape in self.shapeArray.reversed () {
      if shape.orientedOrigin.localOutline (containsLocalPointForMouseGesture: shape.orientedOrigin.globalToLocal (inPoint)) {
        self.mHoveredObject = shape.shape.id
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
      var optionalNextState : (any MouseGestureProtocol <ShapeTypesDescription>)? = nil
      dragGestureState.onMouseDragged (
        geometry: inGeometry,
        beginOrContinueUndoGrouping: { self.beginOrContinueUndoGrouping () },
        userSelectionRectangle: &self.mSelectionUserRectangle,
        shapesManagerInterface: self,
        optionalNextState: &optionalNextState
      )
      if let nextState : any MouseGestureProtocol<ShapeTypesDescription> = optionalNextState {
        self.mDragGestureState = nextState
      }
    }else{ // Mouse down event
      enterTracing ("widgets.user.interface.mouse.down") ; defer { exitTracing ("widgets.user.interface.mouse.down") }
      self.mStartSelectionSet = self.mSelection
      let option = NSEvent.modifierFlags.contains (.option)
      if option {
        let state : any MouseGestureProtocol<ShapeTypesDescription> = self.mouseDownWithOptionKey (geometry: inGeometry)
        self.mDragGestureState = state
      }else{
        let state : any MouseGestureProtocol<ShapeTypesDescription> = self.mouseDownWithoutOptionKey (geometry: inGeometry)
        self.mDragGestureState = state
      }
    }
  }

 // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @MainActor private func mouseDownWithOptionKey (geometry inGeometry : MouseGestureGeometryContext) -> any MouseGestureProtocol<ShapeTypesDescription> {
  //--- Mouse down in a knob of a selected object ?
    for shape in self.shapeArray.reversed () {
      if self.mSelection.contains (shape.shape.id) {
        for knob in shape.knobs {
          if knob.contains (localPoint: shape.orientedOrigin.globalToLocal (inGeometry.unalignedUserStartLocation), scale: inGeometry.scale) {
            return MouseGesture_DragKnob <ShapeTypesDescription> (
              alignedCurrentPoint: inGeometry.alignedUserStartLocation,
              optionKeyInitiallyOn: true,
              shapeID: shape.shape.id,
              dragKnobAction: knob.dragKnobAction
            )
          }
        }
      }
    }

    var widgetUnderMouseID : UUID? = nil
    for shape in self.shapeArray.reversed () {
      if shape.orientedOrigin.localOutline (containsLocalPointForMouseGesture: shape.orientedOrigin.globalToLocal (inGeometry.unalignedUserStartLocation)) {
        widgetUnderMouseID = shape.shape.id
        break
      }
    }
    if let widgetID = widgetUnderMouseID {
      if self.mSelection.contains (widgetID) { // option-click on a selected shape
        let selectedArray = self.selectedShapeArray ()
        self.mSelection.removeAll ()
        for shape in selectedArray {
          if let newWidget = shape.shape.duplicated () {
            self.mShapeArrayManager.append (CanariBaseShape (shape.orientedOrigin, newWidget))
            self.mSelection.insert (newWidget.id)
          }
        }
        return MouseGesture_DragSelection <ShapeTypesDescription> (alignedCurrentPoint: inGeometry.alignedUserStartLocation)
      }else{ // option-click on a non-selected shape
        if let shape = self.mShapeArrayManager [shapeID: widgetID],
              let newWidget = shape.shape.duplicated () {
          self.mShapeArrayManager.append (CanariBaseShape (shape.orientedOrigin, newWidget))
          self.mSelection = [newWidget.id]
          return MouseGesture_DragSelection <ShapeTypesDescription> (alignedCurrentPoint: inGeometry.alignedUserStartLocation)
        }else{
          return MouseGesture_Inactive <ShapeTypesDescription> ()
        }
      }
    }else if let objectCreator = self.mObjectCreator {
      self.beginOrContinueUndoGrouping ()
      let shape = objectCreator (inGeometry)
      self.mShapeArrayManager.append (shape)
      self.mSelection = [shape.shape.id]
      return MouseGesture_Creation <ShapeTypesDescription> (objectCreator: objectCreator)
    }else{
      return MouseGesture_Inactive <ShapeTypesDescription> ()
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func mouseDownWithoutOptionKey (geometry inGeometry : MouseGestureGeometryContext) -> any MouseGestureProtocol <ShapeTypesDescription> {
    let control = NSEvent.modifierFlags.contains (.control)
    if control {
      return MouseGesture_Inactive <ShapeTypesDescription> ()
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

  private func mouseDown_shiftKey (geometry inGeometry : MouseGestureGeometryContext) -> any MouseGestureProtocol <ShapeTypesDescription> {
    var widgetUnderMouseID : UUID? = nil
    for shape in self.shapeArray.reversed () {
      if shape.orientedOrigin.localOutline (containsLocalPointForMouseGesture:shape.orientedOrigin.globalToLocal (inGeometry.unalignedUserStartLocation)) {
        widgetUnderMouseID = shape.shape.id
        break
      }
    }
    if let id = widgetUnderMouseID {
      if self.mSelection.contains (id) {
        self.mSelection.remove (id)
      }else{
        self.mSelection.insert (id)
      }
      return MouseGesture_Inactive <ShapeTypesDescription> ()
    }else{
      return MouseGesture_Inactive <ShapeTypesDescription> ()
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func mouseDown_noKey (geometry inGeometry : MouseGestureGeometryContext) -> any MouseGestureProtocol <ShapeTypesDescription> {
  //--- Mouse down in a knob of a selected object ?
    for shape in self.shapeArray.reversed () {
      if self.mSelection.contains (shape.shape.id) {
        for knob in shape.knobs {
          if knob.contains (localPoint: shape.orientedOrigin.globalToLocal (inGeometry.unalignedUserStartLocation), scale: inGeometry.scale) {
            return MouseGesture_DragKnob <ShapeTypesDescription> (
              alignedCurrentPoint: inGeometry.alignedUserStartLocation,
              optionKeyInitiallyOn: false,
              shapeID: shape.shape.id,
              dragKnobAction: knob.dragKnobAction
            )
          }
        }
      }
    }
  //--- Mouse down in a selected object ?
    for shape in self.shapeArray.reversed () {
      if self.mSelection.contains (shape.shape.id), shape.orientedOrigin.localOutline (containsLocalPointForMouseGesture:shape.orientedOrigin.globalToLocal (inGeometry.unalignedUserStartLocation)) {
        return MouseGesture_DragSelection <ShapeTypesDescription> (alignedCurrentPoint: inGeometry.alignedUserStartLocation)
      }
    }
  //--- Mouse down in a non selected object ?
    for shape in self.shapeArray.reversed () {
      let localPoint = shape.orientedOrigin.globalToLocal (inGeometry.unalignedUserStartLocation)
      if shape.orientedOrigin.localOutline (containsLocalPointForMouseGesture: localPoint) {
        self.mSelection = [shape.shape.id]
        return MouseGesture_DragSelection <ShapeTypesDescription> (alignedCurrentPoint: inGeometry.alignedUserStartLocation)
      }
    }
  //--- Mouse down out any selected object
    self.mSelection.removeAll ()
    return MouseGesture_SelectionRectangle <ShapeTypesDescription> (startSelectionSet: self.mSelection)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func contextualMenu (at inUnalignedPoint : CanariPoint, scale inScale : Double) -> any View {
  //--- CMD + Mouse down in a knob of a selected object ?
    for idx in (0 ..< self.mShapeArrayManager.count).reversed () {
      let shape = self.mShapeArrayManager [shapeIndex: idx]
      if self.mSelection.contains (shape.shape.id) {
        for knob in shape.knobs {
          if knob.contains (localPoint: shape.orientedOrigin.globalToLocal (inUnalignedPoint), scale: inScale) {
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
    for idx in (0 ..< self.mShapeArrayManager.count).reversed () {
      let shape = self.mShapeArrayManager [shapeIndex: idx]
      if self.mSelection.contains (shape.shape.id), shape.orientedOrigin.localOutline (containsLocalPointForMouseGesture: shape.orientedOrigin.globalToLocal (inUnalignedPoint)) {
        return shape.shape.contextualMenu (ContextualMenuExecutor (self, idx))
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
        shapesManagerInterface: self
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
      self.mDragGestureState = MouseGesture_Inactive <ShapeTypesDescription> ()
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func backDeleteKeyAction () {
    var idx = 0
    while idx < self.mShapeArrayManager.count {
      if self.mSelection.contains (self.mShapeArrayManager [shapeIndex: idx].shape.id) {
        self.mShapeArrayManager.remove (at: idx)
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
        while idx < self.shapeCount {
          if self.selection.contains (self [shapeIndex: idx].shape.id) {
            self [shapeIndex: idx].orientedOrigin.mOrigin += translation
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
        while idx < self.shapeCount {
          if self.selection.contains (self [shapeIndex: idx].shape.id) {
            self [shapeIndex: idx].orientedOrigin.mOrigin += translation
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
        while idx < self.shapeCount {
          if self.selection.contains (self [shapeIndex: idx].shape.id) {
            self [shapeIndex: idx].orientedOrigin.mOrigin += translation
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
        while idx < self.shapeCount {
          if self.selection.contains (self [shapeIndex: idx].shape.id) {
            self [shapeIndex: idx].orientedOrigin.mOrigin += translation
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
    let selectedProxies = self.selectedShapeArray ()
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
      if let decodedWidgets = try? decoder.decode ([CanariBaseShape <ShapeTypesDescription>].self, from: string.data (using: .utf8)!) {
        self.mSelection.removeAll ()
        for shape in decodedWidgets {
          self.mShapeArrayManager.append (shape)
          self.mSelection.insert (shape.shape.id)
        }
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public override var selectAllIsEnabled : Bool { !self.shapeArray.isEmpty }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public override func performSelectAll () {
    for shape in self.shapeArray {
      self.mSelection.insert (shape.shape.id)
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

 public  override var deleteIsEnabled : Bool { !self.shapeArray.isEmpty }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public override func performDelete () {
    let selection = self.mSelection
    self.mSelection.removeAll ()
    for shape in self.shapeArray {
      if selection.contains (shape.shape.id) {
        self.mShapeArrayManager.remove (id: shape.shape.id)
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
    && (ShapeTypesDescription.shapeTypeArray.first { $0.0 == CanariShape_Group <ShapeTypesDescription>.self } != nil)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public override func performGroup () {
    let selectedWidgets = self.selectedShapeArray ()
    let widgetGroup = CanariShape_Group <ShapeTypesDescription> (grouping: selectedWidgets)
    for shape in selectedWidgets {
      self.mShapeArrayManager.remove (id: shape.shape.id)
    }
    self.mShapeArrayManager.append (CanariBaseShape (CanariScaledOrientedOrigin (), widgetGroup))
    self.mSelection = [widgetGroup.id]
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public override var ungroupIsEnabled : Bool {
    for shape in self.shapeArray {
      if self.mSelection.contains (shape.shape.id), let w = shape.shape as? CanariShape_Group <ShapeTypesDescription>, w.mUnGroupIsEnabled {
        return true
      }
    }
    return false
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public override func performUngroup () {
    for shape in self.shapeArray {
      if self.mSelection.contains (shape.shape.id), let group = shape.shape as? CanariShape_Group <ShapeTypesDescription>, group.mUnGroupIsEnabled {
        let array = group.ungroupedArray (shape.orientedOrigin)
        self.mShapeArrayManager.replaceShape (withID: group.id, by: array)
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

  @MainActor @ViewBuilder public func inspectorViewForSelectedShapes () -> some View {
    if self.mSelection.isEmpty {
      Text ("Empty Selection").frame (maxHeight: .infinity).foregroundStyle (.secondary)
    }else{
      VStack (spacing: 1) {
        InspectorOfCanariScaledOrientedOrigin (shapesUserInterface: self)
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

  private func commonTypeForSelection () -> (any CanariShapeUIProtocol <ShapeTypesDescription>.Type)? {
    var result : (any CanariShapeUIProtocol <ShapeTypesDescription>.Type)? = nil
    for id in self.mSelection {
      if let shape = self.mShapeArrayManager [shapeID: id] {
        if let r = result {
          if r != type (of: shape.shape) {
            return nil
          }
        }else{
          result = type (of: shape.shape)
        }
      }
    }
    return result
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
