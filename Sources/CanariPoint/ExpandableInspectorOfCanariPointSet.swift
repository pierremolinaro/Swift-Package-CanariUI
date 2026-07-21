//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 18/06/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct ExpandableInspectorOfCanariPointSet : View {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private let mTitle : String
  private let mPointSet : Set <CanariPoint>
  private let mUnit : EditorOfCanariLengthSet.DisplayUnit
  private let mFractionDigits : Int
  private let mFieldWidth = 48.0
  private let mSetterX : (CanariLength) -> Void
  private let mSetterY : (CanariLength) -> Void
  @Binding private var mIsExpanded : Bool

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (title inTitle : String,
               isExpanded inIsExpanded : Binding <Bool>,
               displayUnit inUnit : EditorOfCanariLengthSet.DisplayUnit,
               fractionDigits inFractionDigits : Int,
               pointSet inCanariPointSet : Set <CanariPoint>,
               setterX: @escaping (CanariLength) -> Void,
               setterY: @escaping (CanariLength) -> Void) {
    self.mTitle = inTitle
    self.mPointSet = inCanariPointSet
    self.mUnit = inUnit
    self.mFractionDigits = inFractionDigits
    self.mSetterX = setterX
    self.mSetterY = setterY
    self._mIsExpanded = inIsExpanded
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var body : some View {
    CanariExpandableInspectorView (title: "Center", expandedSubtitle: "cm", isExpanded: self.$mIsExpanded) {
      HStack {
        Spacer ()
        Form {
          EditorOfCanariPointSet (
            pointSet: self.mPointSet,
            setterX: { newX in self.mSetterX (newX) },
            setterY: { newY in self.mSetterY (newY) },
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
