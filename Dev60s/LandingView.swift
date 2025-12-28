//
//  LandingView.swift
//  Dev60s
//
//  Premium futuristic landing screen with glassmorphic design
//

import SwiftUI
import UIKit

struct LandingView: View {
    let handleGetStarted: () -> Void
    
    @State private var shimmerOffset: CGFloat = -200
    @State private var sphereOffset: CGFloat = 0
    @State private var rotationAngle: Double = 0
    @State private var buttonOpacity: Double = 0
    @State private var buttonOffset: CGFloat = 30
    @State private var gradientOffset: Double = 0
    
    var body: some View {
        ZStack {
            // Dynamic Mesh Gradient Background
            animatedGradientBackground
                .ignoresSafeArea()
            
            // Subtle starfield effect
            starfieldEffect
            
            // Hero Content
            VStack(spacing: 0) {
                Spacer()
                
                // Logo with glassmorphic sphere and shimmer
                heroContent
                
                Spacer()
                
                // Get Started Button
                getStartedButton
                    .padding(.horizontal, 32)
                    .padding(.bottom, 48)
                    .opacity(buttonOpacity)
                    .offset(y: buttonOffset)
            }
        }
        .onAppear {
            // Haptic feedback on appear
            let generator = UISelectionFeedbackGenerator()
            generator.selectionChanged()
            
            // Start animations
            startAnimations()
        }
    }
    
    // MARK: - Animated Gradient Background
    
    private var animatedGradientBackground: some View {
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
        .onAppear {
            withAnimation(.easeInOut(duration: 4.0).repeatForever(autoreverses: true)) {
                gradientOffset = .pi * 2
            }
        }
    }
    
    // MARK: - Starfield Effect
    
    private var starfieldEffect: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<30, id: \.self) { index in
                    Circle()
                        .fill(Color.white.opacity(0.6))
                        .frame(width: CGFloat.random(in: 1...2), height: CGFloat.random(in: 1...2))
                        .position(
                            x: CGFloat(index) * geometry.size.width / 10 + CGFloat.random(in: -50...50),
                            y: CGFloat(index * 7 % Int(geometry.size.height))
                        )
                        .opacity(Double.random(in: 0.3...0.8))
                }
            }
        }
    }
    
    // MARK: - Hero Content
    
    private var heroContent: some View {
        ZStack {
            // Glassmorphic Sphere (behind text)
            glassmorphicSphere
            
            // Circular Progress Trace (60 seconds symbol)
            circularProgressTrace
            
            // Dev60s Title with Shimmer
            VStack(spacing: 16) {
                shimmerText
                
                subtitleText
            }
        }
    }
    
    // MARK: - Glassmorphic Sphere
    
    private var glassmorphicSphere: some View {
        Circle()
            .fill(
                LinearGradient(
                    colors: [
                        Color.white.opacity(0.1),
                        Color.white.opacity(0.05)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(width: 200, height: 200)
            .background(
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.purple.opacity(0.2),
                                Color.blue.opacity(0.1),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 50,
                            endRadius: 100
                        )
                    )
            )
            .blur(radius: 20)
            .offset(y: sphereOffset)
            .onAppear {
                withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
                    sphereOffset = 15
                }
            }
    }
    
    // MARK: - Circular Progress Trace
    
    private var circularProgressTrace: some View {
        ZStack {
            // Outer ring
            Circle()
                .trim(from: 0, to: 1.0)
                .stroke(
                    LinearGradient(
                        colors: [
                            Color.purple.opacity(0.4),
                            Color.blue.opacity(0.4),
                            Color.purple.opacity(0.4)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    style: StrokeStyle(lineWidth: 1, lineCap: .round)
                )
                .frame(width: 240, height: 240)
                .rotationEffect(.degrees(rotationAngle))
                .blur(radius: 0.5)
            
            // Animated progress segment
            Circle()
                .trim(from: 0, to: 0.25)
                .stroke(
                    LinearGradient(
                        colors: [
                            Color.purple.opacity(0.8),
                            Color.blue.opacity(0.8)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    style: StrokeStyle(lineWidth: 2, lineCap: .round)
                )
                .frame(width: 240, height: 240)
                .rotationEffect(.degrees(rotationAngle - 90))
        }
        .onAppear {
            withAnimation(.linear(duration: 3.0).repeatForever(autoreverses: false)) {
                rotationAngle = 360
            }
        }
    }
    
    // MARK: - Shimmer Text
    
    private var shimmerText: some View {
        Text("Dev60s")
            .font(.system(size: 48, weight: .bold, design: .monospaced))
            .tracking(4)
            .foregroundColor(.white)
            .overlay(
                // Shimmer effect
                GeometryReader { geometry in
                    LinearGradient(
                        colors: [
                            Color.clear,
                            Color.white.opacity(0.9),
                            Color.clear
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: 150)
                    .offset(x: shimmerOffset - geometry.size.width / 2)
                    .blendMode(.screen)
                }
            )
            .mask(
                Text("Dev60s")
                    .font(.system(size: 48, weight: .bold, design: .monospaced))
                    .tracking(4)
            )
            .onAppear {
                withAnimation(.linear(duration: 3.0).repeatForever(autoreverses: false)) {
                    shimmerOffset = 300
                }
            }
    }
    
    // MARK: - Subtitle Text
    
    private var subtitleText: some View {
        Text("Sharpen your interview thinking")
            .font(.system(size: 16, weight: .medium, design: .rounded))
            .foregroundColor(.white.opacity(0.7))
            .multilineTextAlignment(.center)
            .padding(.horizontal, 32)
            .padding(.top, 8)
    }
    
    // MARK: - Get Started Button
    
    private var getStartedButton: some View {
        Button(action: {
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
            handleGetStarted()
        }) {
            HStack(spacing: 12) {
                Text("Get Started")
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                
                Image(systemName: "arrow.right")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.15),
                                Color.white.opacity(0.1)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        Capsule()
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color.purple.opacity(0.6),
                                        Color.blue.opacity(0.6),
                                        Color.purple.opacity(0.6)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1.5
                            )
                            .blur(radius: 2)
                    )
                    .shadow(color: Color.purple.opacity(0.3), radius: 10, x: 0, y: 4)
            )
        }
        .buttonStyle(GlassButtonStyle())
    }
    
    // MARK: - Animation Functions
    
    private func startAnimations() {
        // Button fade in and slide up
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                buttonOpacity = 1.0
                buttonOffset = 0
            }
        }
    }
}

// MARK: - Glass Button Style

struct GlassButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

// MARK: - Preview

#Preview {
    LandingView(handleGetStarted: {})
}
