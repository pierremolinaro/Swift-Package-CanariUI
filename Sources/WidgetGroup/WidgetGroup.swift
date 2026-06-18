//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 27/02/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct WidgetGroup <WidgetTypesDescription : DocumentWidgetsDescriptionProtocol> : WidgetUIProtocol {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public let id : UUID

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var orientedOrigin : CanariScaledOrientedOrigin

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  var mUnGroupIsEnabled : Bool
  let mArray : [WidgetProxy <WidgetTypesDescription>] // at 0: back, at count - 1: front

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  var count : Int { self.mArray.count }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  init (grouping inProxys : [WidgetProxy <WidgetTypesDescription>]) {
    self.id = UUID ()
    self.mUnGroupIsEnabled = true
    var vertices = [CanariPoint] ()
    for proxy in inProxys {
      vertices += proxy.widget.orientedOrigin.globalBoundingRect.vertices
    }
    let r = CanariRect (vertices)
    self.mArray = inProxys.map {
      var widget = $0.widget
      widget.orientedOrigin.mOrigin -= r.center
      return WidgetProxy (widget)
    }
    self.orientedOrigin = CanariScaledOrientedOrigin (r.center, .zero, 1.0, false)
    var localOutline = CanariPath ()
    for proxy in self.mArray {
      proxy.widget.orientedOrigin.withGlobalOutline { localOutline.unionInPlace ($0) }
    }
    self.orientedOrigin.setLocalOutline (localOutline)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Encoding, Decoding
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private enum CodingKeys : String, CodingKey { case oo, array, unGroupIsEnabled }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (from inDecoder : Decoder) throws {
    self.id = UUID ()
    let container = try inDecoder.container (keyedBy: CodingKeys.self)
    self.mArray = try container.decode ([WidgetProxy <WidgetTypesDescription>].self, forKey: .array)
    self.mUnGroupIsEnabled = try container.decode (Bool.self, forKey: .unGroupIsEnabled)
    self.orientedOrigin = try container.decode (CanariScaledOrientedOrigin.self, forKey: .oo)
    var localOutline = CanariPath ()
    for proxy in self.mArray {
      proxy.widget.orientedOrigin.withGlobalOutline { localOutline.unionInPlace ($0) }
    }
    self.orientedOrigin.setLocalOutline (localOutline)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func encode (to inEncoder : Encoder) throws {
    var container = inEncoder.container (keyedBy: CodingKeys.self)
    try container.encode (self.mArray, forKey: .array)
    try container.encode (self.mUnGroupIsEnabled, forKey: .unGroupIsEnabled)
    try container.encode (self.orientedOrigin, forKey: .oo)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var knobs : [WidgetKnob <WidgetTypesDescription>] { [] }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func contextualMenu (_ inExecutor : ContextualMenuExecutor <WidgetTypesDescription>) -> any View { EmptyView () }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func isEqual (to inOther : any WidgetUIProtocol <WidgetTypesDescription>) -> Bool {
    if let other = inOther as? WidgetGroup <WidgetTypesDescription> {
      return (self.id == other.id) && (self.mArray == other.mArray) && (self.mUnGroupIsEnabled == other.mUnGroupIsEnabled)
    }else{
      return false
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: duplicated
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func duplicated () -> (any WidgetUIProtocol <WidgetTypesDescription>)? {
    return WidgetGroup (self.orientedOrigin, self.mUnGroupIsEnabled, self.mArray)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private init (_ inOrientedOrigin : CanariScaledOrientedOrigin,
                _ inUnGroupIsEnabled : Bool,
                _ inArray : [WidgetProxy <WidgetTypesDescription>]) {
    self.id = UUID ()
    self.orientedOrigin = inOrientedOrigin
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

  public func drawWidget (context ioContext : inout GraphicsContext,
                          scale inScale : Double,
                          hovered inHovered : Bool,
                          selected inSelected : Bool,
                          groupLevel inGroupLevel : UInt) {
    for proxy in self.mArray {
      proxy.widget.drawFromGlobal (
        context: &ioContext,
        scale: inScale,
        hovered: inHovered,
        selected: inSelected,
        groupLevel: inGroupLevel + 1
      )
    }
    if inSelected, inGroupLevel == 0 {
      self.orientedOrigin.withLocalBoundingRect {
        ioContext.stroke (
          CanariPath (rect: $0),
          with: .color (.black), lineWidth: .px (0.5) / inScale
        )
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: AlignmentGuidePoints
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var localAlignmentGuidePoints : [CanariPoint] {
    var points = [CanariPoint] ()
    for proxy in self.mArray {
      points += proxy.widget.localAlignmentGuidePoints
    }
    return points
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: ungrouped array
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func ungroupedArray () -> [WidgetProxy <WidgetTypesDescription>] {
    return self.mArray.map {
      var widget = $0.widget
      widget.orientedOrigin.transformToGlobal (self.orientedOrigin)
      return WidgetProxy (widget)
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: inspectorView
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public static var inspectorTitle : String { "Group" }

  public static func inspectorView (proxy inProxy : InspectorProxy <WidgetTypesDescription>) -> any View {
    WidgetGroupInspectorView (proxy: inProxy)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------

fileprivate struct WidgetGroupInspectorView <WidgetTypesDescription : DocumentWidgetsDescriptionProtocol> : View {

  typealias T = WidgetGroup <WidgetTypesDescription>

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @State private var mProxy : InspectorProxy <WidgetTypesDescription>

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  init (proxy inProxy : InspectorProxy <WidgetTypesDescription>) {
    self.mProxy = inProxy
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  var body : some View {
    CanariElementInspector (title: "Ungrouping", subTitle: "") {
      HStack {
        Text ("Group count")
        ViewerOfStringSet (Set (self.mProxy.arrayOf (\T.count).map { "\($0)" }) )
      }
      InspectorOfBoolSet (
        title: "UnGrouping is enabled",
        valueSet: self.mProxy.setOf (\T.mUnGroupIsEnabled),
        setter: { self.mProxy.setProperty (\T.mUnGroupIsEnabled, $0) }
      )
      Button ("Ungroup") { self.mProxy.performWidgetUserInterfaceAction { $0.performUngroup () } }.disabled (!self.canUngroup ())
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func canUngroup () -> Bool {
    self.mProxy.optValueOf (\T.mUnGroupIsEnabled) ?? false
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
