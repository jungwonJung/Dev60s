//
//  PremiumBackground.swift
//  Dev60s
//
//  Reusable breathable mesh gradient background modifier
//

import SwiftUI

// MARK: - Premium Background ViewModifier

struct PremiumBackgroundModifier: ViewModifier {
    @State private var gradientOffset: Double = 0
    
    func body(content: Content) -> some View {
        ZStack {
            // Breathable Mesh Gradient Background
            ZStack {
                // Base gradient layer with animated points
                LinearGradient(
                    colors: [
                        Color(red: 0.08, green: 0.10, blue: 0.20), // Deep Navy
                        Color(red: 0.05, green: 0.05, blue: 0.08), // Charcoal
                        Color(red: 0.12, green: 0.08, blue: 0.18)  // Deep Purple
                    ],
                    startPoint: UnitPoint(
                        x: 0.5 + 0.3 * CGFloat(cos(gradientOffset)),
                        y: 0.5 + 0.3 * CGFloat(sin(gradientOffset))
                    ),
                    endPoint: UnitPoint(
                        x: 0.5 - 0.3 * CGFloat(cos(gradientOffset)),
                        y: 0.5 - 0.3 * CGFloat(sin(gradientOffset))
                    )
                )
                
                // Overlay with neon purple hints
                RadialGradient(
                    colors: [
                        Color(red: 0.4, green: 0.2, blue: 0.8).opacity(0.15),
                        Color.clear
                    ],
                    center: UnitPoint(
                        x: 0.5 + 0.2 * CGFloat(cos(gradientOffset + .pi / 2)),
                        y: 0.5 + 0.2 * CGFloat(sin(gradientOffset + .pi / 2))
                    ),
                    startRadius: 100,
                    endRadius: 400
                )
            }
            .ignoresSafeArea()
            .onAppear {
                withAnimation(.easeInOut(duration: 4.0).repeatForever(autoreverses: true)) {
                    gradientOffset = .pi * 2
                }
            }
            
            content
        }
    }
}

// MARK: - View Extension

extension View {
    func premiumBackground() -> some View {
        modifier(PremiumBackgroundModifier())
    }
}





