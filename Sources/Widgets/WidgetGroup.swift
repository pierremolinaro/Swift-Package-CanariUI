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

  private var mArray : [any WidgetUIProtocol <TypeDictionary>] // at 0: back, at count - 1: front

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  var widgetArray : [any WidgetUIProtocol <TypeDictionary>] { self.mArray }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (_ inWidgets : [any WidgetUIProtocol <TypeDictionary>]) {
    self.mArray = inWidgets
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (proxies inProxyArray : [WidgetProxy <TypeDictionary>]) {
    var array = [any WidgetUIProtocol <TypeDictionary>] ()
    for proxy in inProxyArray {
      array.append (proxy.widget)
    }
    self.mArray = array
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Encoding, Decoding
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private enum CodingKeys : String, CodingKey { case array }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (from inDecoder : Decoder) throws {
    let container = try inDecoder.container (keyedBy: CodingKeys.self)
    let proxyArray = try container.decode ([WidgetProxy <TypeDictionary>].self, forKey: .array)
    var array = [any WidgetUIProtocol <TypeDictionary>] ()
    for proxy in proxyArray {
      array.append (proxy.widget)
    }
    self.mArray = array
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func encode (to inEncoder : Encoder) throws {
    var container = inEncoder.container (keyedBy: CodingKeys.self)
    var proxyArray = [WidgetProxy <TypeDictionary>] ()
    for widget in self.mArray {
      proxyArray.append (WidgetProxy (widget))
    }
    try container.encode (proxyArray, forKey: .array)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func knobs () -> [WidgetKnob <TypeDictionary>] { [] }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func contextualMenu (_ inExecutor : ContextualMenuExecutor <TypeDictionary>) -> any View { EmptyView () }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func isEqual (to inOther : any WidgetUIProtocol <TypeDictionary>) -> Bool {
    if let other = inOther as? WidgetGroup <TypeDictionary> {
      if self.mArray.count != other.mArray.count {
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
      let path = CanariPath (rect: self.enclosingRect().scaled (by: inZoom))
      ioContext.stroke (path, with: .color (.red), lineWidth: .px (2))
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func enclosingRect () -> CanariRect {
    var r = CanariRect.empty
    for widget in self.mArray {
      r = r.unioning (widget.enclosingRect ())
    }
    return r
  }


  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Location test
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func contains (point inPoint : CanariPoint) -> Bool {
    for widget in self.mArray {
      if widget.contains (point: inPoint) {
        return true
      }
    }
    return false
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func intersect (rect inRect : CanariRect) -> Bool {
    for widget in self.mArray {
      if widget.intersect (rect: inRect) {
        return true
      }
    }
    return false
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Translation
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func limitTranslation (_ ioTranslation : inout CanariPoint) {
    for widget in self.mArray {
      widget.limitTranslation (&ioTranslation)
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public mutating func performTranslation (by inTranslation : CanariPoint) {
    for i in 0 ..< self.mArray.count {
      self.mArray [i].performTranslation (by: inTranslation)
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: AlignmentGuidePoints
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func alignmentGuidePoints () -> Set <CanariPoint> {
    var points = Set <CanariPoint> ()
    for widget in self.mArray {
      points.formUnion (widget.alignmentGuidePoints ())
    }
    return points
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
