//
//  SquishyButtonStyle.swift
//  Dev60s
//
//  Reusable button style with squishy press animation
//

import SwiftUI

struct SquishyButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.92 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isPressed)
    }
}



