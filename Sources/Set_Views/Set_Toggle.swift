//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 04/06/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct RotationCenterSelectionView : View {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @State private var topLeft : Bool = true
  @State private var middleLeft : Bool = true
  @State private var bottomLeft : Bool = true
  @State private var topCenter : Bool = true
  @State private var center : Bool = true
  @State private var bottomCenter : Bool = true
  @State private var topRight : Bool = true
  @State private var middleRight : Bool = true
  @State private var bottomRight : Bool = true

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init () {
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var body : some View {
    HStack {
      VStack {
        RadioButton (isOn: self.$topLeft)
        RadioButton (isOn: self.$middleLeft)
        RadioButton (isOn: self.$bottomLeft)
      }
      VStack {
        RadioButton (isOn: self.$topCenter)
        RadioButton (isOn: self.$center)
        RadioButton (isOn: self.$bottomCenter)
      }
      VStack {
        RadioButton (isOn: self.$topRight)
        RadioButton (isOn: self.$middleRight)
        RadioButton (isOn: self.$bottomRight)
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------

fileprivate struct RadioButton : NSViewRepresentable {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @Binding private var mValue : Bool

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (isOn : Binding <Bool>) {
    self._mValue = isOn
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func makeNSView (context inContext : Context) -> NSButton {
    let button = NSButton (
      radioButtonWithTitle: "",
      target: inContext.coordinator,
      action: #selector (Self.Coordinator.changed (_:))
    )
    button.sizeToFit ()
    button.setContentHuggingPriority (.defaultHigh, for: .horizontal)
    button.setContentHuggingPriority (.defaultHigh, for: .vertical)
    return button
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func updateNSView (_ inButton : NSButton,
                            context inContext : Context) {
    inButton.state = self.mValue ? .on : .off
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func makeCoordinator () -> Self.Coordinator {
    Self.Coordinator (value: self.$mValue)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public final class Coordinator: NSObject {
    private var mValue : Binding <Bool>

    init (value: Binding <Bool>) {
      self.mValue = value
    }

    @objc func changed (_ sender : NSButton) {
      self.mValue.wrappedValue = true
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
