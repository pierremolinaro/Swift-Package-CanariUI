//
//  View+onWillDisappear.swift
//  CanariUI
//
//  Created by Pierre Molinaro on 20/08/2026.
//
import SwiftUI
import AppKit

public extension View {
    func onWillDisappear (_ perform: @escaping () -> Void) -> some View {
        self.background(WillDisappearHandler(onWillDisappear: perform))
    }
}

struct WillDisappearHandler: NSViewControllerRepresentable {
    let onWillDisappear: () -> Void

    func makeNSViewController(context: Context) -> NSViewController {
        context.coordinator
    }

    func updateNSViewController(_ nsViewController: NSViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(onWillDisappear: onWillDisappear)
    }

    class Coordinator: NSViewController {
        let onWillDisappear: () -> Void

        init(onWillDisappear: @escaping () -> Void) {
            self.onWillDisappear = onWillDisappear
            super.init(nibName: nil, bundle: nil)
        }

        required init?(coder: NSCoder) { fatalError() }

        override func loadView() {
            // Vue invisible, de taille nulle
            view = NSView(frame: .zero)
        }

        override func viewWillDisappear() {
          print ("onWillDisappear")
            onWillDisappear()
            super.viewWillDisappear()
        }
    }
}
