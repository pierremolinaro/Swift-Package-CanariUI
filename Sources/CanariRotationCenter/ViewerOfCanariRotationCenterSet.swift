//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 04/06/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct ViewerOfCanariRotationCenterSet : View {

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

  private let mCenterSet : Set <CanariRotationCenter>
  private let mSetter : (CanariRotationCenter) -> Void

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (rotationCenterSet inRotationCenterSet : Set<CanariRotationCenter>,
               setter: @escaping (CanariRotationCenter) -> Void) {
    self.mCenterSet = inRotationCenterSet
    self.mSetter = setter
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var body : some View {
    HStack {
      VStack {
        RadioButton (isOn: self.topLeft, setter: { self.mSetter (.topLeft) } )
        RadioButton (isOn: self.middleLeft, setter: { self.mSetter (.middleLeft) } )
        RadioButton (isOn: self.bottomLeft, setter: { self.mSetter (.bottomLeft) } )
      }
      VStack {
        RadioButton (isOn: self.topCenter, setter: { self.mSetter (.topMiddle) } )
        RadioButton (isOn: self.center, setter: { self.mSetter (.center) } )
        RadioButton (isOn: self.bottomCenter, setter: { self.mSetter (.bottomMiddle) } )
      }
      VStack {
        RadioButton (isOn: self.topRight, setter: { self.mSetter (.topRight) } )
        RadioButton (isOn: self.middleRight, setter: { self.mSetter (.middleRight) } )
        RadioButton (isOn: self.bottomRight, setter: { self.mSetter (.bottomRight) } )
      }
    }
    .onChange (of: self.mCenterSet, initial: true) {
      self.topLeft      = self.mCenterSet.contains (.topLeft)
      self.middleLeft   = self.mCenterSet.contains (.middleLeft)
      self.bottomLeft   = self.mCenterSet.contains (.bottomLeft)
      self.topCenter    = self.mCenterSet.contains (.topMiddle)
      self.center       = self.mCenterSet.contains (.center)
      self.bottomCenter = self.mCenterSet.contains (.bottomMiddle)
      self.topRight     = self.mCenterSet.contains (.topRight)
      self.middleRight  = self.mCenterSet.contains (.middleRight)
      self.bottomRight  = self.mCenterSet.contains (.bottomRight)
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
