//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 07/06/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct EditorOfCanariAngleSet : View {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @State private var mDoubleValue : Double?
  private let mAngleArray : [CanariAngle]
  private let mWidth : CGFloat = 64.0
  private let mSetter : (CanariAngle) -> Void

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (angleSet inLengthSet : Set <CanariAngle>,
               setter inSetter: @escaping (CanariAngle) -> Void) {
    self.mAngleArray = Array (inLengthSet).sorted ()
    if inLengthSet.count == 1, let v = inLengthSet.first {
      self.mDoubleValue = v.value (in: .degrees)
    }else{
      self.mDoubleValue = nil
    }
    self.mSetter = inSetter
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
        if let v = self.mDoubleValue {
          self.mSetter (CanariAngle (v, in: .degrees))
        }
      }
      .labelsHidden ()
      .frame (width: self.mWidth)
      .onChange (of: self.mAngleArray) {
        if self.mAngleArray.count == 1, let v = self.mAngleArray.first {
          self.mDoubleValue = v.value (in: .degrees)
        }else{
          self.mDoubleValue = nil
        }
      }
      Text ("°")
//      Stepper {
//        EmptyView ()
//      } onIncrement: {
//        self.mSetter (CanariAngle (self.mDoubleValue!, in: .degrees) + .degrees (10))
//      } onDecrement: {
//        self.mSetter (CanariAngle (self.mDoubleValue!, in: .degrees) - .degrees (10))
//      }.help ("10°").hiddenWhen (self.mDoubleValue == nil).controlSize (.small)
//      .overlay {
//        if self.mAngleArray.count > 1 {
//          Menu ("") {
//            ForEach (self.mAngleArray, id: \.self) { angle in
//              Button (angle.string (in: .degrees, fractionDigits: 3)) { self.mSetter (angle) }
//            }
//          }.buttonStyle (.borderless)
//        }
//      }
      Stepper {
        EmptyView ()
      } onIncrement: {
        self.mSetter (CanariAngle (self.mDoubleValue!, in: .degrees) + .degrees (1))
      } onDecrement: {
        self.mSetter (CanariAngle (self.mDoubleValue!, in: .degrees) - .degrees (1))
      }.help ("± 1°").hiddenWhen (self.mDoubleValue == nil).controlSize (.small)
      .overlay {
        if self.mAngleArray.count > 1 {
          Menu ("") {
            ForEach (self.mAngleArray, id: \.self) { angle in
              Button (angle.string (in: .degrees, fractionDigits: 3)) { self.mSetter (angle) }
            }
          }.buttonStyle (.borderless)
        }
      }
      Stepper {
        EmptyView ()
      } onIncrement: {
        self.mSetter (CanariAngle (self.mDoubleValue!, in: .degrees) + .degrees (0.1))
      } onDecrement: {
        self.mSetter (CanariAngle (self.mDoubleValue!, in: .degrees) - .degrees (0.1))
      }.help ("± 0.1°").hiddenWhen (self.mDoubleValue == nil).controlSize (.small)
      VStack (spacing: 0) {
        ControlGroup ("") {
          Button ("0°", systemImage: "arrow.right") { self.mSetter (.zero) }.labelsHidden().help ("0°")
          Button ("90°", systemImage: "arrow.up") { self.mSetter (.degrees90) }.labelsHidden().help ("90°")
          Button ("180°", systemImage: "arrow.left") { self.mSetter (.degrees180) }.labelsHidden().help ("180°")
          Button ("-90°", systemImage: "arrow.down") { self.mSetter (.degrees270) }.labelsHidden().help ("270°")
        }.controlGroupStyle (.automatic)
        ControlGroup ("") {
          Button ("45°", systemImage: "arrow.up.right") { self.mSetter (.degrees45) }.labelsHidden().help ("45°")
          Button ("135°", systemImage: "arrow.up.left") { self.mSetter (.degrees135) }.labelsHidden().help ("135°")
          Button ("225°", systemImage: "arrow.down.left") { self.mSetter (.degrees225) }.labelsHidden().help ("-135°")
          Button ("315°", systemImage: "arrow.down.right") { self.mSetter (.degrees315) }.labelsHidden().help ("-45°")
        }.controlGroupStyle (.automatic)
      }.controlSize (.mini)
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
