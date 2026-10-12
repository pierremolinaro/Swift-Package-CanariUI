//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 18/06/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI
import CanariGeometry

//--------------------------------------------------------------------------------------------------

public struct ExpandableInspectorOfCanariPointSet : View {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private let mTitle : String
  private let mPointSet : Set <CanariPoint>
  private let mUnit : CanariLength.DisplayUnit
  private let mFractionDigits : Int
  private let mFieldWidth = 48.0
  private let mSetterX : (CanariLength) -> Void
  private let mSetterY : (CanariLength) -> Void
  private let mIncrementerX : (CanariLength) -> Void
  private let mIncrementerY : (CanariLength) -> Void
  @Binding private var mIsExpanded : Bool

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (title inTitle : String,
               isExpanded inIsExpanded : Binding <Bool>,
               displayUnit inUnit : CanariLength.DisplayUnit,
               fractionDigits inFractionDigits : Int,
               pointSet inCanariPointSet : Set <CanariPoint>,
               setterX: @escaping (CanariLength) -> Void,
               incrementerX: @escaping (CanariLength) -> Void,
               setterY: @escaping (CanariLength) -> Void,
               incrementerY: @escaping (CanariLength) -> Void) {
    self.mTitle = inTitle
    self.mPointSet = inCanariPointSet
    self.mUnit = inUnit
    self.mFractionDigits = inFractionDigits
    self.mSetterX = setterX
    self.mSetterY = setterY
    self.mIncrementerX = incrementerX
    self.mIncrementerY = incrementerY
    self._mIsExpanded = inIsExpanded
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var body : some View {
    CanariExpandableInspectorView (
      title: "Center",
      isExpanded: self.$mIsExpanded,
      collapsedSubtitle: { Text (self.collapsedTitle) }
    ) {
      HStack {
        Spacer ()
        Form {
          EditorOfCanariPointSet (
            pointSet: self.mPointSet,
            setterX: { newX in self.mSetterX (newX) },
            incrementerX: { newX in self.mIncrementerX (newX) },
            setterY: { newY in self.mSetterY (newY) },
            incrementerY: { newX in self.mIncrementerY (newX) },
            displayUnit: self.mUnit,
            fractionDigits: self.mFractionDigits
          )
        }
        Spacer ()
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private var collapsedTitle : String {
    if let p = self.mPointSet.first, self.mPointSet.count == 1 {
      return p.string (in: self.mUnit.unit, fractionDigits: self.mFractionDigits)
    }else{
      return MULTIPLE_VALUES_MARK
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
