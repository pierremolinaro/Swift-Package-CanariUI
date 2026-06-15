//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 06/06/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct Inspector_CanariSize : View {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private let mTitle : String
  private let mSizeSet : Set <CanariSize>
  private let mUnit : CanariLength.Unit
  private let mFractionDigits : Int
  private let mFieldWidth = 48.0
  private let mWidthSetter : (CanariLength) -> Void
  private let mHeightSetter : (CanariLength) -> Void

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (title inTitle : String,
               sizeSet inCanariSizeSet : Set <CanariSize>,
               widthSetter: @escaping (CanariLength) -> Void,
               heightSetter: @escaping (CanariLength) -> Void,
               unit inUnit : CanariLength.Unit = .cm,
               fractionDigits inFractionDigits : Int = 2) {
    self.mTitle = inTitle
    self.mSizeSet = inCanariSizeSet
    self.mUnit = inUnit
    self.mFractionDigits = inFractionDigits
    self.mWidthSetter = widthSetter
    self.mHeightSetter = heightSetter
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var body : some View {
    CanariElementInspector (title: self.mTitle, subTitle: "cm") {
      HStack {
        Spacer ()
        Form {
          Set_CanariSizeEditor (
            sizeSet: self.mSizeSet,
            widthSetter: { newWidth in self.mWidthSetter (newWidth) },
            heightSetter: { newHeight in self.mHeightSetter (newHeight) },
            unit: self.mUnit,
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
