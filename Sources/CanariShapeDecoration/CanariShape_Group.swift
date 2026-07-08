//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 27/02/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct CanariShape_Group <SHAPE_TYPES_DESCRIPTION : DocumentShapesDescriptionProtocol> : CanariShapeDecorationProtocol {

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
  public let mArray : [CanariShapeRoot <SHAPE_TYPES_DESCRIPTION>] // at 0: back, at count - 1: front

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var count : Int { self.mArray.count }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  init (zeroCenteredShapeArray inShapeArray : [CanariShapeRoot <SHAPE_TYPES_DESCRIPTION>]) {
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
    self.mArray = try container.decode ([CanariShapeRoot <SHAPE_TYPES_DESCRIPTION>].self, forKey: .array)
    self.mUnGroupIsEnabled = try container.decode (Bool.self, forKey: .unGroupIsEnabled)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func encode (to inEncoder : Encoder) throws {
    var container = inEncoder.container (keyedBy: CodingKeys.self)
    try container.encode (self.mArray, forKey: .array)
    try container.encode (self.mUnGroupIsEnabled, forKey: .unGroupIsEnabled)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var shapeKnobs : [ShapeKnob <SHAPE_TYPES_DESCRIPTION>] { [] }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func contextualMenu (_ inExecutor : ContextualMenuExecutor <SHAPE_TYPES_DESCRIPTION>) -> any View { EmptyView () }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func isEqual (to inOther : any CanariShapeDecorationProtocol <SHAPE_TYPES_DESCRIPTION>) -> Bool {
    if let other = inOther as? CanariShape_Group <SHAPE_TYPES_DESCRIPTION> {
      return (self.mUnGroupIsEnabled == other.mUnGroupIsEnabled)
          && (self.mArray == other.mArray)
    }else{
      return false
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: duplicated
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func duplicated () -> (any CanariShapeDecorationProtocol <SHAPE_TYPES_DESCRIPTION>)? {
    CanariShape_Group (self.mUnGroupIsEnabled, self.mArray)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private init (_ inUnGroupIsEnabled : Bool,
                _ inArray : [CanariShapeRoot <SHAPE_TYPES_DESCRIPTION>]) {
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
                         anchor inAnchor : CanariScaledOrientedAnchor,
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
          drawingScale: decorationDrawingScale,
          hovered: inHovered,
          selected: inSelected,
          groupLevel: inGroupLevel
        )
      }
//      shape.mAnchor.drawShapeInLocalCoordinates (
//        &ioContext,
//        shape.mDecoration,
//        drawingScale: inDrawingScale,
//        hovered: inHovered,
//        selected: inSelected,
//        groupLevel: inGroupLevel
//      )
//      ioContext.translate (by: shape.mAnchor.mPoint)
//      ioContext.rotate (by: shape.mAnchor.mAngle)
//      ioContext.scale (by: shape.mAnchor.mScale, horizontalFlip: shape.mAnchor.mHorizontalFlip)
//      shape.mDecoration.drawShape (
//        context: &ioContext,
//        canvasScale: inCanvasScale * shape.mAnchor.mScale,
//        hovered: inHovered,
//        selected: inSelected,
//        groupLevel: inGroupLevel
//      )
//      ioContext.scale (by: 1.0 / shape.mAnchor.mScale, horizontalFlip: shape.mAnchor.mHorizontalFlip)
//      ioContext.rotate (by: -shape.mAnchor.mAngle)
//      ioContext.translate (by: -shape.mAnchor.mPoint)
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

  func ungroupedArray (_ inGroupOrigin : CanariScaledOrientedAnchor) -> [CanariShapeRoot <SHAPE_TYPES_DESCRIPTION>] {
    return self.mArray.map {
      var origin = $0.mAnchor
      origin.transformToGlobal (inGroupOrigin)
      return CanariShapeRoot (origin, $0.mDecoration)
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: inspectorView
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public static var inspectorTitle : String { "Group" }

  public static func inspectorView (proxy inProxy : CanariInspectorProxy <SHAPE_TYPES_DESCRIPTION>) -> any View {
    GroupShapeInspectorView (proxy: inProxy)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------

fileprivate struct GroupShapeInspectorView <SHAPE_TYPES_DESCRIPTION : DocumentShapesDescriptionProtocol> : View {

  typealias T = CanariShape_Group <SHAPE_TYPES_DESCRIPTION>

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @State private var mProxy : CanariInspectorProxy <SHAPE_TYPES_DESCRIPTION>

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  init (proxy inProxy : CanariInspectorProxy <SHAPE_TYPES_DESCRIPTION>) {
    self.mProxy = inProxy
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  var body : some View {
    CanariElementInspector (title: "Ungrouping") {
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
