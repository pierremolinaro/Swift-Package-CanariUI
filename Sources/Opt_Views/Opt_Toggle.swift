//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 04/06/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct Opt_Toggle : NSViewRepresentable {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @Binding private var mBinding : Bool?
  private let title : String

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (_ inTitle : String, isOn : Binding <Bool?>) {
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
    if let v = self.mBinding {
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

  public final class Coordinator : NSObject {
    private var mBinding : Binding<Bool?>

    init (value: Binding<Bool?>) {
      self.mBinding = value
    }

    @MainActor @objc func changed (_ sender : NSButton) {
      switch sender.state {
      case .on:
        self.mBinding.wrappedValue = true
      case .off:
        self.mBinding.wrappedValue = false
      case .mixed:
        self.mBinding.wrappedValue = true
      default:
        break
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
