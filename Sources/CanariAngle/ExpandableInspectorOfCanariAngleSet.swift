//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 21/07/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct ExpandableInspectorOfCanariAngleSet : View {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private let mTitle : String
  private let mAngleSet : Set <CanariAngle>
  private let mFractionDigits : Int
  private let mFieldWidth = 48.0
  private let mSetter : (CanariAngle) -> Void
  @Binding private var mIsExpanded : Bool

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (title inTitle : String,
               isExpanded inIsExpanded : Binding <Bool>,
               fractionDigits inFractionDigits : Int,
               angleSet inAngleSet : Set <CanariAngle>,
               setter: @escaping (CanariAngle) -> Void) {
    self.mTitle = inTitle
    self.mAngleSet = inAngleSet
    self.mFractionDigits = inFractionDigits
    self.mSetter = setter
    self._mIsExpanded = inIsExpanded
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var body : some View {
    CanariExpandableInspectorView (
      title: self.mTitle,
      isExpanded: self.$mIsExpanded,
      collapsedSubtitle: { Text (self.collapsedTitle) }
    ) {
      EditorOfCanariAngleSet (
        angleSet: mAngleSet,
        setter: { self.mSetter ($0) }
      )
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  var collapsedTitle : String {
    if let p = self.mAngleSet.first, self.mAngleSet.count == 1 {
      return p.string (in: .degrees, fractionDigits: self.mFractionDigits)
    }else{
      return MULTIPLE_VALUES_MARK
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------

