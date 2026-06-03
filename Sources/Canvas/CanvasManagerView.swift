//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 17/09/2025.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

fileprivate let BACK_DELETE_KEY_EQ = KeyEquivalent (Character (Unicode.Scalar (0x7F)!))
fileprivate let PASTEBOARD_TYPE = NSPasteboard.PasteboardType (rawValue: Bundle.main.bundleIdentifier! + ".widgets")
fileprivate let DEBUG_COLOR = Color.clear // red.opacity (0.15)

//--------------------------------------------------------------------------------------------------

public struct CanvasManagerView <TypeDictionary : WidgetTypeArrayProtocol, DropType : Transferable> : View {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private let mBackgroundViewBuilder : (BackgroundViewContext) -> any View
  private let mTopHorizontalRulerViewBuilder : (HorizontalRulerViewContext) -> any View
  private let mLeftVerticalRulerViewBuilder : (VerticalRulerViewContext) -> any View
  private let mBottomHorizontalRulerViewBuilder : (HorizontalRulerViewContext) -> any View
  private let mRightVerticalRulerViewBuilder : (VerticalRulerViewContext) -> any View
  private let mContext : CanvasManagerViewContext
  private let mContentSizeWithMargins : CanariSize
  private let mDroppedFileHandler : (([DropType], CanariPoint) -> Void)?

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @State private var mScrollPosition = CanariPoint.zero
  @Binding private var mAlignedHoverUserLocation : CanariPoint?
  @State private var mUnalignedHoverUserLocation : CanariPoint? = nil

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @Binding private var mContentZoom : Double
  @State private var mTemporaryContentZoom : Double? = nil

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @State private var mWidgetsUserInterface : WidgetsUserInterface <TypeDictionary>
  @Environment(\.undoManager) private var undoManager

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (context inContext : CanvasManagerViewContext,
        contentZoom inZoom : Binding <Double>,
        alignedHoverUserLocation inAlignedHoverUserLocation : Binding <CanariPoint?>,
        widgetsUserInterface inWidgetsUserInterface : WidgetsUserInterface <TypeDictionary>,
        backgroundViewBuilder inBackgroundViewBuilder : @escaping (BackgroundViewContext) -> any View,
        leftVerticalRulerViewBuilder inLeftVerticalRulerViewBuilder : @escaping (VerticalRulerViewContext) -> any View,
        topHorizontalRulerViewBuilder inTopHorizontalRulerViewBuilder : @escaping (HorizontalRulerViewContext) -> any View,
        rightVerticalRulerViewBuilder inRightVerticalRulerViewBuilder : @escaping (VerticalRulerViewContext) -> any View,
        bottomHorizontalRulerViewBuilder inBottomHorizontalRulerViewBuilder : @escaping (HorizontalRulerViewContext) -> any View,
        droppedFileHandler inDroppedFileHandler : (([DropType], CanariPoint) -> Void)?) {
    self._mContentZoom = inZoom
    self._mAlignedHoverUserLocation = inAlignedHoverUserLocation
    self.mContext = inContext
    self.mWidgetsUserInterface = inWidgetsUserInterface
    self.mDroppedFileHandler = inDroppedFileHandler
    self.mContentSizeWithMargins = CanariSize (
      width: inContext.contentSize.width + inContext.margins.left + inContext.margins.right,
      height: inContext.contentSize.height + inContext.margins.top + inContext.margins.bottom
    )
    self.mBackgroundViewBuilder = inBackgroundViewBuilder
    self.mLeftVerticalRulerViewBuilder = inLeftVerticalRulerViewBuilder
    self.mRightVerticalRulerViewBuilder = inRightVerticalRulerViewBuilder
    self.mBottomHorizontalRulerViewBuilder = inBottomHorizontalRulerViewBuilder
    self.mTopHorizontalRulerViewBuilder = inTopHorizontalRulerViewBuilder
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @ViewBuilder public var body : some View {
    GeometryReader { geometry in
      ScrollView ([.horizontal, .vertical]) {
        VStack (spacing: 0.0) {
          self.topSpacer ()
          HStack (spacing: 0.0) {
            self.leftSpacer ()
            self.contentView (geometry)
            self.rightSpacer ()
          }
          self.bottomSpacer ()
        }
        .dropDestination (for: DropType.self) { items, location in
          let p = self.unalignedUserPoint (geometry, fromLocationInContentView: location)
          self.mDroppedFileHandler? (items, p)
          return true
        }
      }
      .onScrollPositionChange (self.$mScrollPosition, self.mContentZoom)
      .defaultScrollAnchor (.topLeading) // Aligne le contenu en haut à gauche
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
 //     .onChange (of: geometry) { }
    }
//    .overlay { self.hoveredUserLocationDisplay () }
    .onAppear {
      self.mWidgetsUserInterface.setUndoManager (self.undoManager)
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Spacers
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func topSpacer () -> some View {
    let size = CanariSize (
      width: self.mContentSizeWithMargins.width * self.mContentZoom / 2.0,
      height: self.mContext.rulerDescriptor.topHorizontalRulerHeight
    )
    return Rectangle ().fill (DEBUG_COLOR).frame (size: size)
//    return Spacer ().frame (size: size)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func bottomSpacer () -> some View {
    let size = CanariSize (
      width: self.mContentSizeWithMargins.width * self.mContentZoom / 2.0,
      height: self.mContext.rulerDescriptor.bottomHorizontalRulerHeight
    )
    return Rectangle ().fill (DEBUG_COLOR).frame (size: size)
//    return Spacer ().frame (size: size)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func leftSpacer () -> some View {
    let size = CanariSize (
      width: self.mContext.rulerDescriptor.leftVerticalRulerWidth,
      height: self.mContentSizeWithMargins.height * self.mContentZoom / 2.0
    )
//    return Spacer ().frame (size: size)
    return Rectangle ().fill (DEBUG_COLOR).frame (size: size)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func rightSpacer () -> some View {
    let size = CanariSize (
      width: self.mContext.rulerDescriptor.rightVerticalRulerWidth,
      height: self.mContentSizeWithMargins.height * self.mContentZoom / 2.0
    )
//    return Spacer ().frame (size: size)
    return Rectangle ().fill (DEBUG_COLOR).frame (size: size)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Corner Views
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func topLeftCornerView () -> some View {
    let p = CanariPoint (
      x: self.mContext.rulerDescriptor.leftVerticalRulerWidth / 2.0,
      y: self.mContext.rulerDescriptor.topHorizontalRulerHeight / 2.0
    )
    return Rectangle ()
    .fill (self.mContext.rulerBackColor)
    .frame (width: self.mContext.rulerDescriptor.leftVerticalRulerWidth, height: self.mContext.rulerDescriptor.topHorizontalRulerHeight)
    .position (p: p)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func topRightCornerView (_ inGeometry : GeometryProxy) -> some View {
    let p = CanariPoint (
      x: inGeometry.availableWidth - self.mContext.rulerDescriptor.rightVerticalRulerWidth / 2.0,
      y: self.mContext.rulerDescriptor.topHorizontalRulerHeight / 2.0
    )
    let view = Rectangle ()
    .fill (self.mContext.rulerBackColor)
    .frame (width: self.mContext.rulerDescriptor.rightVerticalRulerWidth, height: self.mContext.rulerDescriptor.topHorizontalRulerHeight)
    .position (p: p)
    return view
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func bottomRightCornerView (_ inGeometry : GeometryProxy) -> some View {
    let x = inGeometry.availableWidth - self.mContext.rulerDescriptor.rightVerticalRulerWidth / 2.0
    let y = inGeometry.availableHeight - self.mContext.rulerDescriptor.bottomHorizontalRulerHeight / 2.0
    let view = Rectangle ()
    .fill (self.mContext.rulerBackColor)
    .frame (width: self.mContext.rulerDescriptor.rightVerticalRulerWidth, height: self.mContext.rulerDescriptor.bottomHorizontalRulerHeight)
    .position (x: x, y: y)
    return view
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func bottomLeftCornerView (_ inGeometry : GeometryProxy) -> some View {
    let x = self.mContext.rulerDescriptor.leftVerticalRulerWidth / 2.0
    let y = inGeometry.availableHeight - self.mContext.rulerDescriptor.bottomHorizontalRulerHeight / 2.0
    let view = Rectangle ()
    .fill (self.mContext.rulerBackColor)
    .frame (width: self.mContext.rulerDescriptor.leftVerticalRulerWidth, height: self.mContext.rulerDescriptor.bottomHorizontalRulerHeight)
    .position (x: x, y: y)
    return view
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Rulers
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func topHorizontalRulerView (_ inGeometry : GeometryProxy) -> some View {
    let rulerSize = CanariSize (
      width: inGeometry.availableWidth - self.mContext.rulerDescriptor.leftVerticalRulerWidth - self.mContext.rulerDescriptor.rightVerticalRulerWidth,
      height: self.mContext.rulerDescriptor.topHorizontalRulerHeight
    )
    let rulerPosition = CanariPoint (
      x: self.mContext.rulerDescriptor.leftVerticalRulerWidth + rulerSize.width / 2.0,
      y: self.mContext.rulerDescriptor.topHorizontalRulerHeight / 2.0
    )
   let context = HorizontalRulerViewContext (
      contentWidth: self.mContentSizeWithMargins.width,
      rulerSize: rulerSize,
      zoom: self.mContentZoom,
      hoverLocationX: self.mAlignedHoverUserLocation?.x,
      scrollX: self.mScrollPosition.x,
      originOffsetX: self.contentOverWidth (inGeometry) / 2.0,
      leftMargin: self.mContext.margins.left
    )
    return AnyView (self.mTopHorizontalRulerViewBuilder (context))
    .frame (size: rulerSize)
    .position (p: rulerPosition)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func bottomHorizontalRulerView (_ inGeometry : GeometryProxy) -> some View {
    let rulerSize = CanariSize (
      width: inGeometry.availableWidth - self.mContext.rulerDescriptor.leftVerticalRulerWidth - self.mContext.rulerDescriptor.rightVerticalRulerWidth,
      height: self.mContext.rulerDescriptor.bottomHorizontalRulerHeight
    )
    let rulerPosition = CanariPoint (
      x: self.mContext.rulerDescriptor.leftVerticalRulerWidth + rulerSize.width / 2.0,
      y: inGeometry.availableHeight - self.mContext.rulerDescriptor.bottomHorizontalRulerHeight / 2.0
    )
   let context = HorizontalRulerViewContext (
      contentWidth: self.mContentSizeWithMargins.width,
      rulerSize: rulerSize,
      zoom: self.mContentZoom,
      hoverLocationX: self.mAlignedHoverUserLocation?.x,
      scrollX: self.mScrollPosition.x,
      originOffsetX: self.contentOverWidth (inGeometry) / 2.0,
      leftMargin: self.mContext.margins.left
    )
    return AnyView (self.mBottomHorizontalRulerViewBuilder (context))
      .frame (size: rulerSize)
      .position (p: rulerPosition)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func leftVerticalRulerView (_ inGeometry : GeometryProxy) -> some View {
    let rulerSize = CanariSize (
      width: self.mContext.rulerDescriptor.leftVerticalRulerWidth,
      height: inGeometry.availableHeight - self.mContext.rulerDescriptor.topHorizontalRulerHeight - self.mContext.rulerDescriptor.bottomHorizontalRulerHeight
    )
    let rulerPosition = CanariPoint (
      x: self.mContext.rulerDescriptor.leftVerticalRulerWidth / 2.0,
      y: self.mContext.rulerDescriptor.topHorizontalRulerHeight + rulerSize.height / 2.0
    )
   let context = VerticalRulerViewContext (
      contentHeight: self.mContentSizeWithMargins.height,
      rulerSize: rulerSize,
      zoom: self.mContentZoom,
      hoverLocationY: self.mAlignedHoverUserLocation?.y,
      scrollY: self.mScrollPosition.y,
      originOffsetY: self.contentOverHeight (inGeometry) / 2.0,
      bottomMargin: self.mContext.margins.bottom
    )
    return AnyView (self.mLeftVerticalRulerViewBuilder (context))
    .frame (size: rulerSize)
    .position (p: rulerPosition)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func rightVerticalRulerView (_ inGeometry : GeometryProxy) -> some View {
    let rulerSize = CanariSize (
      width: self.mContext.rulerDescriptor.rightVerticalRulerWidth,
      height: inGeometry.availableHeight - self.mContext.rulerDescriptor.topHorizontalRulerHeight - self.mContext.rulerDescriptor.bottomHorizontalRulerHeight
    )
    let rulerPosition = CanariPoint (
      x: inGeometry.availableWidth - self.mContext.rulerDescriptor.rightVerticalRulerWidth / 2.0,
      y: self.mContext.rulerDescriptor.topHorizontalRulerHeight + rulerSize.height / 2.0
    )
   let context = VerticalRulerViewContext (
      contentHeight: self.mContentSizeWithMargins.height,
      rulerSize: rulerSize,
      zoom: self.mContentZoom,
      hoverLocationY: self.mAlignedHoverUserLocation?.y,
      scrollY: self.mScrollPosition.y,
      originOffsetY: self.contentOverHeight (inGeometry) / 2.0,
      bottomMargin: self.mContext.margins.bottom
    )
    return AnyView (self.mRightVerticalRulerViewBuilder (context))
    .frame (size: rulerSize)
    .position (p: rulerPosition)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Content View
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func contentView (_ inGeometry : GeometryProxy) -> some View {
    ZStack {
      let contentSizeWithMargins = CanariSize (
        width: self.mContentSizeWithMargins.width + self.contentOverWidth (inGeometry) / self.mContentZoom,
        height: self.mContentSizeWithMargins.height + self.contentOverHeight (inGeometry) / self.mContentZoom
      )
      let backgroundViewContext = BackgroundViewContext (
        contentSizeWithMargins: contentSizeWithMargins,
        contentZoom: self.mContentZoom,
        overWidth: self.contentOverWidth (inGeometry),
        overHeight: self.contentOverHeight (inGeometry),
        margins: actualMargins (inGeometry)
      )
      AnyView (self.mBackgroundViewBuilder (backgroundViewContext))
      Canvas { (context, size) in
//        self.mUserLocationComputations.mGeometryAvailableWidth = inGeometry.availableWidth
//        self.mUserLocationComputations.mGeometryAvailableHeight = inGeometry.availableHeight
    //--- ATTENTION ! Il y a un bug dans SwiftUI, on ne peut pas appliquer un y négatif à scaleEffect,
    //    il en suit un comportement imprévisible dans un Canvas. Il faut faire la symétrie en y ici.
        context.translateBy (
          x: self.mContext.margins.left * self.mContentZoom + self.contentOverWidth (inGeometry) / 2.0,
          y: .px (size.height) - self.mContext.margins.bottom * self.mContentZoom - self.contentOverHeight (inGeometry) / 2.0
        )
        context.scaleBy (x: 1.0, y: -1.0)
        self.mWidgetsUserInterface.draw (context: &context, zoom: self.mContentZoom)
      }
    }
  //--- Observing modifier key changing
//      .onModifierKeysChanged (mask: [.control, .shift]) { (oldValue, newValue) in
//        self.controlKeyChanged ()
//      }
  //--- Mouse Hover
    .onContinuousHover { phase in self.continuousHoverTracking (inGeometry, phase) }
  //--- Context menu
    .contextMenu { self.editorContextualMenu () }
  //--- Mouse down / dragging tracking
    .gesture (DragGesture (minimumDistance: 0) // 0 : nécessaire pour détecter un mouseDown
      .onChanged { dragGestureValue in self.mouseDownOrMouseDragged (inGeometry, dragGestureValue) }
      .onEnded { dragGestureValue in self.mWidgetsUserInterface.mouseDraggedEnded () }
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
    .focusedValue (\.menuCommands, self.mWidgetsUserInterface)
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
      width: self.mContentSizeWithMargins.width * self.mContentZoom + self.contentOverWidth (inGeometry),
      height: self.mContentSizeWithMargins.height * self.mContentZoom + self.contentOverHeight (inGeometry)
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
      self.mTemporaryContentZoom = self.mContentZoom
      newZoom = self.mContentZoom * inValue.magnification
    }
    self.mContentZoom = min (max (newZoom, Double (self.mContext.zoomValues [0]) / 100.0), Double (self.mContext.zoomValues.last!) / 100.0)
  //  self.mUserLocationComputations.mZoom = self.mContentZoom
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
      self.mWidgetsUserInterface.hoverTracking (at: p)
      self.mUnalignedHoverUserLocation = self.unalignedUserPoint (inGeometry, fromLocationInContentView: location)
    case .ended :
      self.mAlignedHoverUserLocation = nil
      self.mUnalignedHoverUserLocation = nil
      self.mWidgetsUserInterface.hoverTrackingEnded ()
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Contextual menu
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @ViewBuilder private func editorContextualMenu () -> some View {
    if let p = self.mUnalignedHoverUserLocation {
      AnyView (self.mWidgetsUserInterface.contextualMenu (at: p, zoom: self.mContentZoom))
    }else{
      EmptyView ()
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Mouse Down
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func mouseDownOrMouseDragged (_ inGeometry : GeometryProxy, _ inDragGestureValue : DragGesture.Value) {
    let unalignedStart = self.unalignedUserPoint (inGeometry, fromLocationInContentView: inDragGestureValue.startLocation)
    let alignedStart = unalignedStart.aligning (to: self.mContext.magneticGrid)
    let unalignedCurrent = self.unalignedUserPoint (inGeometry, fromLocationInContentView: inDragGestureValue.location)
    let alignedCurrent = unalignedCurrent.aligning (to: self.mContext.magneticGrid)
    let geometry = MouseGestureGeometryContext (
      unalignedUserStartLocation: unalignedStart,
      alignedUserStartLocation: alignedStart,
      unalignedUserCurrentLocation: unalignedCurrent,
      alignedUserCurrentLocation: alignedCurrent,
      zoom: self.mContentZoom,
      contentSize: self.mContentSizeWithMargins
    )
    self.mAlignedHoverUserLocation = alignedCurrent
    self.mWidgetsUserInterface.mouseDownOrMouseDragged (geometry: geometry)
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
    if let r = self.mWidgetsUserInterface.selectionUserRectangle, !r.isEmpty {
      Rectangle ()
      .fill (.gray.opacity (0.2))
      .stroke (.gray, lineWidth: 1.0)
      .frame (width: r.width * self.mContentZoom, height: r.height * self.mContentZoom)
      .position (
        x: (r.midX + self.mContext.margins.left) * self.mContentZoom + self.contentOverWidth (inGeometry) / 2.0,
        y: (self.mContentSizeWithMargins.height - r.midY - self.mContext.margins.bottom) * self.mContentZoom + self.contentOverHeight (inGeometry) / 2.0
      )
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Key actions
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func escapeKeyAction () -> KeyPress.Result {
    DispatchQueue.main.async {
      self.mWidgetsUserInterface.escapeKeyAction ()
    }
    return .handled
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func backDeleteKeyAction () -> KeyPress.Result {
    DispatchQueue.main.async {
      self.mWidgetsUserInterface.backDeleteKeyAction ()
    }
    return .handled
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func rightArrowKeyAction () -> KeyPress.Result {
    DispatchQueue.main.async {
      self.mWidgetsUserInterface.rightArrowKeyAction (magneticGrid: self.mContext.magneticGrid)
    }
    return .handled
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func leftArrowKeyAction () -> KeyPress.Result {
    DispatchQueue.main.async {
      self.mWidgetsUserInterface.leftArrowKeyAction (magneticGrid: self.mContext.magneticGrid)
    }
    return .handled
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func upArrowKeyAction () -> KeyPress.Result {
    DispatchQueue.main.async {
      self.mWidgetsUserInterface.upArrowKeyAction (magneticGrid: self.mContext.magneticGrid)
    }
    return .handled
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func downArrowKeyAction () -> KeyPress.Result {
    DispatchQueue.main.async {
      self.mWidgetsUserInterface.downArrowKeyAction (magneticGrid: self.mContext.magneticGrid)
    }
    return .handled
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Utilities
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func contentOverWidth (_ inGeometry : GeometryProxy) -> CanariLength {
    let availableWidth = inGeometry.availableWidth - self.mContext.rulerDescriptor.leftVerticalRulerWidth - self.mContext.rulerDescriptor.rightVerticalRulerWidth
    let overwidth = availableWidth - self.mContentSizeWithMargins.width * self.mContentZoom
    return max (overwidth, .zero)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func contentOverHeight (_ inGeometry : GeometryProxy) -> CanariLength {
    let availableHeight = inGeometry.availableHeight - self.mContext.rulerDescriptor.topHorizontalRulerHeight - self.mContext.rulerDescriptor.bottomHorizontalRulerHeight
    let overHeight = availableHeight - self.mContentSizeWithMargins.height * self.mContentZoom
    return max (overHeight, .zero)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func actualMargins (_ inGeometry : GeometryProxy) -> CanvasMargins {
    CanvasMargins (
      left: self.mContext.margins.left + self.contentOverWidth (inGeometry) / (2.0 * self.mContentZoom),
      bottom: self.mContext.margins.bottom + self.contentOverHeight (inGeometry) / (2.0 * self.mContentZoom),
      right: self.mContext.margins.right + self.contentOverWidth (inGeometry) / (2.0 * self.mContentZoom),
      top: self.mContext.margins.top + self.contentOverHeight (inGeometry) / (2.0 * self.mContentZoom)
    )
  }

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
      x: (.px (inLocation.x) - self.contentOverWidth (inGeometry) / 2.0) / self.mContentZoom - self.mContext.margins.left,
      y: self.mContentSizeWithMargins.height - self.mContext.margins.bottom + (self.contentOverHeight (inGeometry) / 2.0 - .px (inLocation.y)) / self.mContentZoom
    )
    return point
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
