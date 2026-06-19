//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 27/02/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct WidgetsManager <WidgetTypesDescription : DocumentWidgetsDescriptionProtocol> {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private var mWidgetArray : [CanariWidget <WidgetTypesDescription>] // at 0: back, at count - 1: front

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init () {
    self.mWidgetArray = []
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  var count : Int { self.mWidgetArray.count }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public mutating func setWidgets (_ inWidgets : [CanariWidget <WidgetTypesDescription>]) {
    self.mWidgetArray = inWidgets
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var widgetArray : [CanariWidget <WidgetTypesDescription>] {
    return self.mWidgetArray
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Subscripts
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public subscript (widgetIndex inIndex : Int) -> CanariWidget <WidgetTypesDescription> {
    get { self.mWidgetArray [inIndex] }
    set { self.mWidgetArray [inIndex] = newValue }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  subscript (decoratorID inID : UUID) -> (CanariWidget <WidgetTypesDescription>)? {
    get {
      self.mWidgetArray.first { $0.decorator.id == inID }
    }
    set {
      if let v = newValue, let idx = self.mWidgetArray.firstIndex (where: { $0.decorator.id == inID } ) {
        self.mWidgetArray [idx] = v
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  //MARK: Mutating functions
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  mutating func append (_ inNewObject : CanariWidget <WidgetTypesDescription>) {
    self.mWidgetArray.append (inNewObject)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  mutating func removeLast () {
    self.mWidgetArray.removeLast ()
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  mutating func remove (at inIndex : Int) {
    self.mWidgetArray.remove (at: inIndex)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  mutating func remove (id inID : UUID) {
    if let idx = self.mWidgetArray.firstIndex (where: { $0.decorator.id == inID } ) {
      self.mWidgetArray.remove (at: idx)
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  mutating func replaceWidget (id inID : UUID, with inArray : [CanariWidget <WidgetTypesDescription>]) {
    var idx = self.mWidgetArray.firstIndex { $0.decorator.id == inID }!
    self.mWidgetArray.remove (at: idx)
    for widget in inArray {
      self.mWidgetArray.insert (widget, at: idx)
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
