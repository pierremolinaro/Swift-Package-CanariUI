//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 06/06/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct EditorOfCanariSizeSet : View {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private let mSizeSet : Set <CanariSize>
  private let mUnit : CanariLength.Unit
  private let mFractionDigits : Int
  private let mFieldWidth = 48.0
  private let mWidthSetter : (CanariLength) -> Void
  private let mHeightSetter : (CanariLength) -> Void

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (sizeSet inCanariSizeSet : Set <CanariSize>,
               widthSetter: @escaping (CanariLength) -> Void,
               heightSetter: @escaping (CanariLength) -> Void,
               unit inUnit : CanariLength.Unit = .cm,
               fractionDigits inFractionDigits : Int = 2) {
    self.mSizeSet = inCanariSizeSet
    self.mUnit = inUnit
    self.mFractionDigits = inFractionDigits
    self.mWidthSetter = widthSetter
    self.mHeightSetter = heightSetter
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var body : some View {
    LabeledContent (
      content: {
        EditorOfCanariLengthSet (
          lengthSet: Set (Array (self.mSizeSet).map (\.width)),
          setter: { self.mWidthSetter ($0) },
          unit: self.mUnit,
          fractionDigits: self.mFractionDigits,
          width: self.mFieldWidth,
          displayUnit: false
        )
      },
      label: { Text ("Width") }
    )
    LabeledContent (
      content: {
        EditorOfCanariLengthSet (
          lengthSet: Set (Array (self.mSizeSet).map (\.height)),
          setter: { self.mHeightSetter ($0) },
          unit: self.mUnit,
          fractionDigits: self.mFractionDigits,
          width: self.mFieldWidth,
          displayUnit: false
        )
      },
      label: { Text ("Height") }
    )
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
