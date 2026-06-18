//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 27/02/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct WidgetsManager <WidgetTypesDescription : DocumentWidgetsDescriptionProtocol> {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

//  private var mWidgetsArray : [any WidgetUIProtocol <WidgetTypesDescription>] // at 0: back, at count - 1: front
  private var mProxyArray : [WidgetProxy <WidgetTypesDescription>] // at 0: back, at count - 1: front

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init () {
    self.mProxyArray = []
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  var count : Int { self.mProxyArray.count }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public mutating func setWidgets (fromProxies inProxies : [WidgetProxy <WidgetTypesDescription>]) {
//    var widgetsArray = [any WidgetUIProtocol <WidgetTypesDescription>] ()
//    for proxy in inProxies {
//      widgetsArray.append (proxy.widget)
//    }
//    self.mWidgetsArray = widgetsArray
    self.mProxyArray = inProxies
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var proxyArray : [WidgetProxy <WidgetTypesDescription>] {
//    var array = [WidgetProxy <WidgetTypesDescription>] ()
//    for widget in self.mWidgetsArray {
//      array.append(WidgetProxy (widget))
//    }
//    return array
    return self.mProxyArray
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func proxyArray (fromSelection inSelection : Set <UUID>) -> [WidgetProxy <WidgetTypesDescription>] {
    var result = [WidgetProxy <WidgetTypesDescription>] ()
    for proxy in self.mProxyArray {
      if inSelection.contains (proxy.widget.id) {
        result.append (proxy)
      }
    }
    return result
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Subscripts
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public subscript (proxyIndex inIndex : Int) -> WidgetProxy <WidgetTypesDescription> {
    get { self.mProxyArray [inIndex] }
    set { self.mProxyArray [inIndex] = newValue }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  subscript (proxyID inID : UUID) -> (WidgetProxy <WidgetTypesDescription>)? {
    get {
      self.mProxyArray.first { $0.widget.id == inID }
    }
    set {
      if let v = newValue, let idx = self.mProxyArray.firstIndex (where: { $0.widget.id == inID } ) {
        self.mProxyArray [idx] = v
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Mutating functions
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  mutating func append (_ inNewObject : WidgetProxy <WidgetTypesDescription>) {
    self.mProxyArray.append (inNewObject)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  mutating func removeLast () {
    self.mProxyArray.removeLast ()
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  mutating func remove (at inIndex : Int) {
    self.mProxyArray.remove (at: inIndex)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  mutating func remove (id inID : UUID) {
    if let idx = self.mProxyArray.firstIndex (where: { $0.widget.id == inID } ) {
      self.mProxyArray.remove (at: idx)
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  mutating func replaceWidget (id inID : UUID, with inArray : [WidgetProxy <WidgetTypesDescription>]) {
    var idx = self.mProxyArray.firstIndex { $0.widget.id == inID }!
    self.mProxyArray.remove (at: idx)
    for proxy in inArray {
      self.mProxyArray.insert (proxy, at: idx)
      idx += 1
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------

//extension WidgetsManager : Equatable {
//
//  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//
//  public static func == (_ inLeft : WidgetsManager <WidgetTypesDescription>,
//                         _ inRight : WidgetsManager <WidgetTypesDescription>) -> Bool { // Equatable
//    if inLeft.count != inRight.count {
//      return false
//    }else{
//      for i in 0 ..< inLeft.count {
//        if !inLeft.mWidgetsArray [i].isEqual (to: inRight.mWidgetsArray [i]) {
//          return false
//        }
//      }
//      return true
//    }
//  }
//
//  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//
//}

//--------------------------------------------------------------------------------------------------
