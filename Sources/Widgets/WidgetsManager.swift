//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 27/02/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct WidgetsManager <WidgetTypesDescription : DocumentWidgetsDescriptionProtocol> {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private var mWidgetsArray : [any WidgetUIProtocol <WidgetTypesDescription>] // at 0: back, at count - 1: front
//  private var mProxyArray : [WidgetProxy <WidgetTypesDescription>] // at 0: back, at count - 1: front

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init () {
    self.mWidgetsArray = []
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  var count : Int { self.mWidgetsArray.count }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public mutating func setWidgets (fromProxies inProxies : [WidgetProxy <WidgetTypesDescription>]) {
    var widgetsArray = [any WidgetUIProtocol <WidgetTypesDescription>] ()
    for proxy in inProxies {
      widgetsArray.append (proxy.widget)
    }
    self.mWidgetsArray = widgetsArray
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var proxyArray : [WidgetProxy <WidgetTypesDescription>] {
    var array = [WidgetProxy <WidgetTypesDescription>] ()
    for widget in self.mWidgetsArray {
      array.append(WidgetProxy (widget))
    }
    return array
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func proxyArray (fromSelection inSelection : Set <UUID>) -> [WidgetProxy <WidgetTypesDescription>] {
    var result = [WidgetProxy <WidgetTypesDescription>] ()
    for widget in self.mWidgetsArray {
      if inSelection.contains (widget.id) {
        result.append (WidgetProxy (widget))
      }
    }
    return result
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Subscripts
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public subscript (proxyIndex inIndex : Int) -> WidgetProxy <WidgetTypesDescription> {
    get { WidgetProxy (self.mWidgetsArray [inIndex]) }
    set { self.mWidgetsArray [inIndex] = newValue.widget }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  subscript (proxyID inID : UUID) -> (WidgetProxy <WidgetTypesDescription>)? {
    get {
      if let widget = self.mWidgetsArray.first ( where: { $0.id == inID } ) {
        return WidgetProxy (widget)
      }else{
        return nil
      }
    }
    set {
      if let v = newValue, let idx = self.mWidgetsArray.firstIndex (where: { $0.id == inID } ) {
        self.mWidgetsArray [idx] = v.widget
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Mutating functions
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  mutating func append (_ inNewObject : WidgetProxy <WidgetTypesDescription>) {
    self.mWidgetsArray.append (inNewObject.widget)
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

  mutating func replaceWidget (id inID : UUID, with inArray : [WidgetProxy <WidgetTypesDescription>]) {
    var idx = self.mWidgetsArray.firstIndex { $0.id == inID }!
    self.mWidgetsArray.remove (at: idx)
    for proxy in inArray {
      self.mWidgetsArray.insert (proxy.widget, at: idx)
      idx += 1
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------

extension WidgetsManager : Equatable {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public static func == (_ inLeft : WidgetsManager <WidgetTypesDescription>,
                         _ inRight : WidgetsManager <WidgetTypesDescription>) -> Bool { // Equatable
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

}

//--------------------------------------------------------------------------------------------------
