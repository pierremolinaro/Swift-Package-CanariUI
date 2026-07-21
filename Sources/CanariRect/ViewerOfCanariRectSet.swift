//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 06/06/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct ViewerOfCanariRectSet : View {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private let mRectSet : Set <CanariRect>
  private let mUnit : EditorOfCanariLengthSet.DisplayUnit
  private let mFractionDigits : Int

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (rectSet inCanariRectSet : Set <CanariRect>,
               displayUnit inUnit : EditorOfCanariLengthSet.DisplayUnit,
               fractionDigits inFractionDigits : Int) {
    self.mRectSet = inCanariRectSet
    self.mUnit = inUnit
    self.mFractionDigits = inFractionDigits
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var body : some View {
    VStack {
      ViewerOfOptionalString (self.maxY?.string (in: self.mUnit.unit, fractionDigits: self.mFractionDigits))
//      .background (Rectangle ().fill (.quinary))
      .anchorPreference (key: RectanglePrefKey.self, value: .bounds) { ["bottom" : $0] }
      HStack {
        ViewerOfOptionalString (self.minX?.string (in: self.mUnit.unit, fractionDigits: self.mFractionDigits))
//        .background (Rectangle ().fill (.quaternary))
        .anchorPreference (key: RectanglePrefKey.self, value: .bounds) { ["left" : $0] }
        Spacer ()
        ViewerOfOptionalString (self.maxX?.string (in: self.mUnit.unit, fractionDigits: self.mFractionDigits))
 //       .background (Rectangle ().fill (.white))
        .anchorPreference (key: RectanglePrefKey.self, value: .bounds) { ["right" : $0] }
      }
      ViewerOfOptionalString (self.minY?.string (in: self.mUnit.unit, fractionDigits: self.mFractionDigits))
//      .background (Rectangle ().fill (.white))
      .anchorPreference (key: RectanglePrefKey.self, value: .bounds) { ["top" : $0] }
    }
    .backgroundPreferenceValue (RectanglePrefKey.self) { anchors in
      GeometryReader { geometry in
        let top : CGRect = geometry [anchors ["top"]!]
        let left = geometry [anchors ["left"]!]
        let right = geometry [anchors ["right"]!]
        let bottom = geometry [anchors ["bottom"]!]
        let path = self.rect (top: top, left: left, bottom: bottom, right: right)
        path.stroke (style: StrokeStyle(lineWidth: 1, lineCap: .round, lineJoin: .round))
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func rect (top inTop : CGRect,
                     left inLeft : CGRect,
                     bottom inBottom : CGRect,
                     right inRight : CGRect) -> Path {
    var path = Path ()
    path.move (to: CGPoint (x: inTop.minX - 2.0, y: inTop.midY))
    path.addLine (to: CGPoint (x: inLeft.midX, y: inTop.midY))
    path.addLine (to: CGPoint (x: inLeft.midX, y: inLeft.maxY))
    path.move (to: CGPoint (x: inTop.maxX + 2.0, y: inTop.midY))
    path.addLine (to: CGPoint (x: inRight.midX, y: inTop.midY))
    path.addLine (to: CGPoint (x: inRight.midX, y: inRight.maxY))
    path.move (to: CGPoint (x: inRight.midX, y: inRight.minY))
    path.addLine (to: CGPoint (x: inRight.midX, y: inBottom.midY))
    path.addLine (to: CGPoint (x: inBottom.maxX + 2.0, y: inBottom.midY))
    path.move (to: CGPoint (x: inBottom.minX - 2.0, y: inBottom.midY))
    path.addLine (to: CGPoint (x: inLeft.midX, y: inBottom.midY))
    path.addLine (to: CGPoint (x: inLeft.midX, y: inLeft.minY))
    return path
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private var minX : CanariLength? {
    var result : CanariLength? = nil
    for rect in self.mRectSet {
      if let r = result {
        if rect.minX != r {
          return nil
        }
      }else{
        result = rect.minX
      }
    }
    return result
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private var maxX : CanariLength? {
    var result : CanariLength? = nil
    for rect in self.mRectSet {
      if let r = result {
        if rect.maxX != r {
          return nil
        }
      }else{
        result = rect.maxX
      }
    }
    return result
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private var minY : CanariLength? {
    var result : CanariLength? = nil
    for rect in self.mRectSet {
      if let r = result {
        if rect.minY != r {
          return nil
        }
      }else{
        result = rect.minY
      }
    }
    return result
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private var maxY : CanariLength? {
    var result : CanariLength? = nil
    for rect in self.mRectSet {
      if let r = result {
        if rect.maxY != r {
          return nil
        }
      }else{
        result = rect.maxY
      }
    }
    return result
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private var width : CanariLength? {
    var result : CanariLength? = nil
    for rect in self.mRectSet {
      if let r = result {
        if rect.width != r {
          return nil
        }
      }else{
        result = rect.width
      }
    }
    return result
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private var height : CanariLength? {
    var result : CanariLength? = nil
    for rect in self.mRectSet {
      if let r = result {
        if rect.height != r {
          return nil
        }
      }else{
        result = rect.height
      }
    }
    return result
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------

fileprivate struct RectanglePrefKey : PreferenceKey {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  static let defaultValue : [String: Anchor<CGRect>] = [:]

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  static func reduce (value: inout [String : Anchor<CGRect>],
                      nextValue: () -> [String : Anchor<CGRect>]) {
    value.merge (nextValue ()) { _, new in new }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
}

//--------------------------------------------------------------------------------------------------
