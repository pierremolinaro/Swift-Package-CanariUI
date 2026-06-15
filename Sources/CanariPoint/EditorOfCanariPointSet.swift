//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 06/06/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct EditorOfCanariPointSet : View {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private let mPointSet : Set <CanariPoint>
  private let mUnit : CanariLength.Unit
  private let mFractionDigits : Int
  private let mFieldWidth = 48.0
  private let mSetterX : (CanariLength) -> Void
  private let mSetterY : (CanariLength) -> Void
  private let mDisplayUnit : Bool

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (pointSet inCanariPointSet : Set <CanariPoint>,
               setterX: @escaping (CanariLength) -> Void,
               setterY: @escaping (CanariLength) -> Void,
               unit inUnit : CanariLength.Unit = .cm,
               fractionDigits inFractionDigits : Int = 2,
               displayUnit inDisplayUnit : Bool) {
    self.mPointSet = inCanariPointSet
    self.mUnit = inUnit
    self.mFractionDigits = inFractionDigits
    self.mSetterX = setterX
    self.mSetterY = setterY
    self.mDisplayUnit = inDisplayUnit
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var body : some View {
    LabeledContent (
      content: {
        EditorOfCanariLengthSet (
          lengthSet: Set (Array (self.mPointSet).map (\.x)),
          setter: { self.mSetterX ($0) },
          unit: self.mUnit,
          fractionDigits: self.mFractionDigits,
          width: self.mFieldWidth,
          displayUnit: self.mDisplayUnit
        )
      },
      label: { Text ("X") }
    )
    LabeledContent (
      content: {
        EditorOfCanariLengthSet (
          lengthSet: Set (Array (self.mPointSet).map (\.y)),
          setter: { self.mSetterY ($0) },
          unit: self.mUnit,
          fractionDigits: self.mFractionDigits,
          width: self.mFieldWidth,
          displayUnit: self.mDisplayUnit
        )
      },
      label: { Text ("Y") }
    )
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
