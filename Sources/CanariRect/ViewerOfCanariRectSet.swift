//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 06/06/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct ViewerOfCanariRectSet : View {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private let mRectSet : Set <CanariRect>
  private let mUnit : CanariLength.Unit
  private let mFractionDigits : Int

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (rectSet inCanariRectSet : Set <CanariRect>,
               unit inUnit : CanariLength.Unit = .cm,
               fractionDigits inFractionDigits : Int = 2) {
    self.mRectSet = inCanariRectSet
    self.mUnit = inUnit
    self.mFractionDigits = inFractionDigits
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var body : some View {
    VStack {
      ViewerOfOptionalString (self.maxY?.string (in: self.mUnit, fractionDigits: self.mFractionDigits))
      .background (Rectangle ().fill (.white))
      .anchorPreference (key: CentersKey.self, value: .center) { ["bottom" : $0] }
      HStack {
        ViewerOfOptionalString (self.minX?.string (in: self.mUnit, fractionDigits: self.mFractionDigits))
        .background (Rectangle ().fill (.white))
        .anchorPreference (key: CentersKey.self, value: .center) { ["left" : $0] }
        Spacer ()
        ViewerOfOptionalString (self.maxX?.string (in: self.mUnit, fractionDigits: self.mFractionDigits))
        .background (Rectangle ().fill (.white))
        .anchorPreference (key: CentersKey.self, value: .center) { ["right" : $0] }
      }
      ViewerOfOptionalString (self.minY?.string (in: self.mUnit, fractionDigits: self.mFractionDigits))
      .background (Rectangle ().fill (.white))
      .anchorPreference (key: CentersKey.self, value: .center) { ["top" : $0] }
    }
    .backgroundPreferenceValue (CentersKey.self) { anchors in
      GeometryReader { proxy in
        let shape = Path { path in
          let top = proxy [anchors ["top"]!].y
          let left = proxy [anchors ["left"]!].x
          let right = proxy [anchors ["right"]!].x
          let bottom = proxy [anchors ["bottom"]!].y
          path.addRect (CGRect (origin: CGPoint (x: left, y: top), size: CGSize (width: right - left, height: bottom - top)))
        }
        ZStack {
          shape.fill (.gray.opacity (0.1))
          shape.stroke (style: StrokeStyle(lineWidth: 1, lineCap: .round, lineJoin: .round))
        }
      }
    }
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

fileprivate struct CentersKey : PreferenceKey {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  static let defaultValue : [String: Anchor<CGPoint>] = [:]

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  static func reduce (value: inout [String : Anchor<CGPoint>],
                      nextValue: () -> [String : Anchor<CGPoint>]) {
    value.merge(nextValue()) { _, new in new }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
}

//--------------------------------------------------------------------------------------------------
