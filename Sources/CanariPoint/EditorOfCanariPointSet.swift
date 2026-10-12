//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 06/06/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI
import CanariGeometry

//--------------------------------------------------------------------------------------------------

public struct EditorOfCanariPointSet : View {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private let mPointSet : Set <CanariPoint>
  private let mUnit : CanariLength.DisplayUnit
  private let mFractionDigits : Int
  private let mFieldWidth = 48.0
  private let mSetterX : (CanariLength) -> Void
  private let mSetterY : (CanariLength) -> Void
  private let mIncrementerX : (CanariLength) -> Void
  private let mIncrementerY : (CanariLength) -> Void

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (pointSet inCanariPointSet : Set <CanariPoint>,
               setterX: @escaping (CanariLength) -> Void,
               incrementerX inIncrementerX : @escaping (CanariLength) -> Void,
               setterY: @escaping (CanariLength) -> Void,
               incrementerY inIncrementerY : @escaping (CanariLength) -> Void,
               displayUnit inUnit : CanariLength.DisplayUnit,
               fractionDigits inFractionDigits : Int) {
    self.mPointSet = inCanariPointSet
    self.mUnit = inUnit
    self.mFractionDigits = inFractionDigits
    self.mSetterX = setterX
    self.mSetterY = setterY
    self.mIncrementerX = inIncrementerX
    self.mIncrementerY = inIncrementerY
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var body : some View {
    LabeledContent (
      content: {
        EditorOfCanariLengthSet (
          lengthSet: Set (Array (self.mPointSet).map (\.x)),
          setter: { self.mSetterX ($0) },
          incrementer: { self.mIncrementerX ($0) },
          displayUnit: self.mUnit,
          fractionDigits: self.mFractionDigits,
          width: self.mFieldWidth
        )
      },
      label: { Text ("X") }
    )
    LabeledContent (
      content: {
        EditorOfCanariLengthSet (
          lengthSet: Set (Array (self.mPointSet).map (\.y)),
          setter: { self.mSetterY ($0) },
          incrementer: { self.mIncrementerY ($0) },
          displayUnit: self.mUnit,
          fractionDigits: self.mFractionDigits,
          width: self.mFieldWidth
        )
      },
      label: { Text ("Y") }
    )
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
