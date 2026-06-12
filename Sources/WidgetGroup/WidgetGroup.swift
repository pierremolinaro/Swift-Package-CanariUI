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

  public var orientedOrigin : CanariScaledOrientedOrigin

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  var mUnGroupIsEnabled : Bool
  let mArray : [any WidgetUIProtocol <TypeDictionary>] // at 0: back, at count - 1: front

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  var count : Int { self.mArray.count }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (_ inWidgets : [any WidgetUIProtocol <TypeDictionary>]) {
    var vertices = [CanariPoint] ()
    for widget in inWidgets {
      vertices += widget.orientedOrigin.globalBoundingRect.vertices
    }
    let r = CanariRect (vertices)
    self.mArray = inWidgets.map {
      var widget = $0
      widget.translate (by: -r.center)
      return widget
    }
    self.mUnGroupIsEnabled = true
    self.orientedOrigin = CanariScaledOrientedOrigin (r.center, .zero, 1.0)
    var localOutline = CanariPath ()
    for widget in inWidgets {
      localOutline.unionInPlace (widget.orientedOrigin.globalOutline)
    }
    self.orientedOrigin.setLocalOutline (localOutline)
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

  private enum CodingKeys : String, CodingKey { case oo, array, unGroupIsEnabled }

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
    self.orientedOrigin = try container.decode (CanariScaledOrientedOrigin.self, forKey: .oo)
    var localOutline = CanariPath ()
    for widget in array {
      localOutline.unionInPlace (widget.orientedOrigin.globalOutline)
    }
    self.orientedOrigin.setLocalOutline (localOutline)
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
    try container.encode (self.orientedOrigin, forKey: .oo)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var knobs : [WidgetKnob <TypeDictionary>] { [] }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func contextualMenu (_ inExecutor : ContextualMenuExecutor <TypeDictionary>) -> any View { EmptyView () }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func isEqual (to inOther : any WidgetUIProtocol <TypeDictionary>) -> Bool {
    if let other = inOther as? WidgetGroup <TypeDictionary> {
      if (self.mArray.count != other.mArray.count)
            || (self.orientedOrigin != other.orientedOrigin)
            || (self.mUnGroupIsEnabled != other.mUnGroupIsEnabled) {
        return false
      }else{
        for i in 0 ..< self.mArray.count {
          if !self.mArray[i].isEqual (to: other.mArray[i]) {
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

  public var isGraphicallyEmpty : Bool { self.mArray.isEmpty }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Draw
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func draw (context ioContext : inout GraphicsContext,
                    scale inScale : Double,
                    hovered inHovered : Bool,
                    selected inSelected : Bool,
                    groupLevel inGroupLevel : UInt) {
    for widget in self.mArray {
      widget.drawFromGlobal (
        context: &ioContext,
        scale: inScale,
        hovered: inHovered,
        selected: inSelected,
        groupLevel: inGroupLevel + 1
      )
    }
    if inSelected, inGroupLevel == 0 {
      ioContext.stroke (
        CanariPath (rect: self.orientedOrigin.localBoundingRect),
        with: .color (.black), lineWidth: .px (0.5) / inScale
      )
    }
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
  //MARK: ungrouped array
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func ungroupedArray () -> [any WidgetUIProtocol <TypeDictionary>] {
    return self.mArray.map {
      var widget = $0
      widget.orientedOrigin.updateFromOrientedOrigin (self.orientedOrigin)
      return widget
    }
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
      Inspector_CanariPoint (
        title: "Center",
        pointSet: self.mProxy.setOf (\T.orientedOrigin.mOrigin),
        setterX: { newX in
          self.mProxy.performWidgetAction { (widget : inout T) in
            widget.orientedOrigin.mOrigin.x = newX
          }
        },
        setterY: { newY in
          self.mProxy.performWidgetAction { (widget : inout T) in
            widget.orientedOrigin.mOrigin.y = newY
          }
        }
      )
      CanariElementInspector (title: "Angle") {
        Set_CanariAngleEditor (
          angleSet: self.mProxy.setOf (\T.orientedOrigin.mAngle),
          setter: { newAngle in
            self.mProxy.performWidgetAction { (widget : inout T) in
              widget.orientedOrigin.mAngle = newAngle
            }
          },
          width: 64
        )
      }
      CanariElementInspector (title: "Scale") {
        Set_DoubleEditor (
          valueSet: self.mProxy.setOf (\T.orientedOrigin.mScale),
          setter: { newScale in
            self.mProxy.performWidgetAction { (widget : inout T) in
              widget.orientedOrigin.mScale = newScale
            }
          },
          width: 64
        )
      }
      CanariElementInspector (title: "Enclosing Rectangle") {
        Set_CanariRectGraphicView (rectSet: self.mProxy.setOf (\T.orientedOrigin.globalBoundingRect))
      }
//      CanariElementInspector (title: "Center") {
//        HStack {
//          Spacer ()
//          Form {
//            Set_CanariPointEditor (
//              pointSet: self.mProxy.setOf (\T.mCenter),
//              setterX: { newX in
//                self.mProxy.performWidgetAction { (widget : inout T) in
//                  widget.mCenter = CanariPoint (x: newX, y: widget.mCenter.y)
//                }
//              },
//              setterY: { newY in
//                self.mProxy.performWidgetAction { (widget : inout T) in
//                  widget.mCenter = CanariPoint (x: widget.mCenter.x, y: newY)
//                }
//              }
//            )
//          }
//          Spacer ()
//        }
//      }
//      CanariElementInspector (title: "Angle") {
//        Set_CanariAngleEditor (
//          angleSet: self.mProxy.setOf (\T.mAngle),
//          setter: { newAngle in
//            self.mProxy.performWidgetAction { (widget : inout T) in
//              widget.mAngle = newAngle
//            }
//          },
//          width: 64
//        )
//      }
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
