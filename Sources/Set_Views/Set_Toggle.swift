//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 04/06/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct Set_Toggle : NSViewRepresentable {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @Binding private var mBinding : Set <Bool>
  private let title : String

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (_ inTitle : String, isOn : Binding <Set <Bool>>) {
    self._mBinding = isOn
    self.title = inTitle
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func makeNSView (context inContext : Context) -> NSButton {
    let button = NSButton (
      checkboxWithTitle: self.title,
      target: inContext.coordinator,
      action: #selector (Self.Coordinator.changed (_:))
    )
    button.allowsMixedState = true
    button.sizeToFit ()
    button.setContentHuggingPriority (.defaultHigh, for: .vertical)
    return button
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func state () ->  NSControl.StateValue {
    if self.mBinding.count == 1, let v = self.mBinding.first {
      return v ? .on : .off
    }else{
      return .mixed
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func updateNSView (_ inButton : NSButton,
                            context inContext : Context) {
    inButton.state = self.state ()
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func makeCoordinator () -> Self.Coordinator {
    Self.Coordinator (value: self.$mBinding)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public final class Coordinator: NSObject {
    private var mBinding : Binding <Set <Bool>>

    init (value: Binding<Set <Bool>>) {
      self.mBinding = value
    }

    @objc func changed (_ sender : NSButton) {
      switch sender.state {
      case .on:
        self.mBinding.wrappedValue = Set ([true])
      case .off:
        self.mBinding.wrappedValue = Set ([false])
      case .mixed:
        self.mBinding.wrappedValue = Set ([true])
      default:
        break
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
