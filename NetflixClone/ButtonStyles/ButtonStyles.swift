//
//  ButtonStyles.swift
//  NetflixClone
//
//  Created by Glenn Brannelly on 1/17/23.
//

import Foundation
import SwiftUI

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .onChange(of: configuration.isPressed) { _ in
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            }
    }
}

struct CardScaleButtonStyle: ButtonStyle {
    @State private var isPressed: Bool = false
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(isPressed ? 0.97 : 1)
            .onChange(of: configuration.isPressed) { isPressed in
                self.isPressed = isPressed
            }
            .animation(.easeInOut(duration: 0.1), value: isPressed)
    }
}

