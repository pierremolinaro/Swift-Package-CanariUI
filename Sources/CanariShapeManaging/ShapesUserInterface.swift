//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 21/02/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI
import Combine

//--------------------------------------------------------------------------------------------------

@Observable open class ShapesUserInterface <SHAPE_TYPES_DESCRIPTION : DocumentShapesDescriptionProtocol> : MenuCommands {

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
  //MARK: CanariShapeRoot array
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private var mShapeArrayManager = ShapeArrayManager <SHAPE_TYPES_DESCRIPTION> ()
  public var shapeCount : Int { self.mShapeArrayManager.count }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public subscript (shapeIndex inIndex : Int) -> CanariShapeRoot <SHAPE_TYPES_DESCRIPTION> {
    get { self.mShapeArrayManager [shapeIndex: inIndex] }
    set { self.mShapeArrayManager [shapeIndex: inIndex] = newValue }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  subscript (shapeID inID : UUID) -> (CanariShapeRoot <SHAPE_TYPES_DESCRIPTION>)? {
    get { self.mShapeArrayManager [shapeID: inID] }
    set { self.mShapeArrayManager [shapeID: inID] = newValue }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func removeLast () {
    self.mShapeArrayManager.removeLast ()
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var shapeArray : [CanariShapeRoot <SHAPE_TYPES_DESCRIPTION>] { self.mShapeArrayManager.shapeArray }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func contentsIsExactly (_ inShapes : [CanariShapeRoot <SHAPE_TYPES_DESCRIPTION>]) -> Bool {
    if self.shapeCount != inShapes.count {
      return false
    }else{
      for i in 0 ..< self.shapeCount {
        if self.mShapeArrayManager.shapeArray [i] != inShapes [i] {
          return false
        }
      }
      return true
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func setShapes (_ inShapes : [CanariShapeRoot <SHAPE_TYPES_DESCRIPTION>]) {
    self.mShapeArrayManager.setShapes (inShapes)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func append (_ inNewObject : CanariShapeRoot <SHAPE_TYPES_DESCRIPTION>) {
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

  func selectedShapeArray () -> [CanariShapeRoot <SHAPE_TYPES_DESCRIPTION>] {
    var result = [CanariShapeRoot <SHAPE_TYPES_DESCRIPTION>] ()
    for shape in self.shapeArray {
      if self.selection.contains (shape.id) {
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
  private var mDragGestureState : (any MouseGestureProtocol<SHAPE_TYPES_DESCRIPTION>)? = nil

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: append and set selection to added object
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func appendAndSetSelection (_ inNewObject : CanariShapeRoot <SHAPE_TYPES_DESCRIPTION>) {
    self.mShapeArrayManager.append (inNewObject)
    self.mSelection.removeAll ()
    self.mSelection.insert (inNewObject.id)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Object Creator
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func setObjectCreator (_ inNewCreator : @escaping (MouseGestureGeometryContext) -> CanariShapeRoot <SHAPE_TYPES_DESCRIPTION>) {
    self.mObjectCreator = inNewCreator
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private var mObjectCreator : ((MouseGestureGeometryContext) -> CanariShapeRoot <SHAPE_TYPES_DESCRIPTION>)? = nil

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Draw
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func draw (context ioContext : inout GraphicsContext,
                    hoverUserLocationPoint inHoverUserLocationPoint : CanariPoint?,
                    scale inScale : Double) {
    enterTracing ("shapes.user.interface.draw") ; defer { exitTracing ("shapes.user.interface.draw") }
    ioContext.scale (by: inScale)
  //--- Draw shapes
    for shape in self.shapeArray {
      ioContext.translate (by: shape.mOrigin.mPoint)
      ioContext.rotate (by: shape.mOrigin.mAngle)
      ioContext.scale (by: shape.mOrigin.mScale, horizontalFlip: shape.mOrigin.mHorizontalFlip)
      let scale = inScale * shape.mOrigin.mScale
      let hovered = shape.id == self.mHoveredObject
      let selected = self.mSelection.contains (shape.id)
      shape.mOrigin.withLocalOutline {
        self.drawShapesBackground (
          context: &ioContext,
          scale: scale,
          hovered: hovered,
          selected : selected,
          localOutline: $0
        )
      }
      shape.mDecoration.drawShape (
        context: &ioContext,
        canvasScale: scale,
        hovered: hovered,
        selected: selected,
        groupLevel: 0
      )
      shape.mOrigin.withLocalOutline {
        self.drawShapesForeground (
          context: &ioContext,
          scale: scale,
          hovered: hovered,
          selected : selected,
          localOutline: $0
        )
      }
      ioContext.scale (by: 1.0 / shape.mOrigin.mScale, horizontalFlip: shape.mOrigin.mHorizontalFlip)
      ioContext.rotate (by: -shape.mOrigin.mAngle)
      ioContext.translate (by: -shape.mOrigin.mPoint)
    }
  //--- Get alignment points
    var selectedObjetsAlignmentPoints = Set <CanariPoint> ()
    for shape in self.shapeArray {
      if self.mSelection.contains (shape.id) {
        selectedObjetsAlignmentPoints.formUnion (shape.mOrigin.localToGlobal (shape.mDecoration.localAlignmentGuidePoints))
      }
    }
  //--- Draw alignment guides
    for p in selectedObjetsAlignmentPoints {
      for shape in self.shapeArray {
        if !self.mSelection.contains (shape.id) {
          for q in shape.mOrigin.localToGlobal (shape.mDecoration.localAlignmentGuidePoints) {
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
      if self.mSelection.contains (shape.id), !shape.knobs.isEmpty {
        ioContext.translate (by: shape.mOrigin.mPoint)
        ioContext.rotate (by: shape.mOrigin.mAngle)
        ioContext.scale (by: shape.mOrigin.mScale)
        for knob in shape.knobs {
          let inside : Bool
          if let p = inHoverUserLocationPoint {
            inside = knob.contains (
              localPoint: shape.mOrigin.globalToLocal (p),
              scale: inScale
            )
          }else{
            inside = false
          }
          knob.drawKnob (context: &ioContext, inside: inside, scale: inScale * shape.mOrigin.mScale)
        }
        ioContext.scale (by: 1.0 / shape.mOrigin.mScale)
        ioContext.rotate (by: -shape.mOrigin.mAngle)
        ioContext.translate (by: -shape.mOrigin.mPoint)
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
    enterTracing ("shapes.user.interface.hover.tracking") ; defer { exitTracing ("shapes.user.interface.hover.tracking") }
    for shape in self.shapeArray.reversed () {
      if shape.mOrigin.localOutline (containsLocalPointForMouseGesture: shape.mOrigin.globalToLocal (inPoint)) {
        self.mHoveredObject = shape.id
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
      enterTracing ("shapes.user.interface.mouse.dragging") ; defer { exitTracing ("shapes.user.interface.mouse.dragging") }
      var optionalNextState : (any MouseGestureProtocol <SHAPE_TYPES_DESCRIPTION>)? = nil
      dragGestureState.onMouseDragged (
        geometry: inGeometry,
        beginOrContinueUndoGrouping: { self.beginOrContinueUndoGrouping () },
        userSelectionRectangle: &self.mSelectionUserRectangle,
        shapesManagerInterface: self,
        optionalNextState: &optionalNextState
      )
      if let nextState : any MouseGestureProtocol<SHAPE_TYPES_DESCRIPTION> = optionalNextState {
        self.mDragGestureState = nextState
      }
    }else{ // Mouse down event
      enterTracing ("shapes.user.interface.mouse.down") ; defer { exitTracing ("shapes.user.interface.mouse.down") }
      self.mStartSelectionSet = self.mSelection
      let option = NSEvent.modifierFlags.contains (.option)
      if option {
        let state : any MouseGestureProtocol<SHAPE_TYPES_DESCRIPTION> = self.mouseDownWithOptionKey (geometry: inGeometry)
        self.mDragGestureState = state
      }else{
        let state : any MouseGestureProtocol<SHAPE_TYPES_DESCRIPTION> = self.mouseDownWithoutOptionKey (geometry: inGeometry)
        self.mDragGestureState = state
      }
    }
  }

 // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @MainActor private func mouseDownWithOptionKey (geometry inGeometry : MouseGestureGeometryContext) -> any MouseGestureProtocol<SHAPE_TYPES_DESCRIPTION> {
  //--- Mouse down in a knob of a selected object ?
    for shape in self.shapeArray.reversed () {
      if self.mSelection.contains (shape.id) {
        for knob in shape.knobs {
          if knob.contains (localPoint: shape.mOrigin.globalToLocal (inGeometry.unalignedUserStartLocation), scale: inGeometry.scale) {
            return MouseGesture_DragKnob <SHAPE_TYPES_DESCRIPTION> (
              alignedCurrentPoint: inGeometry.alignedUserStartLocation,
              optionKeyInitiallyOn: true,
              shapeID: shape.id,
              dragKnobAction: knob.dragKnobAction
            )
          }
        }
      }
    }

    var widgetUnderMouseID : UUID? = nil
    for shape in self.shapeArray.reversed () {
      if shape.mOrigin.localOutline (containsLocalPointForMouseGesture: shape.mOrigin.globalToLocal (inGeometry.unalignedUserStartLocation)) {
        widgetUnderMouseID = shape.id
        break
      }
    }
    if let widgetID = widgetUnderMouseID {
      if self.mSelection.contains (widgetID) { // option-click on a selected shape
        let selectedArray = self.selectedShapeArray ()
        self.mSelection.removeAll ()
        for shape in selectedArray {
          if let newDecoration = shape.mDecoration.duplicated () {
            let newShape = CanariShapeRoot (shape.mOrigin, newDecoration)
            self.mShapeArrayManager.append (newShape)
            self.mSelection.insert (newShape.id)
          }
        }
        return MouseGesture_DragSelection <SHAPE_TYPES_DESCRIPTION> (alignedCurrentPoint: inGeometry.alignedUserStartLocation)
      }else{ // option-click on a non-selected shape
        if let shape = self.mShapeArrayManager [shapeID: widgetID],
              let newDecoration = shape.mDecoration.duplicated () {
          let newShape = CanariShapeRoot (shape.mOrigin, newDecoration)
          self.mShapeArrayManager.append (newShape)
          self.mSelection = [newShape.id]
          return MouseGesture_DragSelection <SHAPE_TYPES_DESCRIPTION> (alignedCurrentPoint: inGeometry.alignedUserStartLocation)
        }else{
          return MouseGesture_Inactive <SHAPE_TYPES_DESCRIPTION> ()
        }
      }
    }else if let objectCreator = self.mObjectCreator {
      self.beginOrContinueUndoGrouping ()
      let shape = objectCreator (inGeometry)
      self.mShapeArrayManager.append (shape)
      self.mSelection = [shape.id]
      return MouseGesture_Creation <SHAPE_TYPES_DESCRIPTION> (objectCreator: objectCreator)
    }else{
      return MouseGesture_Inactive <SHAPE_TYPES_DESCRIPTION> ()
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func mouseDownWithoutOptionKey (geometry inGeometry : MouseGestureGeometryContext) -> any MouseGestureProtocol <SHAPE_TYPES_DESCRIPTION> {
    let control = NSEvent.modifierFlags.contains (.control)
    if control {
      return MouseGesture_Inactive <SHAPE_TYPES_DESCRIPTION> ()
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

  private func mouseDown_shiftKey (geometry inGeometry : MouseGestureGeometryContext) -> any MouseGestureProtocol <SHAPE_TYPES_DESCRIPTION> {
    var widgetUnderMouseID : UUID? = nil
    for shape in self.shapeArray.reversed () {
      if shape.mOrigin.localOutline (containsLocalPointForMouseGesture:shape.mOrigin.globalToLocal (inGeometry.unalignedUserStartLocation)) {
        widgetUnderMouseID = shape.id
        break
      }
    }
    if let id = widgetUnderMouseID {
      if self.mSelection.contains (id) {
        self.mSelection.remove (id)
      }else{
        self.mSelection.insert (id)
      }
      return MouseGesture_Inactive <SHAPE_TYPES_DESCRIPTION> ()
    }else{
      return MouseGesture_Inactive <SHAPE_TYPES_DESCRIPTION> ()
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func mouseDown_noKey (geometry inGeometry : MouseGestureGeometryContext) -> any MouseGestureProtocol <SHAPE_TYPES_DESCRIPTION> {
  //--- Mouse down in a knob of a selected object ?
    for shape in self.shapeArray.reversed () {
      if self.mSelection.contains (shape.id) {
        for knob in shape.knobs {
          if knob.contains (localPoint: shape.mOrigin.globalToLocal (inGeometry.unalignedUserStartLocation), scale: inGeometry.scale) {
            return MouseGesture_DragKnob <SHAPE_TYPES_DESCRIPTION> (
              alignedCurrentPoint: inGeometry.alignedUserStartLocation,
              optionKeyInitiallyOn: false,
              shapeID: shape.id,
              dragKnobAction: knob.dragKnobAction
            )
          }
        }
      }
    }
  //--- Mouse down in a selected object ?
    for shape in self.shapeArray.reversed () {
      if self.mSelection.contains (shape.id), shape.mOrigin.localOutline (containsLocalPointForMouseGesture:shape.mOrigin.globalToLocal (inGeometry.unalignedUserStartLocation)) {
        return MouseGesture_DragSelection <SHAPE_TYPES_DESCRIPTION> (alignedCurrentPoint: inGeometry.alignedUserStartLocation)
      }
    }
  //--- Mouse down in a non selected object ?
    for shape in self.shapeArray.reversed () {
      let localPoint = shape.mOrigin.globalToLocal (inGeometry.unalignedUserStartLocation)
      if shape.mOrigin.localOutline (containsLocalPointForMouseGesture: localPoint) {
        self.mSelection = [shape.id]
        return MouseGesture_DragSelection <SHAPE_TYPES_DESCRIPTION> (alignedCurrentPoint: inGeometry.alignedUserStartLocation)
      }
    }
  //--- Mouse down out any selected object
    self.mSelection.removeAll ()
    return MouseGesture_SelectionRectangle <SHAPE_TYPES_DESCRIPTION> (startSelectionSet: self.mSelection)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func contextualMenu (at inUnalignedPoint : CanariPoint, scale inScale : Double) -> any View {
  //--- CMD + Mouse down in a knob of a selected object ?
    for idx in (0 ..< self.mShapeArrayManager.count).reversed () {
      let shape = self.mShapeArrayManager [shapeIndex: idx]
      if self.mSelection.contains (shape.id) {
        for knob in shape.knobs {
          if knob.contains (localPoint: shape.mOrigin.globalToLocal (inUnalignedPoint), scale: inScale) {
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
      if self.mSelection.contains (shape.id), shape.mOrigin.localOutline (containsLocalPointForMouseGesture: shape.mOrigin.globalToLocal (inUnalignedPoint)) {
        return shape.mDecoration.contextualMenu (ContextualMenuExecutor (self, idx))
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
      self.mDragGestureState = MouseGesture_Inactive <SHAPE_TYPES_DESCRIPTION> ()
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func backDeleteKeyAction () {
    var idx = 0
    while idx < self.mShapeArrayManager.count {
      if self.mSelection.contains (self.mShapeArrayManager [shapeIndex: idx].id) {
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
          if self.selection.contains (self [shapeIndex: idx].id) {
            self [shapeIndex: idx].mOrigin.mPoint += translation
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
          if self.selection.contains (self [shapeIndex: idx].id) {
            self [shapeIndex: idx].mOrigin.mPoint += translation
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
          if self.selection.contains (self [shapeIndex: idx].id) {
            self [shapeIndex: idx].mOrigin.mPoint += translation
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
          if self.selection.contains (self [shapeIndex: idx].id) {
            self [shapeIndex: idx].mOrigin.mPoint += translation
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
      if let decodedShapes = try? decoder.decode ([CanariShapeRoot <SHAPE_TYPES_DESCRIPTION>].self, from: string.data (using: .utf8)!) {
        self.mSelection.removeAll ()
        for shape in decodedShapes {
          self.mShapeArrayManager.append (shape)
          self.mSelection.insert (shape.id)
        }
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public override var selectAllIsEnabled : Bool { !self.shapeArray.isEmpty }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public override func performSelectAll () {
    for shape in self.shapeArray {
      self.mSelection.insert (shape.id)
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

 public  override var deleteIsEnabled : Bool { !self.shapeArray.isEmpty }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public override func performDelete () {
    let selection = self.mSelection
    self.mSelection.removeAll ()
    for shape in self.shapeArray {
      if selection.contains (shape.id) {
        self.mShapeArrayManager.remove (id: shape.id)
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
    && (SHAPE_TYPES_DESCRIPTION.shapeTypeArray.first { $0.0 == CanariShape_Group <SHAPE_TYPES_DESCRIPTION>.self } != nil)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public override func performGroup () {
    let selectedShapes = self.selectedShapeArray ()
    let shapeGroup = CanariShape_Group <SHAPE_TYPES_DESCRIPTION> (grouping: selectedShapes)
    for shape in selectedShapes {
      self.mShapeArrayManager.remove (id: shape.id)
    }
    let newShape = CanariShapeRoot (CanariScaledOrientedOrigin (), shapeGroup)
    self.mShapeArrayManager.append (newShape)
    self.mSelection = [newShape.id]
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public override var ungroupIsEnabled : Bool {
    for shape in self.shapeArray {
      if self.mSelection.contains (shape.id),
            let w = shape.mDecoration as? CanariShape_Group <SHAPE_TYPES_DESCRIPTION>,
            w.mUnGroupIsEnabled {
        return true
      }
    }
    return false
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public override func performUngroup () {
    for shape in self.shapeArray {
      if self.mSelection.contains (shape.id),
          let group = shape.mDecoration as? CanariShape_Group <SHAPE_TYPES_DESCRIPTION>,
          group.mUnGroupIsEnabled {
        let array = group.ungroupedArray (shape.mOrigin)
        self.mShapeArrayManager.replaceShape (withID: shape.id, by: array)
        self.mSelection.remove (shape.id)
        for p in array {
          self.mSelection.insert (p.id)
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

  private func commonTypeForSelection () -> (any CanariShapeDecorationProtocol <SHAPE_TYPES_DESCRIPTION>.Type)? {
    var result : (any CanariShapeDecorationProtocol <SHAPE_TYPES_DESCRIPTION>.Type)? = nil
    for id in self.mSelection {
      if let shape = self.mShapeArrayManager [shapeID: id] {
        if let r = result {
          if r != type (of: shape.mDecoration) {
            return nil
          }
        }else{
          result = type (of: shape.mDecoration)
        }
      }
    }
    return result
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
