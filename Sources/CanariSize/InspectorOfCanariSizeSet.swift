//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 06/06/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct InspectorOfCanariSizeSet : View {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private let mTitle : String
  private let mSizeSet : Set <CanariSize>
  private let mUnit : EditorOfCanariLengthSet.DisplayUnit
  private let mFractionDigits : Int
  private let mFieldWidth = 48.0
  private let mWidthSetter : (CanariLength) -> Void
  private let mHeightSetter : (CanariLength) -> Void

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (title inTitle : String,
               displayUnit inUnit : EditorOfCanariLengthSet.DisplayUnit,
               fractionDigits inFractionDigits : Int,
               sizeSet inCanariSizeSet : Set <CanariSize>,
               widthSetter: @escaping (CanariLength) -> Void,
               heightSetter: @escaping (CanariLength) -> Void) {
    self.mTitle = inTitle
    self.mSizeSet = inCanariSizeSet
    self.mUnit = inUnit
    self.mFractionDigits = inFractionDigits
    self.mWidthSetter = widthSetter
    self.mHeightSetter = heightSetter
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var body : some View {
    CanariElementInspector (title: self.mTitle, expandedSubtitle: "cm") {
      HStack {
        Spacer ()
        Form {
          EditorOfCanariSizeSet (
            sizeSet: self.mSizeSet,
            widthSetter: { newWidth in self.mWidthSetter (newWidth) },
            heightSetter: { newHeight in self.mHeightSetter (newHeight) },
            displayUnit: self.mUnit,
            fractionDigits: self.mFractionDigits
          )
        }
        Spacer ()
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
