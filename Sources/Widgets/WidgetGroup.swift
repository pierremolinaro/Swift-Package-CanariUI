//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 27/02/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct WidgetGroup <TypeDictionary : WidgetTypeArrayProtocol> : WidgetUIProtocol {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public static func documentEncodedTypeName () -> String { "*group*" }
  public let id = UUID ()

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var orientedOrigin : CanariOrientedOrigin = CanariOrientedOrigin (.zero, .zero)
  var mCenter : CanariPoint
  var mAngle : CanariAngle
  var mUnGroupIsEnabled : Bool

  var mArray : [any WidgetUIProtocol <TypeDictionary>] // at 0: back, at count - 1: front

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  var widgetArray : [any WidgetUIProtocol <TypeDictionary>] { self.mArray }
  var count : Int { self.mArray.count }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (_ inWidgets : [any WidgetUIProtocol <TypeDictionary>]) {
    var vertices = [CanariPoint] ()
    for widget in inWidgets {
      vertices += widget.canvasEnclosingRect.vertices
    }
    let r = CanariRect (vertices)
    self.mArray = inWidgets.map {
      var widget = $0
      widget.translate (by: -r.center)
      return widget
    }
    self.mUnGroupIsEnabled = true
    self.mCenter = r.center
    self.mAngle = .zero
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (proxies inProxyArray : [WidgetProxy <TypeDictionary>]) {
    var array = [any WidgetUIProtocol <TypeDictionary>] ()
    for proxy in inProxyArray {
      array.append (proxy.widget)
    }
    self.init (array)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Encoding, Decoding
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private enum CodingKeys : String, CodingKey { case center, angle, array, unGroupIsEnabled }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (from inDecoder : Decoder) throws {
    let container = try inDecoder.container (keyedBy: CodingKeys.self)
    let proxyArray = try container.decode ([WidgetProxy <TypeDictionary>].self, forKey: .array)
    var array = [any WidgetUIProtocol <TypeDictionary>] ()
    for proxy in proxyArray {
      array.append (proxy.widget)
    }
    self.mArray = array
    self.mUnGroupIsEnabled = try container.decode (Bool.self, forKey: .unGroupIsEnabled)
    self.mCenter = try container.decode (CanariPoint.self, forKey: .center)
    self.mAngle = try container.decode (CanariAngle.self, forKey: .angle)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func encode (to inEncoder : Encoder) throws {
    var container = inEncoder.container (keyedBy: CodingKeys.self)
    var proxyArray = [WidgetProxy <TypeDictionary>] ()
    for widget in self.mArray {
      proxyArray.append (WidgetProxy (widget))
    }
    try container.encode (proxyArray, forKey: .array)
    try container.encode (self.mUnGroupIsEnabled, forKey: .unGroupIsEnabled)
    try container.encode (self.mCenter, forKey: .center)
    try container.encode (self.mAngle, forKey: .angle)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func knobs () -> [WidgetKnob <TypeDictionary>] { [] }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func contextualMenu (_ inExecutor : ContextualMenuExecutor <TypeDictionary>) -> any View { EmptyView () }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func isEqual (to inOther : any WidgetUIProtocol <TypeDictionary>) -> Bool {
    if let other = inOther as? WidgetGroup <TypeDictionary> {
      if (self.mArray.count != other.mArray.count) || (self.mCenter != other.mCenter) || (self.mAngle != other.mAngle) {
        return false
      }else{
        for i in 0 ..< self.mArray.count {
          if !self.mArray[i].isEqual (to: other.widgetArray[i]) {
            return false
          }
        }
        return true
      }
    }else{
      return false
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func duplicated () -> (any WidgetUIProtocol <TypeDictionary>)? { nil }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func isGraphicallyEmpty () -> Bool { self.mArray.isEmpty }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Draw
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func draw (context ioContext : inout GraphicsContext,
                    zoom inZoom : Double,
                    hovered inHovered : Bool,
                    selected inSelected : Bool,
                    groupLevel inGroupLevel : UInt) {
    ioContext.translateBy (self.mCenter.scaled (by: inZoom))
    ioContext.rotate (by: self.mAngle)
    for widget in self.mArray {
      widget.draw (
        context: &ioContext,
        zoom: inZoom,
        hovered: inHovered,
        selected: inSelected,
        groupLevel: inGroupLevel + 1
      )
    }
    if inSelected, inGroupLevel == 0 {
      var vertices = [CanariPoint] ()
      for widget in self.mArray {
        vertices += widget.canvasEnclosingRect.vertices
      }
      let r = CanariRect (vertices)

      let path = CanariPath (rect: r.scaled (by: inZoom))
      ioContext.stroke (path, with: .color (.black), lineWidth: .px (0.5))
    }
    ioContext.rotate (by: -self.mAngle)
    ioContext.translateBy (-self.mCenter.scaled (by: inZoom))
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var localEnclosingRect : CanariRect { CanariRect (center: .zero, size: .zero) }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

//  public var enclosingRect : CanariRect {
//    var vertices = [CanariPoint] ()
//    for widget in self.mArray {
//      vertices += widget.canvasEnclosingRect.vertices
//    }
//    let path = CanariPath (rect: CanariRect (vertices))
//    let transformedPath = self.affinityFromRectToCanvas.transforming (path)
//    return transformedPath.boundingRect
//  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private var affinityFromRectToCanvas : CanariAffinity {
    CanariAffinity (translationByX: self.mCenter.x, byY: self.mCenter.y).rotating (self.mAngle)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private var affinityFromCanvasToLocal : CanariAffinity {
    CanariAffinity (rotation: -self.mAngle).translating (x: -self.mCenter.x, y: -self.mCenter.y)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func transformedFromRectToCanvas (x inX : CanariLength = .zero, y inY : CanariLength = .zero) -> CanariPoint {
    return CanariPoint (x: inX, y: inY).transformed (by: self.affinityFromRectToCanvas)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Location test
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func contains (localPoint inLocalPoint : CanariPoint) -> Bool {
    for widget in self.mArray {
      if widget.contains (localPoint: inLocalPoint) {
        return true
      }
    }
    return false
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func intersect (localPath inLocalPath : CanariPath) -> Bool {
//    let path = self.affinityFromCanvasToLocal.transforming (inPath)
    for widget in self.mArray {
      if widget.intersect (localPath: inLocalPath) {
        return true
      }
    }
    return false
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Translation
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func limitTranslation (_ ioTranslation : inout CanariPoint) {
    let r = self.canvasEnclosingRect
    if (r.minX + ioTranslation.x) < .zero {
      ioTranslation.x = -r.minX
    }
    if (r.minY + ioTranslation.y) < .zero {
      ioTranslation.y = -r.minY
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public mutating func translate (by inTranslation : CanariPoint) {
     self.mCenter = self.mCenter.moved (x: inTranslation.x, y: inTranslation.y)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Rotate
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public mutating func rotate (by inAngle : CanariAngle) {
    self.mAngle += inAngle
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: AlignmentGuidePoints
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var localAlignmentGuidePoints : [CanariPoint] {
    var points = [CanariPoint] ()
    for widget in self.mArray {
      points += widget.localAlignmentGuidePoints
    }
    return points
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: inspectorView
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public static func inspectorView (proxy inProxy : InspectorProxy <TypeDictionary>) -> any View {
    WidgetGroupInspectorView (proxy: inProxy)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------

fileprivate struct WidgetGroupInspectorView <TypeDictionary : WidgetTypeArrayProtocol> : View {

  typealias T = WidgetGroup <TypeDictionary>

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @State private var mProxy : InspectorProxy <TypeDictionary>

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  init (proxy inProxy : InspectorProxy <TypeDictionary>) {
    self.mProxy = inProxy
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  var body : some View {
    VStack {
      Text ("Group").bold ()
      Spacer ().frame (height: 16)
      CanariElementInspector (title: "Ungrouping") {
        HStack {
          Text ("Group count")
          Set_Text (Set (self.mProxy.arrayOf (\T.count).map { "\($0)" }) )
        }
        Opt_Toggle ("UnGrouping is enabled", isOn: self.mProxy [bindingFor: \T.mUnGroupIsEnabled])
        Button ("Ungroup") { self.mProxy.performWidgetUserInterfaceAction { $0.performUngroup () } }.disabled (!self.canUngroup ())
      }
      CanariElementInspector (title: "Enclosing Rectangle") {
        Set_CanariRectGraphicView (rectSet: self.mProxy.setOf (\T.canvasEnclosingRect))
      }
      CanariElementInspector (title: "Center") {
        HStack {
          Spacer ()
          Form {
            Set_CanariPointEditor (
              pointSet: self.mProxy.setOf (\T.mCenter),
              setterX: { newX in
                self.mProxy.performWidgetAction { (widget : inout T) in
                  widget.mCenter = CanariPoint (x: newX, y: widget.mCenter.y)
                }
              },
              setterY: { newY in
                self.mProxy.performWidgetAction { (widget : inout T) in
                  widget.mCenter = CanariPoint (x: widget.mCenter.x, y: newY)
                }
              }
            )
          }
          Spacer ()
        }
      }
      CanariElementInspector (title: "Angle") {
        Set_CanariAngleEditor (
          angleSet: self.mProxy.setOf (\T.mAngle),
          setter: { newAngle in
            self.mProxy.performWidgetAction { (widget : inout T) in
              widget.mAngle = newAngle
            }
          },
          width: 64
        )
      }
      Spacer ()
    }.padding ()
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func canUngroup () -> Bool {
    self.mProxy.optValueOf (\T.mUnGroupIsEnabled) ?? false
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
