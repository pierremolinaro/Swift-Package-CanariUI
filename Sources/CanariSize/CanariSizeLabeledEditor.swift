//
//  CanariSizeLabeledEditor.swift
//  editeur-courbes-bezier
//
//  Created by Pierre Molinaro on 21/09/2025.
//
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct CanariSizeLabeledEditor : View {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @Binding private var mSizeBinding : CanariSize
  private let mDisplayUnit : CanariLength.DisplayUnit
  private let mFractionDigits : Int
  private let mWidth : CGFloat?

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (value inSizeBinding : Binding <CanariSize>,
               displayUnit inUnit : CanariLength.DisplayUnit,
               fractionDigits inFractionDigits : Int,
               width inWidth : CGFloat? = nil) {
    self._mSizeBinding = inSizeBinding
    self.mDisplayUnit = inUnit
    self.mFractionDigits = inFractionDigits
    self.mWidth = inWidth
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var body : some View {
    LabeledContent {
      EditorOfCanariLengthSet (
        lengthSet: Set ([self.mSizeBinding.width]),
        setter: { self.mSizeBinding.width = $0 },
        displayUnit: self.mDisplayUnit,
        fractionDigits: self.mFractionDigits,
        width: 64
      )
    }label: {
      Text ("Width")
    }
    LabeledContent {
      EditorOfCanariLengthSet (
        lengthSet: Set ([self.mSizeBinding.height]),
        setter: { self.mSizeBinding.height = $0 },
        displayUnit: self.mDisplayUnit,
        fractionDigits: self.mFractionDigits,
        width: 64
      )
    }label: {
      Text ("Height")
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------



