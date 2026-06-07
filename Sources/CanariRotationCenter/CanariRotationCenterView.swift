//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 04/06/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct CanariRotationCenterView : View {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  @State private var topLeft : Bool = false
  @State private var middleLeft : Bool = false
  @State private var bottomLeft : Bool = false
  @State private var topCenter : Bool = false
  @State private var center : Bool = false
  @State private var bottomCenter : Bool = false
  @State private var topRight : Bool = false
  @State private var middleRight : Bool = false
  @State private var bottomRight : Bool = false

  @Binding private var mCenter : CanariRotationCenter

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (rotationCenter inRotationCenter : Binding<CanariRotationCenter>) {
    self._mCenter = inRotationCenter
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var body : some View {
    HStack {
      VStack {
        RadioButton (isOn: self.topLeft, setter: { self.mCenter = .topLeft } )
        RadioButton (isOn: self.middleLeft, setter: { self.mCenter = .middleLeft } )
        RadioButton (isOn: self.bottomLeft, setter: { self.mCenter = .bottomLeft } )
      }
      VStack {
        RadioButton (isOn: self.topCenter, setter: { self.mCenter = .topMiddle } )
        RadioButton (isOn: self.center, setter: { self.mCenter = .center } )
        RadioButton (isOn: self.bottomCenter, setter: { self.mCenter = .bottomMiddle } )
      }
      VStack {
        RadioButton (isOn: self.topRight, setter: { self.mCenter = .topRight } )
        RadioButton (isOn: self.middleRight, setter: { self.mCenter = .middleRight } )
        RadioButton (isOn: self.bottomRight, setter: { self.mCenter = .bottomRight } )
      }
    }
    .onChange (of: self.mCenter, initial: true) {
      self.topLeft      = self.mCenter == .topLeft
      self.middleLeft   = self.mCenter == .middleLeft
      self.bottomLeft   = self.mCenter == .bottomLeft
      self.topCenter    = self.mCenter == .topMiddle
      self.center       = self.mCenter == .center
      self.bottomCenter = self.mCenter == .bottomMiddle
      self.topRight     = self.mCenter == .topRight
      self.middleRight  = self.mCenter == .middleRight
      self.bottomRight  = self.mCenter == .bottomRight
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------

fileprivate struct RadioButton : NSViewRepresentable {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private let mValue : Bool
  private let mSetter : () -> Void

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (isOn : Bool, setter : @escaping () -> Void) {
    self.mValue = isOn
    self.mSetter = setter
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
    Self.Coordinator (value: self.mValue, setter: self.mSetter)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public final class Coordinator : NSObject {
    private let mValue : Bool
    private let mSetter : () -> Void

    init (value: Bool, setter : @escaping () -> Void) {
      self.mValue = value
      self.mSetter = setter
    }

    @objc func changed (_ sender : NSButton) {
      self.mSetter ()
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
