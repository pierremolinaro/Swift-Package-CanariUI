//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 08/08/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct CanariTritEditor : View {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private let mTitle : String
  private let mItemsTitles : [CanariTrit : String]
  private let mPickerStyle : any PickerStyle
  @Binding private var mValue : CanariTrit

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (title inTitle : String,
               itemTitles inItemsTitles : [CanariTrit : String] = [:],
               pickerStyle inPickerStyle : any PickerStyle,
               value inValue : Binding <CanariTrit>) {
    self.mTitle = inTitle
    self.mItemsTitles = inItemsTitles
    self.mPickerStyle = inPickerStyle
    self._mValue = inValue
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var body : some View {
    Picker (self.mTitle, selection: self.$mValue) {
      ForEach (CanariTrit.allCases) { value in
        Text (self.mItemsTitles [value] ?? "\(value.rawValue)").tag (value)
      }
    }
//    .pickerStyle (.inline)
    .pickerStyle (.menu)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
