//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 04/06/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct InspectorOfBoolSet : NSViewRepresentable {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private let mValueSet : Set <Bool>
  private let title : String
  private let mSetter : (Bool) -> Void

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (title inTitle : String,
               valueSet inSet : Set <Bool>,
               setter: @escaping (Bool) -> Void) {
    self.mValueSet = inSet
    self.title = inTitle
    self.mSetter = setter
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
    if let v = self.mValueSet.first, self.mValueSet.count == 1 {
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
    Self.Coordinator (setter: self.mSetter)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public final class Coordinator : NSObject {
    private let mSetter : (Bool) -> Void

    init (setter inSetter : @escaping (Bool) -> Void) {
      self.mSetter = inSetter
    }

    @MainActor @objc func changed (_ sender : NSButton) {
      switch sender.state {
      case .on:
        self.mSetter (true)
      case .off:
        self.mSetter (false)
      case .mixed:
        self.mSetter (true)
      default:
        break
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
