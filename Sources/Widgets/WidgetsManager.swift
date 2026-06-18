//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 27/02/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct WidgetsManager <WidgetTypesDescription : DocumentWidgetsDescriptionProtocol> {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

//  private var mWidgetsArray : [any DecoratorUIProtocol <WidgetTypesDescription>] // at 0: back, at count - 1: front
  private var mProxyArray : [CanariWidget <WidgetTypesDescription>] // at 0: back, at count - 1: front

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init () {
    self.mProxyArray = []
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  var count : Int { self.mProxyArray.count }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public mutating func setWidgets (fromProxies inProxies : [CanariWidget <WidgetTypesDescription>]) {
    self.mProxyArray = inProxies
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var proxyArray : [CanariWidget <WidgetTypesDescription>] {
    return self.mProxyArray
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func proxyArray (fromSelection inSelection : Set <UUID>) -> [CanariWidget <WidgetTypesDescription>] {
    var result = [CanariWidget <WidgetTypesDescription>] ()
    for proxy in self.mProxyArray {
      if inSelection.contains (proxy.decorator.id) {
        result.append (proxy)
      }
    }
    return result
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Subscripts
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public subscript (proxyIndex inIndex : Int) -> CanariWidget <WidgetTypesDescription> {
    get { self.mProxyArray [inIndex] }
    set { self.mProxyArray [inIndex] = newValue }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  subscript (proxyID inID : UUID) -> (CanariWidget <WidgetTypesDescription>)? {
    get {
      self.mProxyArray.first { $0.decorator.id == inID }
    }
    set {
      if let v = newValue, let idx = self.mProxyArray.firstIndex (where: { $0.decorator.id == inID } ) {
        self.mProxyArray [idx] = v
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Mutating functions
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  mutating func append (_ inNewObject : CanariWidget <WidgetTypesDescription>) {
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
    if let idx = self.mProxyArray.firstIndex (where: { $0.decorator.id == inID } ) {
      self.mProxyArray.remove (at: idx)
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  mutating func replaceWidget (id inID : UUID, with inArray : [CanariWidget <WidgetTypesDescription>]) {
    var idx = self.mProxyArray.firstIndex { $0.decorator.id == inID }!
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
