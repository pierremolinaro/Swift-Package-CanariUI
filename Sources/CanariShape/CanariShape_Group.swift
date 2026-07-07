//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 27/02/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct CanariShape_Group <ShapeTypesDescription : DocumentShapesDescriptionProtocol> : CanariShapeUIProtocol {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public let id : UUID

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var localOutlinePath : CanariPath {
    var result = CanariPath ()
    for shape in self.mArray {
      shape.orientedOrigin.withGlobalOutline { result.unionInPlaceUsingNonZeroRule ($0) }
    }
    return result
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  var mUnGroupIsEnabled : Bool
  public let mArray : [CanariBaseShape <ShapeTypesDescription>] // at 0: back, at count - 1: front

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var count : Int { self.mArray.count }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  init (grouping inShapeArray : [CanariBaseShape <ShapeTypesDescription>]) {
    self.id = UUID ()
    self.mUnGroupIsEnabled = true
    var vertices = [CanariPoint] ()
    for shape in inShapeArray {
      vertices += shape.orientedOrigin.globalBoundingRect.vertices
    }
    let r = CanariRect (vertices)
    self.mArray = inShapeArray.map {
      var origin = $0.orientedOrigin
      origin.mOrigin -= r.center
      return CanariBaseShape (origin, $0.shape)
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Encoding, Decoding
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private enum CodingKeys : String, CodingKey { case array, unGroupIsEnabled }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (from inDecoder : Decoder) throws {
    self.id = UUID ()
    let container = try inDecoder.container (keyedBy: CodingKeys.self)
    self.mArray = try container.decode ([CanariBaseShape <ShapeTypesDescription>].self, forKey: .array)
    self.mUnGroupIsEnabled = try container.decode (Bool.self, forKey: .unGroupIsEnabled)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func encode (to inEncoder : Encoder) throws {
    var container = inEncoder.container (keyedBy: CodingKeys.self)
    try container.encode (self.mArray, forKey: .array)
    try container.encode (self.mUnGroupIsEnabled, forKey: .unGroupIsEnabled)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var shapeKnobs : [ShapeKnob <ShapeTypesDescription>] { [] }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func contextualMenu (_ inExecutor : ContextualMenuExecutor <ShapeTypesDescription>) -> any View { EmptyView () }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func isEqual (to inOther : any CanariShapeUIProtocol <ShapeTypesDescription>) -> Bool {
    if let other = inOther as? CanariShape_Group <ShapeTypesDescription> {
      return (self.id == other.id)
          && (self.mUnGroupIsEnabled == other.mUnGroupIsEnabled)
          && (self.mArray == other.mArray)
    }else{
      return false
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: duplicated
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func duplicated () -> (any CanariShapeUIProtocol <ShapeTypesDescription>)? {
    CanariShape_Group (self.mUnGroupIsEnabled, self.mArray)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private init (_ inUnGroupIsEnabled : Bool,
                _ inArray : [CanariBaseShape <ShapeTypesDescription>]) {
    self.id = UUID ()
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
                          canvasScale inCanvasScale : Double,
                          hovered inHovered : Bool,
                          selected inSelected : Bool,
                          groupLevel inGroupLevel : UInt) {
    for shape in self.mArray {
      ioContext.translate (by: shape.orientedOrigin.mOrigin)
      ioContext.rotate (by: shape.orientedOrigin.mAngle)
      ioContext.scale (by: shape.orientedOrigin.mScale, horizontalFlip: shape.orientedOrigin.mHorizontalFlip)
      shape.shape.drawShape (
        context: &ioContext,
        canvasScale: inCanvasScale * shape.orientedOrigin.mScale,
        hovered: inHovered,
        selected: inSelected,
        groupLevel: inGroupLevel
      )
      ioContext.scale (by: 1.0 / shape.orientedOrigin.mScale, horizontalFlip: shape.orientedOrigin.mHorizontalFlip)
      ioContext.rotate (by: -shape.orientedOrigin.mAngle)
      ioContext.translate (by: -shape.orientedOrigin.mOrigin)
    }
    if inSelected || inHovered, inGroupLevel == 0 {
//  §    self.orientedOrigin.withLocalBoundingRect {
//        ioContext.stroke (
//          CanariPath (rect: $0),
//          with: .color (.black), lineWidth: .px (0.5) / inScale
//        )
//      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: AlignmentGuidePoints
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var localAlignmentGuidePoints : [CanariPoint] {
    var points = [CanariPoint] ()
    for shape in self.mArray {
      points += shape.shape.localAlignmentGuidePoints
    }
    return points
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: ungrouped array
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func ungroupedArray (_ inGroupOrigin : CanariScaledOrientedOrigin) -> [CanariBaseShape <ShapeTypesDescription>] {
    return self.mArray.map {
      var origin = $0.orientedOrigin
      origin.transformToGlobal (inGroupOrigin)
      return CanariBaseShape (origin, $0.shape)
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: inspectorView
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public static var inspectorTitle : String { "Group" }

  public static func inspectorView (proxy inProxy : CanariInspectorProxy <ShapeTypesDescription>) -> any View {
    GroupShapeInspectorView (proxy: inProxy)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------

fileprivate struct GroupShapeInspectorView <ShapeTypesDescription : DocumentShapesDescriptionProtocol> : View {

  typealias T = CanariShape_Group <ShapeTypesDescription>

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @State private var mProxy : CanariInspectorProxy <ShapeTypesDescription>

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  init (proxy inProxy : CanariInspectorProxy <ShapeTypesDescription>) {
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
