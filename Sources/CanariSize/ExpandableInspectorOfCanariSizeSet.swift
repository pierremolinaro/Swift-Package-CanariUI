//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 06/06/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct ExpandableInspectorOfCanariSizeSet : View {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private let mTitle : String
  private let mSizeSet : Set <CanariSize>
  private let mUnit : CanariLength.DisplayUnit
  private let mFractionDigits : Int
  private let mFieldWidth = 48.0
  private let mWidthSetter : (CanariLength) -> Void
  private let mHeightSetter : (CanariLength) -> Void
  @Binding private var mIsExpanded : Bool

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (title inTitle : String,
               isExpanded inIsExpanded : Binding <Bool>,
               displayUnit inUnit : CanariLength.DisplayUnit,
               fractionDigits inFractionDigits : Int,
               sizeSet inCanariSizeSet : Set <CanariSize>,
               widthSetter: @escaping (CanariLength) -> Void,
               heightSetter: @escaping (CanariLength) -> Void) {
    self.mTitle = inTitle
    self._mIsExpanded = inIsExpanded
    self.mSizeSet = inCanariSizeSet
    self.mUnit = inUnit
    self.mFractionDigits = inFractionDigits
    self.mWidthSetter = widthSetter
    self.mHeightSetter = heightSetter
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var body : some View {
    CanariExpandableInspectorView (
      title: self.mTitle,
      collapsedSubtitle: self.collapsedTitle,
      isExpanded: self.$mIsExpanded
    ) {
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

  var collapsedTitle : String {
    if let s = self.mSizeSet.first, self.mSizeSet.count == 1 {
      return s.string (in: self.mUnit.unit, fractionDigits: self.mFractionDigits)
    }else{
      return MULTIPLE_VALUES_MARK
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
