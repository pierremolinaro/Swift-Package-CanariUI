//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 06/06/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI
import CanariGeometry

//--------------------------------------------------------------------------------------------------

public struct EditorOfCanariSizeSet : View {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private let mSizeSet : Set <CanariSize>
  private let mUnit : CanariLength.DisplayUnit
  private let mFractionDigits : Int
  private let mFieldWidth = 48.0
  private let mWidthSetter : (CanariLength) -> Void
  private let mHeightSetter : (CanariLength) -> Void
  private let mWidthIncrementer : (CanariLength) -> Void
  private let mHeightIncrementer : (CanariLength) -> Void

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (sizeSet inCanariSizeSet : Set <CanariSize>,
               widthSetter: @escaping (CanariLength) -> Void,
               widthIncrementer: @escaping (CanariLength) -> Void,
               heightSetter: @escaping (CanariLength) -> Void,
               heightIncrementer: @escaping (CanariLength) -> Void,
               displayUnit inUnit : CanariLength.DisplayUnit,
               fractionDigits inFractionDigits : Int) {
    self.mSizeSet = inCanariSizeSet
    self.mUnit = inUnit
    self.mFractionDigits = inFractionDigits
    self.mWidthSetter = widthSetter
    self.mHeightSetter = heightSetter
    self.mWidthIncrementer = widthIncrementer
    self.mHeightIncrementer = heightIncrementer
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var body : some View {
    LabeledContent (
      content: {
        EditorOfCanariLengthSet (
          lengthSet: Set (Array (self.mSizeSet).map (\.width)),
          setter: { self.mWidthSetter ($0) },
          incrementer: { self.mWidthIncrementer ($0) },
          displayUnit: self.mUnit,
          fractionDigits: self.mFractionDigits,
          width: self.mFieldWidth
        )
      },
      label: { Text ("Width") }
    )
    LabeledContent (
      content: {
        EditorOfCanariLengthSet (
          lengthSet: Set (Array (self.mSizeSet).map (\.height)),
          setter: { self.mHeightSetter ($0) },
          incrementer: { self.mHeightIncrementer ($0) },
          displayUnit: self.mUnit,
          fractionDigits: self.mFractionDigits,
          width: self.mFieldWidth
        )
      },
      label: { Text ("Height") }
    )
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
