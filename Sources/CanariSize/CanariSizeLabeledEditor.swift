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
  private let mUnit : CanariLength.Unit
  private let mFractionDigits : Int
  private let mWidth : CGFloat?

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (value inSizeBinding : Binding <CanariSize>,
               unit inUnit : CanariLength.Unit = .cm,
               fractionDigits inFractionDigits : Int,
               width inWidth : CGFloat? = nil) {
    self._mSizeBinding = inSizeBinding
    self.mUnit = inUnit
    self.mFractionDigits = inFractionDigits
    self.mWidth = inWidth
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var body : some View {
    LabeledContent {
      EditorOfCanariLength (
        value: self.$mSizeBinding.width,
        unit: self.mUnit,
        fractionDigits: self.mFractionDigits,
        width: self.mWidth
      )
    }label: {
      Text ("Width")
    }
    LabeledContent {
      EditorOfCanariLength (
        value: self.$mSizeBinding.height,
        unit: self.mUnit,
        fractionDigits: self.mFractionDigits,
        width: self.mWidth
      )
    }label: {
      Text ("Height")
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------



