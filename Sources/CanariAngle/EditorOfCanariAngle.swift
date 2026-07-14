//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 14/07/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct EditorOfCanariAngle : View {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @Binding private var mAngle : CanariAngle
  @State private var mDoubleValue : Double
  private let mWidth : CGFloat = 64.0

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (_ inAngle : Binding <CanariAngle>) {
    self._mAngle = inAngle
    self.mDoubleValue = inAngle.wrappedValue.value (in: .degrees)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var body : some View {
    HStack (spacing: 4) {
      TextField (
        "",
        value: self.$mDoubleValue,
        format: .number.precision (.fractionLength (3)),
        prompt: Text (MULTIPLE_VALUES_MARK)
      )
      .onSubmit {
        self.mAngle = CanariAngle (self.mDoubleValue, in: .degrees)
      }
      .labelsHidden ()
      .frame (width: self.mWidth)
      .onChange (of: self.mAngle) {
        self.mDoubleValue = self.mAngle.value (in: .degrees)
      }
      Text ("°")
      Stepper {
        EmptyView ()
      } onIncrement: {
        self.mAngle += .degrees (1)
      } onDecrement: {
        self.mAngle -= .degrees (1)
      }.help ("± 1°")
      Stepper {
        EmptyView ()
      } onIncrement: {
        self.mAngle += .degrees (0.1)
      } onDecrement: {
        self.mAngle -= .degrees (0.1)
      }.help ("± 0.1°")
      VStack (spacing: 0) {
        ControlGroup ("") {
          Button ("0°", systemImage: "arrow.right") { self.mAngle = .zero }.labelsHidden().help ("0°")
          Button ("90°", systemImage: "arrow.up") { self.mAngle = .degrees90 }.labelsHidden().help ("90°")
          Button ("180°", systemImage: "arrow.left") { self.mAngle = .degrees180 }.labelsHidden().help ("180°")
          Button ("-90°", systemImage: "arrow.down") { self.mAngle = .degrees270 }.labelsHidden().help ("270°")
        }.controlGroupStyle (.automatic)
        ControlGroup ("") {
          Button ("45°", systemImage: "arrow.up.right") { self.mAngle = .degrees45 }.labelsHidden().help ("45°")
          Button ("135°", systemImage: "arrow.up.left") { self.mAngle = .degrees135 }.labelsHidden().help ("135°")
          Button ("225°", systemImage: "arrow.down.left") { self.mAngle = .degrees225 }.labelsHidden().help ("-135°")
          Button ("315°", systemImage: "arrow.down.right") { self.mAngle = .degrees315 }.labelsHidden().help ("-45°")
        }.controlGroupStyle (.automatic)
      }.controlSize (.mini)
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
