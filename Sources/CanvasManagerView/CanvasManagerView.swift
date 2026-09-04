//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 17/09/2025.
//--------------------------------------------------------------------------------------------------

import SwiftUI
import Combine

//--------------------------------------------------------------------------------------------------

fileprivate let BACK_DELETE_KEY_EQ = KeyEquivalent (Character (Unicode.Scalar (0x7F)!))
fileprivate let DEBUG_COLOR = Color.clear // red.opacity (0.15)
fileprivate let ANCHOR_FOR_INITIAL_SCROLL = "bottom.left.for.initial.scroll"

//--------------------------------------------------------------------------------------------------

public struct CanvasManagerView <ANCHOR : CanariShapeAnchorProtocol,
                                 DOCUMENT_SHAPES_DISPLAY_SETTINGS,
                                 SHAPE_TYPES_DESCRIPTION : DocumentShapesDescriptionProtocol> : View {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private let mContext : CanvasManagerViewContext
  private let mDocumentShapesDisplaySettings : DOCUMENT_SHAPES_DISPLAY_SETTINGS

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @State private var mVisibleUserRectangle = CanariRect ()
  @Binding private var mCenterOfVisibleRectUserLocation : CanariPoint
  @State private var mScrollPosition = CanariPoint.zero
  @Binding private var mAlignedHoverUserLocation : CanariPoint?
  @State private var mUnalignedHoverUserLocation : CanariPoint? = nil

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @Binding private var mCanvasScale : Double
  @State private var mTemporaryContentZoom : Double? = nil

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @State private var mShapesUserInterface : ShapesUserInterface <ANCHOR, DOCUMENT_SHAPES_DISPLAY_SETTINGS, SHAPE_TYPES_DESCRIPTION>
  @Environment(\.undoManager) private var undoManager

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (context inContext : CanvasManagerViewContext,
        canvasScale inScale : Binding <Double>,
        documentShapesDisplaySettings : DOCUMENT_SHAPES_DISPLAY_SETTINGS,
        shapesUserInterface : ShapesUserInterface <ANCHOR, DOCUMENT_SHAPES_DISPLAY_SETTINGS, SHAPE_TYPES_DESCRIPTION>,
        alignedHoverUserLocation inAlignedHoverUserLocation : Binding <CanariPoint?>,
        centerOfVisibleRectUserLocation inCenterOfVisibleRectUserLocation : Binding <CanariPoint>) {
    self._mCanvasScale = inScale
    self._mAlignedHoverUserLocation = inAlignedHoverUserLocation
    self.mContext = inContext
    self.mShapesUserInterface = shapesUserInterface
    self._mCenterOfVisibleRectUserLocation = inCenterOfVisibleRectUserLocation
    self.mDocumentShapesDisplaySettings = documentShapesDisplaySettings
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @ViewBuilder public var body : some View {
    HStack (spacing: 0) {
      ScrollViewReader { (readerProxy : ScrollViewProxy) in
        GeometryReader { (geometry : GeometryProxy) in
          ScrollView ([.horizontal, .vertical]) {
            VStack (spacing: 0.0) {
              self.topSpacer ()
              HStack (spacing: 0.0) {
                self.leftSpacer ()
                self.contentView (geometry).id (ANCHOR_FOR_INITIAL_SCROLL)
                .cuttable (for: CanariShapeRoot <ANCHOR, DOCUMENT_SHAPES_DISPLAY_SETTINGS, SHAPE_TYPES_DESCRIPTION>.self) {
                  let selection = self.mShapesUserInterface.selectedShapeArray ()
                  for shape in selection {
                    self.mShapesUserInterface.removeShape (id: shape.id)
                  }
                  return selection
                }
                .onDeleteCommand {
                  let selection = self.mShapesUserInterface.selectedShapeArray ()
                  for shape in selection {
                    self.mShapesUserInterface.removeShape (id: shape.id)
                  }
                }
                .deleteDisabled (self.mShapesUserInterface.selection.isEmpty)
                .copyable (self.mShapesUserInterface.selectedShapeArray())
                .pasteDestination (for: CanariShapeRoot <ANCHOR, DOCUMENT_SHAPES_DISPLAY_SETTINGS, SHAPE_TYPES_DESCRIPTION>.self) {
                  for var object in $0 {
                    object.mAnchor.addGlobalTranslation (CanariPoint (x: .cm (1), y: .cm (1)))
                    self.mShapesUserInterface.append (object)
                  }
                }
                .onCommand (#selector(NSResponder.selectAll(_:))) {
                  self.mShapesUserInterface.selectAll ()
                }
 //              .dropDestination (for: String.self, isEnabled: true) { items, dropSession in
  //                let p = self.unalignedUserPoint (geometry, fromLocationInContentView: dropSession.location)
  //                self.mDroppedStringsHandler? (items, p)
  //              }
  //              .onDrop (of: [.pdf, .svg], isTargeted: nil) { (providers : [NSItemProvider]) in
  //                for provider in providers {
  //                  let p = self.unalignedUserPoint (geometry, fromLocationInContentView: provider.containerFrame.origin)
  //                  self.mDroppedFilesHandler? (provider, p)
  //                }
  //                return true
  //              }
                .dropDestination (for: Data.self, isEnabled: true) { items, dropSession in
                  let p = self.unalignedUserPoint (geometry, fromLocationInContentView: dropSession.location)
                  self.mContext.droppedFilesHandler? (items, p)
                }
                self.rightSpacer ()
              }
             self.bottomSpacer ()
            }
          }
          .onScrollCanariPositionChange (self.$mScrollPosition, self.mCanvasScale)
          .onScrollGeometryChange (for: CGRect.self, of: \.visibleRect) { _, newVisibleRect in
            self.mVisibleUserRectangle = self.unalignedUserRectangle (geometry, newVisibleRect)
            self.mCenterOfVisibleRectUserLocation = self.mVisibleUserRectangle.center
          }
//          .onChange (of: self.mCanvasScale) {
//
//          }
          .overlay {
            self.rightVerticalRulerView (geometry)
            self.leftVerticalRulerView (geometry)
            self.topHorizontalRulerView (geometry)
            self.bottomHorizontalRulerView (geometry)
            self.topLeftCornerView ()
            self.topRightCornerView (geometry)
            self.bottomRightCornerView (geometry)
            self.bottomLeftCornerView (geometry)
          }
        }
        .defaultScrollAnchor (.topLeading) // Aligne le contenu en haut à gauche
        .onAppear { readerProxy.scrollTo (ANCHOR_FOR_INITIAL_SCROLL, anchor: .bottomLeading) }
      }
      .onAppear {
        self.mShapesUserInterface.setUndoManager (self.undoManager)
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Spacers
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func topSpacer () -> some View {
    let size = CanariSize (
      width: self.mContext.contentSizeWithMargins.width * self.mCanvasScale / 2.0,
      height: self.mContext.topHorizontalRulerHeight
    )
    return Rectangle ().fill (DEBUG_COLOR).frame (size: size)
//    return Spacer ().frame (size: size)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func bottomSpacer () -> some View {
    let size = CanariSize (
      width: self.mContext.contentSizeWithMargins.width * self.mCanvasScale / 2.0,
      height: self.mContext.bottomHorizontalRulerHeight
    )
    return Rectangle ().fill (DEBUG_COLOR).frame (size: size)
//    return Spacer ().frame (size: size)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func leftSpacer () -> some View {
    let size = CanariSize (
      width: self.mContext.leftVerticalRulerWidth,
      height: self.mContext.contentSizeWithMargins.height * self.mCanvasScale / 2.0
    )
//    return Spacer ().frame (size: size)
    return Rectangle ().fill (DEBUG_COLOR).frame (size: size)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func rightSpacer () -> some View {
    let size = CanariSize (
      width: self.mContext.rightVerticalRulerWidth,
      height: self.mContext.contentSizeWithMargins.height * self.mCanvasScale / 2.0
    )
//    return Spacer ().frame (size: size)
    return Rectangle ().fill (DEBUG_COLOR).frame (size: size)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Corner Views
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func topLeftCornerView () -> some View {
    let p = CanariPoint (
      x: self.mContext.leftVerticalRulerWidth / 2.0,
      y: self.mContext.topHorizontalRulerHeight / 2.0
    )
    return Rectangle ()
    .fill (self.mContext.rulerBackColor)
    .frame (width: self.mContext.leftVerticalRulerWidth, height: self.mContext.topHorizontalRulerHeight)
    .position (p: p)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func topRightCornerView (_ inGeometry : GeometryProxy) -> some View {
    let p = CanariPoint (
      x: inGeometry.availableWidth - self.mContext.rightVerticalRulerWidth / 2.0,
      y: self.mContext.topHorizontalRulerHeight / 2.0
    )
    let view = Rectangle ()
    .fill (self.mContext.rulerBackColor)
    .frame (width: self.mContext.rightVerticalRulerWidth, height: self.mContext.topHorizontalRulerHeight)
    .position (p: p)
    return view
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func bottomRightCornerView (_ inGeometry : GeometryProxy) -> some View {
    let x = inGeometry.availableWidth - self.mContext.rightVerticalRulerWidth / 2.0
    let y = inGeometry.availableHeight - self.mContext.bottomHorizontalRulerHeight / 2.0
    let view = Rectangle ()
    .fill (self.mContext.rulerBackColor)
    .frame (width: self.mContext.rightVerticalRulerWidth, height: self.mContext.bottomHorizontalRulerHeight)
    .position (x: x, y: y)
    return view
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func bottomLeftCornerView (_ inGeometry : GeometryProxy) -> some View {
    let x = self.mContext.leftVerticalRulerWidth / 2.0
    let y = inGeometry.availableHeight - self.mContext.bottomHorizontalRulerHeight / 2.0
    let view = Rectangle ()
    .fill (self.mContext.rulerBackColor)
    .frame (width: self.mContext.leftVerticalRulerWidth, height: self.mContext.bottomHorizontalRulerHeight)
    .position (x: x, y: y)
    return view
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Rulers
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func topHorizontalRulerView (_ inGeometry : GeometryProxy) -> some View {
    let rulerSize = CanariSize (
      width: inGeometry.availableWidth - self.mContext.leftVerticalRulerWidth - self.mContext.rightVerticalRulerWidth,
      height: self.mContext.topHorizontalRulerHeight
    )
    let rulerPosition = CanariPoint (
      x: self.mContext.leftVerticalRulerWidth + rulerSize.width / 2.0,
      y: self.mContext.topHorizontalRulerHeight / 2.0
    )
   let context = CanariHorizontalRulerViewContext (
      contentWidth: self.mContext.contentSizeWithMargins.width,
      visibleXmin: self.mVisibleUserRectangle.minX,
      visibleXmax: self.mVisibleUserRectangle.maxX,
      rulerSize: rulerSize,
      scale: self.mCanvasScale,
      hoverLocationX: self.mAlignedHoverUserLocation?.x,
      scrollX: self.mScrollPosition.x,
      originOffsetX: self.contentOverWidth (inGeometry) / 2.0,
      leftMargin: self.mContext.margins.left
    )
    return AnyView (self.mContext.topHorizontalRulerView (context))
    .frame (size: rulerSize)
    .position (p: rulerPosition)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func bottomHorizontalRulerView (_ inGeometry : GeometryProxy) -> some View {
    let rulerSize = CanariSize (
      width: inGeometry.availableWidth - self.mContext.leftVerticalRulerWidth - self.mContext.rightVerticalRulerWidth,
      height: self.mContext.bottomHorizontalRulerHeight
    )
    let rulerPosition = CanariPoint (
      x: self.mContext.leftVerticalRulerWidth + rulerSize.width / 2.0,
      y: inGeometry.availableHeight - self.mContext.bottomHorizontalRulerHeight / 2.0
    )
   let context = CanariHorizontalRulerViewContext (
      contentWidth: self.mContext.contentSizeWithMargins.width,
      visibleXmin: self.mVisibleUserRectangle.minX,
      visibleXmax: self.mVisibleUserRectangle.maxX,
      rulerSize: rulerSize,
      scale: self.mCanvasScale,
      hoverLocationX: self.mAlignedHoverUserLocation?.x,
      scrollX: self.mScrollPosition.x,
      originOffsetX: self.contentOverWidth (inGeometry) / 2.0,
      leftMargin: self.mContext.margins.left
    )
    return AnyView (self.mContext.bottomHorizontalRulerView (context))
      .frame (size: rulerSize)
      .position (p: rulerPosition)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func leftVerticalRulerView (_ inGeometry : GeometryProxy) -> some View {
    let rulerSize = CanariSize (
      width: self.mContext.leftVerticalRulerWidth,
      height: inGeometry.availableHeight - self.mContext.topHorizontalRulerHeight - self.mContext.bottomHorizontalRulerHeight
    )
    let rulerPosition = CanariPoint (
      x: self.mContext.leftVerticalRulerWidth / 2.0,
      y: self.mContext.topHorizontalRulerHeight + rulerSize.height / 2.0
    )
   let context = CanariVerticalRulerViewContext (
      contentHeight: self.mContext.contentSizeWithMargins.height,
      visibleYmin: self.mVisibleUserRectangle.minY,
      visibleYmax: self.mVisibleUserRectangle.maxY,
      rulerSize: rulerSize,
      scale: self.mCanvasScale,
      hoverLocationY: self.mAlignedHoverUserLocation?.y,
      scrollY: self.mScrollPosition.y,
      originOffsetY: self.contentOverHeight (inGeometry) / 2.0,
      bottomMargin: self.mContext.margins.bottom
    )
    return AnyView (self.mContext.leftVerticalRulerView (context))
      .frame (size: rulerSize)
      .position (p: rulerPosition)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func rightVerticalRulerView (_ inGeometry : GeometryProxy) -> some View {
    let rulerSize = CanariSize (
      width: self.mContext.rightVerticalRulerWidth,
      height: inGeometry.availableHeight - self.mContext.topHorizontalRulerHeight - self.mContext.bottomHorizontalRulerHeight
    )
    let rulerPosition = CanariPoint (
      x: inGeometry.availableWidth - self.mContext.rightVerticalRulerWidth / 2.0,
      y: self.mContext.topHorizontalRulerHeight + rulerSize.height / 2.0
    )
   let context = CanariVerticalRulerViewContext (
      contentHeight: self.mContext.contentSizeWithMargins.height,
      visibleYmin: self.mVisibleUserRectangle.minY,
      visibleYmax: self.mVisibleUserRectangle.maxY,
      rulerSize: rulerSize,
      scale: self.mCanvasScale,
      hoverLocationY: self.mAlignedHoverUserLocation?.y,
      scrollY: self.mScrollPosition.y,
      originOffsetY: self.contentOverHeight (inGeometry) / 2.0,
      bottomMargin: self.mContext.margins.bottom
    )
    return AnyView (self.mContext.rightVerticalRulerView (context))
    .frame (size: rulerSize)
    .position (p: rulerPosition)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Content View
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func contentView (_ inGeometry : GeometryProxy) -> some View {
    ZStack {
      let contentSizeWithMargins = CanariSize (
        width: self.mContext.contentSizeWithMargins.width + self.contentOverWidth (inGeometry) / self.mCanvasScale,
        height: self.mContext.contentSizeWithMargins.height + self.contentOverHeight (inGeometry) / self.mCanvasScale
      )
      let backgroundViewContext = BackgroundViewContext (
        contentSizeWithMargins: contentSizeWithMargins,
        canvasScale: self.mCanvasScale,
        overWidth: self.contentOverWidth (inGeometry),
        overHeight: self.contentOverHeight (inGeometry),
        margins: actualMargins (inGeometry)
      )
      if let backgroundView = self.mContext.backgroundView {
        AnyView (backgroundView (backgroundViewContext))
      }
      Canvas { (context, size) in
    //--- ATTENTION ! Il y a un bug dans SwiftUI, on ne peut pas appliquer un y négatif à scaleEffect,
    //    il en suit un comportement imprévisible dans un Canvas. Il faut faire la symétrie en y ici.
        context.translateBy (
          x: self.mContext.margins.left * self.mCanvasScale + self.contentOverWidth (inGeometry) / 2.0,
          y: .pt (size.height) - self.mContext.margins.bottom * self.mCanvasScale - self.contentOverHeight (inGeometry) / 2.0
        )
        context.scaleBy (x: 1.0, y: -1.0)
      //--- BackGround
        context.scaleBy (x: self.mCanvasScale, y: self.mCanvasScale)
        self.mContext.drawCanvasBackGround (&context)
        context.scaleBy (x: 1.0 / self.mCanvasScale, y: 1.0 / self.mCanvasScale)
      //--- Shapes
        self.mShapesUserInterface.drawShapes (
          context: &context,
          documentShapeDisplaySettings: self.mDocumentShapesDisplaySettings,
          hoverUserLocationPoint: self.mUnalignedHoverUserLocation,
          canvasScale: self.mCanvasScale
        )
      //--- Overlay
        context.scaleBy (x: self.mCanvasScale, y: self.mCanvasScale)
        self.mContext.drawCanvasOverlay (&context)
        context.scaleBy (x: 1.0 / self.mCanvasScale, y: 1.0 / self.mCanvasScale)
      }
    }
  //--- Observing modifier key changing
//      .onModifierKeysChanged (mask: [.control, .shift]) { (oldValue, newValue) in
//        self.controlKeyChanged ()
//      }
  //--- Mouse Hover
    .onContinuousHover { phase in self.continuousHoverTracking (inGeometry, phase) }
  //--- Context menu
 //   .contextMenu { self.editorContextualMenu () }
  //--- Mouse down / dragging tracking
    .gesture (DragGesture (minimumDistance: 0) // 0 : nécessaire pour détecter un mouseDown
      .onChanged { dragGestureValue in self.mouseDownOrMouseDragged (inGeometry, dragGestureValue) }
      .onEnded { dragGestureValue in self.mShapesUserInterface.mouseDraggedEnded () }
    )
  //--- Indispensable pour Key Press et focusedValue
    .focusable ()
  //--- Key Press
  // ATTENTION : il faut exécuter les actions de manière asynchrone, dans le main thread
    .onKeyPress (BACK_DELETE_KEY_EQ, phases: .down) { _ in return self.backDeleteKeyAction () }
    .onKeyPress (.rightArrow, phases: [.down, .repeat]) { _ in return self.rightArrowKeyAction () }
    .onKeyPress (.leftArrow, phases: [.down, .repeat]) { _ in return self.leftArrowKeyAction () }
    .onKeyPress (.upArrow, phases: [.down, .repeat]) { _ in return self.upArrowKeyAction () }
    .onKeyPress (.downArrow, phases: [.down, .repeat]) { _ in return self.downArrowKeyAction () }
    .onKeyPress (.escape, phases: [.down]) { _ in return self.escapeKeyAction () }
  //--- Pasteboard commands
    .focusedValue (\.menuCommands, self.mShapesUserInterface)
  //--- Magnify Gesture
  // https://stackoverflow.com/questions/70934112/swiftui-magnificationgesture-not-working-properly-on-mac
    .contentShape (Rectangle ()) // Indispensable pour que le MagnifyGesture réponde
    .gesture (
      MagnifyGesture ()
      .onChanged { value in self.magnifyGestureChanged (value) }
      .onEnded { _ in self.mTemporaryContentZoom = nil }
    )
  //--- Fixer la dimension de la vue
    .frame (
      width: self.mContext.contentSizeWithMargins.width * self.mCanvasScale + self.contentOverWidth (inGeometry),
      height: self.mContext.contentSizeWithMargins.height * self.mCanvasScale + self.contentOverHeight (inGeometry)
    )
    .overlay { self.userSelectionRectangleDisplay (inGeometry) }
  //--- ATTENTION ! Il y a un bug dans SwiftUI, on ne peut pas appliquer un y négatif à scaleEffect,
  //    il en suit un comportement imprévisible dans un Canvas.
  // NE PAS FAIRE .scaleEffect (x: 1.0, y: -1.0, anchor: .center)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func magnifyGestureChanged (_ inValue : MagnifyGesture.Value) {
    let newZoom : Double
    if let lastContentZoom = self.mTemporaryContentZoom {
      newZoom = lastContentZoom * inValue.magnification
    }else{
      self.mTemporaryContentZoom = self.mCanvasScale
      newZoom = self.mCanvasScale * inValue.magnification
    }
    self.mCanvasScale = min (max (newZoom, Double (self.mContext.zoomValues [0]) / 100.0), Double (self.mContext.zoomValues.last!) / 100.0)
  //--- Recalculer la nouvelle position semble très compliqué… Le plus simple est de suprimer
  //    le marquage
    self.mAlignedHoverUserLocation = nil
    self.mUnalignedHoverUserLocation = nil
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Hover tracking
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func continuousHoverTracking (_ inGeometry : GeometryProxy, _ inPhase : HoverPhase) {
    switch inPhase {
    case .active (let location) :
      let p = self.alignedUserPoint (inGeometry, fromLocationInContentView: location)
      self.mAlignedHoverUserLocation = p
      self.mShapesUserInterface.hoverTracking (at: p)
      self.mUnalignedHoverUserLocation = self.unalignedUserPoint (inGeometry, fromLocationInContentView: location)
    case .ended :
      self.mAlignedHoverUserLocation = nil
      self.mUnalignedHoverUserLocation = nil
      self.mShapesUserInterface.hoverTrackingEnded ()
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Contextual menu
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @ViewBuilder private func editorContextualMenu () -> some View {
    if let p = self.mUnalignedHoverUserLocation {
      AnyView (self.mShapesUserInterface.contextualMenu (at: p, scale: self.mCanvasScale))
    }else{
      EmptyView ()
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Mouse Down
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func mouseDownOrMouseDragged (_ inGeometry : GeometryProxy,
                                        _ inDragGestureValue : DragGesture.Value) {
    let unalignedStart = self.unalignedUserPoint (
      inGeometry,
      fromLocationInContentView: inDragGestureValue.startLocation
    )
    let alignedStart = unalignedStart.aligning (to: self.mContext.magneticGrid)
    let unalignedCurrent = self.unalignedUserPoint (
      inGeometry,
      fromLocationInContentView: inDragGestureValue.location
    )
    let alignedCurrent = unalignedCurrent.aligning (to: self.mContext.magneticGrid)
    self.mAlignedHoverUserLocation = alignedCurrent
    self.mUnalignedHoverUserLocation = unalignedCurrent
    let geometry = MouseGestureGeometryContext (
      unalignedUserStartLocation: unalignedStart,
      alignedUserStartLocation: alignedStart,
      unalignedUserCurrentLocation: unalignedCurrent,
      alignedUserCurrentLocation: alignedCurrent,
      scale: self.mCanvasScale,
      contentSize: self.mContext.contentSizeWithMargins,
      canvasSize: self.mContext.canvasSize
    )
    self.mAlignedHoverUserLocation = alignedCurrent
    self.mShapesUserInterface.mouseDownOrMouseDragged (geometry: geometry)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

//  @ViewBuilder private func hoveredUserLocationDisplay () -> some View {
//    if let pt = self.mAlignedHoverUserLocation {
//      Canvas { context, size in
//        let r = CGRect (origin: .zero, size: size)
//        let p = Path (roundedRect: r, cornerRadius: 8.0)
//        context.fill (p, with: .color (.yellow))
//        context.draw (
//          Text ("x: \(pt.x.cmValue.str2f) cm, y: \(pt.y.cmValue.str2f) cm").font (.system (size: 12.0)).bold (),
//          at: CGPoint (x: size.width / 2.0, y: size.height / 2.0),
//        )
//      }
//      .frame (width: 160, height: 24)
//      .position (x: 80, y: 12)
//    }
//  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @ViewBuilder private func userSelectionRectangleDisplay (_ inGeometry : GeometryProxy) -> some View {
    if let r = self.mShapesUserInterface.selectionUserRectangle, !r.isEmpty {
      Rectangle ()
      .fill (.gray.opacity (0.2))
      .stroke (.gray, lineWidth: 1.0)
      .frame (width: r.width * self.mCanvasScale, height: r.height * self.mCanvasScale)
      .position (
        x: (r.midX + self.mContext.margins.left) * self.mCanvasScale + self.contentOverWidth (inGeometry) / 2.0,
        y: (self.mContext.contentSizeWithMargins.height - r.midY - self.mContext.margins.bottom) * self.mCanvasScale + self.contentOverHeight (inGeometry) / 2.0
      )
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Key actions
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  nonisolated private func escapeKeyAction () -> KeyPress.Result {
    Task { @MainActor in
      self.mShapesUserInterface.escapeKeyAction ()
    }
    return .handled
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  nonisolated private func backDeleteKeyAction () -> KeyPress.Result {
    Task { @MainActor in
      self.mShapesUserInterface.backDeleteKeyAction ()
    }
    return .handled
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  nonisolated private func rightArrowKeyAction () -> KeyPress.Result {
    Task { @MainActor in
      self.mShapesUserInterface.rightArrowKeyAction (magneticGrid: self.mContext.magneticGrid, self.mContext.canvasSize)
    }
    return .handled
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  nonisolated private func leftArrowKeyAction () -> KeyPress.Result {
    Task { @MainActor in
      self.mShapesUserInterface.leftArrowKeyAction (magneticGrid: self.mContext.magneticGrid, self.mContext.canvasSize)
    }
    return .handled
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  nonisolated private func upArrowKeyAction () -> KeyPress.Result {
    Task { @MainActor in
      self.mShapesUserInterface.upArrowKeyAction (magneticGrid: self.mContext.magneticGrid, self.mContext.canvasSize)
    }
    return .handled
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  nonisolated private func downArrowKeyAction () -> KeyPress.Result {
    Task { @MainActor in
      self.mShapesUserInterface.downArrowKeyAction (magneticGrid: self.mContext.magneticGrid, self.mContext.canvasSize)
    }
    return .handled
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Utilities
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func contentOverWidth (_ inGeometry : GeometryProxy) -> CanariLength {
    let availableWidth = inGeometry.availableWidth - self.mContext.leftVerticalRulerWidth - self.mContext.rightVerticalRulerWidth
    let overwidth = availableWidth - self.mContext.contentSizeWithMargins.width * self.mCanvasScale
    return max (overwidth, .zero)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func contentOverHeight (_ inGeometry : GeometryProxy) -> CanariLength {
    let availableHeight = inGeometry.availableHeight - self.mContext.topHorizontalRulerHeight - self.mContext.bottomHorizontalRulerHeight
    let overHeight = availableHeight - self.mContext.contentSizeWithMargins.height * self.mCanvasScale
    return max (overHeight, .zero)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func actualMargins (_ inGeometry : GeometryProxy) -> CanvasMargins {
    CanvasMargins (
      left: self.mContext.margins.left + self.contentOverWidth (inGeometry) / (2.0 * self.mCanvasScale),
      bottom: self.mContext.margins.bottom + self.contentOverHeight (inGeometry) / (2.0 * self.mCanvasScale),
      right: self.mContext.margins.right + self.contentOverWidth (inGeometry) / (2.0 * self.mCanvasScale),
      top: self.mContext.margins.top + self.contentOverHeight (inGeometry) / (2.0 * self.mCanvasScale)
    )
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Point User Location
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func alignedUserPoint (_ inGeometry : GeometryProxy,
                                 fromLocationInContentView inLocation : NSPoint) -> CanariPoint {
    return self.unalignedUserPoint (inGeometry, fromLocationInContentView: inLocation)
               .aligning (to: self.mContext.magneticGrid)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func unalignedUserPoint (_ inGeometry : GeometryProxy,
                                   fromLocationInContentView inLocation : NSPoint) -> CanariPoint {
    let point = CanariPoint (
      x: (.pt (inLocation.x) - self.contentOverWidth (inGeometry) / 2.0) / self.mCanvasScale - self.mContext.margins.left,
      y: self.mContext.contentSizeWithMargins.height - self.mContext.margins.bottom + (self.contentOverHeight (inGeometry) / 2.0 - .pt (inLocation.y)) / self.mCanvasScale
    )
    return point
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func unalignedUserRectangle (_ inGeometry : GeometryProxy,
                                       _ inRect : NSRect) -> CanariRect {
    let left = (.pt (inRect.minX) - self.contentOverWidth (inGeometry) / 2.0) / self.mCanvasScale - self.mContext.margins.left
    let top = self.mContext.contentSizeWithMargins.height - self.mContext.margins.top + (self.contentOverHeight (inGeometry) / 2.0 - .pt (inRect.minY)) / self.mCanvasScale
    let width  = (.pt (inRect.width) - self.mContext.leftVerticalRulerWidth - self.mContext.rightVerticalRulerWidth) / self.mCanvasScale
    let height = (.pt (inRect.height) - self.mContext.topHorizontalRulerHeight  - self.mContext.bottomHorizontalRulerHeight) / self.mCanvasScale
    let r = CanariRect (left: left, bottom: top - height, width: width, height: height)
    return r
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
