//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 27/02/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct WidgetsManager <TypeDictionary : WidgetTypeArrayProtocol> : Equatable {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private var mWidgetsArray : [any WidgetUIProtocol <TypeDictionary>] // at 0: back, at count - 1: front

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init () {
    self.mWidgetsArray = []
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func contentsIsExactly (_ inWidgets : [WidgetProxy <TypeDictionary>]) -> Bool {
    if self.mWidgetsArray.count != inWidgets.count {
      return false
    }else{
      for i in 0 ..< self.mWidgetsArray.count {
        if !self.mWidgetsArray [i].isEqual (to: inWidgets [i].widget) {
          return false
        }
      }
      return true
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  var count : Int { self.mWidgetsArray.count }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var widgets : [any WidgetUIProtocol <TypeDictionary>] { self.mWidgetsArray }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public mutating func setWidgets (fromProxies inProxies : [WidgetProxy <TypeDictionary>]) {
    var widgetsArray = [any WidgetUIProtocol <TypeDictionary>] ()
    for proxy in inProxies {
      widgetsArray.append (proxy.widget)
    }
    self.mWidgetsArray = widgetsArray
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public static func == (_ inLeft : WidgetsManager <TypeDictionary>,
                         _ inRight : WidgetsManager <TypeDictionary>) -> Bool { // Equatable
    if inLeft.count != inRight.count {
      return false
    }else{
      for i in 0 ..< inLeft.count {
        if !inLeft.mWidgetsArray [i].isEqual (to: inRight.mWidgetsArray [i]) {
          return false
        }
      }
      return true
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var proxyArray : [WidgetProxy <TypeDictionary>] {
    var array = [WidgetProxy <TypeDictionary>] ()
    for widget in self.mWidgetsArray {
      array.append(WidgetProxy (widget))
    }
    return array
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public subscript (widget inIndex : Int) -> any WidgetUIProtocol <TypeDictionary> {
    get { self.mWidgetsArray [inIndex] }
    set { self.mWidgetsArray [inIndex] = newValue }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  mutating func append (_ inNewObject : any WidgetUIProtocol <TypeDictionary>) {
    self.mWidgetsArray.append (inNewObject)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  mutating func removeLast () {
    self.mWidgetsArray.removeLast ()
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  mutating func remove (at inIndex : Int) {
    self.mWidgetsArray.remove (at: inIndex)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  mutating func remove (id inID : UUID) {
    if let idx = self.mWidgetsArray.firstIndex (where: { $0.id == inID } ) {
      self.mWidgetsArray.remove (at: idx)
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  subscript (id inID : UUID) -> any WidgetUIProtocol <TypeDictionary> {
    get { self.mWidgetsArray.first { $0.id == inID }! }
    set {
      let idx = self.mWidgetsArray.firstIndex { $0.id == inID }!
      self.mWidgetsArray [idx] = newValue
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func widgetArray (fromSelection inSelection : Set <UUID>) -> [any WidgetUIProtocol <TypeDictionary>] {
    var result = [any WidgetUIProtocol <TypeDictionary>] ()
    for widget in self.mWidgetsArray {
      if inSelection.contains (widget.id) {
        result.append (widget)
      }
    }
    return result
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func proxyArray (fromSelection inSelection : Set <UUID>) -> [WidgetProxy <TypeDictionary>] {
    var result = [WidgetProxy <TypeDictionary>] ()
    for widget in self.mWidgetsArray {
      if inSelection.contains (widget.id) {
        result.append (WidgetProxy (widget))
      }
    }
    return result
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  mutating func replaceWidget (id inID : UUID, with inArray : [any WidgetUIProtocol <TypeDictionary>]) {
    var idx = self.mWidgetsArray.firstIndex { $0.id == inID }!
    self.mWidgetsArray.remove (at: idx)
    for proxy in inArray {
      self.mWidgetsArray.insert (proxy, at: idx)
      idx += 1
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
