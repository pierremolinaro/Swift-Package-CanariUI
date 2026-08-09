//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 27/02/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI
import UniformTypeIdentifiers

//--------------------------------------------------------------------------------------------------

public struct CanariGroupShape <ANCHOR : CanariShapeAnchorProtocol,
                                DOCUMENT_SHAPES_DISPLAY_SETTINGS,
                                SHAPE_TYPES_DESCRIPTION : DocumentShapesDescriptionProtocol> : CanariShapeDecorationProtocol {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var localOutlinePath : CanariPath {
    var result = CanariPath ()
    for shape in self.mArray {
      shape.mAnchor.withGlobalOutline { result.unionInPlaceUsingNonZeroRule ($0) }
    }
    return result
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  var mUnGroupIsEnabled : Bool
  public let mArray : [CanariShapeRoot <ANCHOR, DOCUMENT_SHAPES_DISPLAY_SETTINGS, SHAPE_TYPES_DESCRIPTION>] // at 0: back, at count - 1: front

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var count : Int { self.mArray.count }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  init (zeroCenteredShapeArray inShapeArray : [CanariShapeRoot <ANCHOR, DOCUMENT_SHAPES_DISPLAY_SETTINGS, SHAPE_TYPES_DESCRIPTION>]) {
    self.mUnGroupIsEnabled = true
    self.mArray = inShapeArray
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Encoding, Decoding
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private enum CodingKeys : String, CodingKey { case array, unGroupIsEnabled }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (from inDecoder : Decoder) throws {
    let container = try inDecoder.container (keyedBy: CodingKeys.self)
    self.mArray = try container.decode ([CanariShapeRoot <ANCHOR, DOCUMENT_SHAPES_DISPLAY_SETTINGS, SHAPE_TYPES_DESCRIPTION>].self, forKey: .array)
    self.mUnGroupIsEnabled = try container.decode (Bool.self, forKey: .unGroupIsEnabled)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func encode (to inEncoder : Encoder) throws {
    var container = inEncoder.container (keyedBy: CodingKeys.self)
    try container.encode (self.mArray, forKey: .array)
    try container.encode (self.mUnGroupIsEnabled, forKey: .unGroupIsEnabled)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var shapeKnobs : [ShapeKnob <ANCHOR, DOCUMENT_SHAPES_DISPLAY_SETTINGS, SHAPE_TYPES_DESCRIPTION>] { [] }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func contextualMenu (_ inExecutor : ContextualMenuExecutor <ANCHOR, DOCUMENT_SHAPES_DISPLAY_SETTINGS, SHAPE_TYPES_DESCRIPTION>) -> any View { EmptyView () }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func isEqual (to inOther : any CanariShapeDecorationProtocol <ANCHOR, DOCUMENT_SHAPES_DISPLAY_SETTINGS, SHAPE_TYPES_DESCRIPTION>) -> Bool {
    if let other = inOther as? CanariGroupShape <ANCHOR, DOCUMENT_SHAPES_DISPLAY_SETTINGS, SHAPE_TYPES_DESCRIPTION> {
      return (self.mUnGroupIsEnabled == other.mUnGroupIsEnabled)
          && (self.mArray == other.mArray)
    }else{
      return false
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: duplicated
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func duplicated () -> (any CanariShapeDecorationProtocol <ANCHOR, DOCUMENT_SHAPES_DISPLAY_SETTINGS, SHAPE_TYPES_DESCRIPTION>)? {
    CanariGroupShape (self.mUnGroupIsEnabled, self.mArray)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private init (_ inUnGroupIsEnabled : Bool,
                _ inArray : [CanariShapeRoot <ANCHOR, DOCUMENT_SHAPES_DISPLAY_SETTINGS, SHAPE_TYPES_DESCRIPTION>]) {
    self.mUnGroupIsEnabled = inUnGroupIsEnabled
    self.mArray = inArray
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: isGraphicallyEmpty
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var isGraphicallyEmpty : Bool { self.mArray.isEmpty }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Draw
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func drawShape (context ioContext : inout GraphicsContext,
                         anchor inAnchor : ANCHOR,
                         documentShapeDisplaySettings inDisplaySettings : DOCUMENT_SHAPES_DISPLAY_SETTINGS,
                         drawingScale inDrawingScale : Double,
                         hovered inHovered : Bool,
                         selected inSelected : Bool,
                         groupLevel inGroupLevel : UInt) {
    for shape in self.mArray {
      shape.mAnchor.withLocalCoordinates (
        context: &ioContext,
        drawingScale: inDrawingScale
      ) { context, decorationDrawingScale in
        shape.mDecoration.drawShape (
          context: &context,
          anchor: shape.mAnchor,
          documentShapeDisplaySettings: inDisplaySettings,
          drawingScale: decorationDrawingScale,
          hovered: inHovered,
          selected: inSelected,
          groupLevel: inGroupLevel
        )
      }
    }
    if inSelected || inHovered, inGroupLevel == 0 {
      inAnchor.withLocalBoundingRect {
        ioContext.stroke (
          CanariPath (rect: $0),
          with: .color (.black), lineWidth: .px (0.5) / inDrawingScale
        )
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: AlignmentGuidePoints
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var localAlignmentGuidePoints : [CanariPoint] {
    var points = [CanariPoint] ()
    for shape in self.mArray {
      points += shape.mDecoration.localAlignmentGuidePoints
    }
    return points
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: ungrouped array
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func ungroupedArray (_ inGroupAnchor : ANCHOR) -> [CanariShapeRoot <ANCHOR, DOCUMENT_SHAPES_DISPLAY_SETTINGS, SHAPE_TYPES_DESCRIPTION>] {
    self.mArray.map {
      var anchor = $0.mAnchor
      anchor.transformToGlobal (inGroupAnchor)
      return CanariShapeRoot (anchor, $0.mDecoration)
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: inspectorView
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public static var inspectorTitle : String { "Group" }

  public static func inspectorView (proxy inProxy : CanariInspectorProxy <ANCHOR, DOCUMENT_SHAPES_DISPLAY_SETTINGS, SHAPE_TYPES_DESCRIPTION>) -> any View {
    GroupShapeInspectorView <ANCHOR, DOCUMENT_SHAPES_DISPLAY_SETTINGS, SHAPE_TYPES_DESCRIPTION> (proxy: inProxy)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------

fileprivate struct GroupShapeInspectorView <ANCHOR : CanariShapeAnchorProtocol,
                                            DOCUMENT_SHAPES_DISPLAY_SETTINGS,
                                            SHAPE_TYPES_DESCRIPTION : DocumentShapesDescriptionProtocol> : View {

  typealias T = CanariGroupShape <ANCHOR, DOCUMENT_SHAPES_DISPLAY_SETTINGS, SHAPE_TYPES_DESCRIPTION>

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @State private var mProxy : CanariInspectorProxy <ANCHOR, DOCUMENT_SHAPES_DISPLAY_SETTINGS, SHAPE_TYPES_DESCRIPTION>
  @AppStorage("group.ungrouping.inspector.is.expanded") private var mUngroupInspectorIsExpanded = false

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  init (proxy inProxy : CanariInspectorProxy <ANCHOR, DOCUMENT_SHAPES_DISPLAY_SETTINGS, SHAPE_TYPES_DESCRIPTION>) {
    self.mProxy = inProxy
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  var body : some View {
    CanariExpandableInspectorView (
      title: "Ungrouping",
      isExpanded: self.$mUngroupInspectorIsExpanded
    ) {
      HStack {
        Text ("Group count")
        ViewerOfStringSet (Set (self.mProxy.arrayOf (\T.count).map { "\($0)" }) )
      }
      InspectorOfBoolSet (
        title: "UnGrouping is enabled",
        valueSet: self.mProxy.setOf (\T.mUnGroupIsEnabled),
        setter: { self.mProxy.setProperty (\T.mUnGroupIsEnabled, $0) }
      )
      Button ("Ungroup") { self.mProxy.performUserInterfaceAction { $0.performUngroup () } }.disabled (!self.canUngroup ())
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func canUngroup () -> Bool {
    self.mProxy.optValueOf (\T.mUnGroupIsEnabled) ?? false
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
