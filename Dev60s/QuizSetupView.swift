//
//  QuizSetupView.swift
//  Dev60s
//
//  Step 2: Quiz Setup Screen (Level + Question Count Selection)
//

import SwiftUI
import UIKit

// MARK: - QuizSetupView

struct QuizSetupView: View {
    let selectedLevel: QuizLevel?
    let selectedQuestionCount: Int
    let enableHapticFeedback: Bool
    let enableStrictTimer: Bool
    let handleSelectLevel: (QuizLevel) -> Void
    let handleSelectQuestionCount: (Int) -> Void
    let handleHapticFeedbackChanged: (Bool) -> Void
    let handleStrictTimerChanged: (Bool) -> Void
    let handleStartQuiz: () -> Void
    let handleBack: () -> Void
    @State private var pulseScale: CGFloat = 1.0
    
    private var canStart: Bool {
        selectedLevel != nil
    }
    
    private let questionCountOptions = [20, 30, 40]
    
    private var estimatedMinutes: Int {
        selectedQuestionCount
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                // Back Button & Title
                headerSection
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                
                // Level Selection
                levelSection
                    .padding(.horizontal, 20)
                
                // Question Count Selection
                questionCountSection
                    .padding(.horizontal, 20)
                
                // Session Preferences
                sessionPreferencesSection
                    .padding(.horizontal, 20)
                
                Spacer()
                    .frame(height: 20)
                
                // Start Quiz Button
                startButton
                    .padding(.horizontal, 20)
                    .padding(.bottom, 32)
            }
        }
        .premiumBackground()
        .onAppear {
            // Start pulse animation for button
            if canStart {
                startPulseAnimation()
            }
        }
        .onChange(of: canStart) { _, newValue in
            if newValue {
                startPulseAnimation()
            } else {
                pulseScale = 1.0
            }
        }
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Back Button
            Button(action: {
                handleBack()
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                    Text("Back")
                        .font(.system(size: 17, weight: .medium, design: .rounded))
                }
                .foregroundColor(.white.opacity(0.8))
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Quiz Setup")
                    .font(.system(.largeTitle, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                Color.white,
                                Color.white.opacity(0.7)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                Text("Choose difficulty and question count")
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.6))
            }
        }
    }
    
    // MARK: - Level Section
    
    private var levelSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Difficulty Level")
                .font(.system(size: 17, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
            
            HStack(spacing: 12) {
                ForEach([QuizLevel.easy, .normal, .hard]) { level in
                    let isSelected = level == selectedLevel
                    
                    Button {
                        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                        impactFeedback.impactOccurred()
                        handleSelectLevel(level)
                    } label: {
                        Text(level.rawValue)
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundColor(isSelected ? .black : .white.opacity(0.8))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .fill(isSelected ? Color.white : Color.white.opacity(0.1))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .stroke(Color.white.opacity(0.2), lineWidth: 0.5)
                            )
                    }
                    .buttonStyle(SquishyButtonStyle())
                    .animation(.spring(response: 0.4, dampingFraction: 0.7), value: isSelected)
                }
            }
        }
    }
    
    // MARK: - Question Count Section
    
    private var questionCountSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Question Count")
                .font(.system(size: 17, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
            
            HStack(spacing: 12) {
                ForEach(questionCountOptions, id: \.self) { count in
                    let isSelected = count == selectedQuestionCount
                    
                    Button {
                        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                        impactFeedback.impactOccurred()
                        handleSelectQuestionCount(count)
                    } label: {
                        Text("\(count)")
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundColor(isSelected ? .black : .white.opacity(0.8))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .fill(isSelected ? Color.white : Color.white.opacity(0.1))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .stroke(Color.white.opacity(0.2), lineWidth: 0.5)
                            )
                    }
                    .buttonStyle(SquishyButtonStyle())
                    .animation(.spring(response: 0.4, dampingFraction: 0.7), value: isSelected)
                }
            }
            
            // Estimated session time
            Text("Estimated session: \(estimatedMinutes) minutes")
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.5))
                .padding(.top, 4)
        }
    }
    
    // MARK: - Session Preferences Section
    
    private var sessionPreferencesSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Session Preferences")
                .font(.system(size: 17, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
            
            VStack(spacing: 16) {
                // Haptic Engine Toggle
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Haptic Engine")
                            .font(.system(size: 15, weight: .medium, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text("Enable tactile feedback during quiz")
                            .font(.system(size: 13, weight: .regular, design: .rounded))
                            .foregroundColor(.white.opacity(0.6))
                    }
                    
                    Spacer()
                    
                    Toggle("", isOn: Binding(
                        get: { enableHapticFeedback },
                        set: { handleHapticFeedbackChanged($0) }
                    ))
                        .tint(Color.purple.opacity(0.8))
                        .labelsHidden()
                }
                .padding(.vertical, 8)
                
                Divider()
                    .background(Color.white.opacity(0.2))
                
                // Strict Timer Toggle
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Strict Timer")
                            .font(.system(size: 15, weight: .medium, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text("Enable 60s countdown per question")
                            .font(.system(size: 13, weight: .regular, design: .rounded))
                            .foregroundColor(.white.opacity(0.6))
                    }
                    
                    Spacer()
                    
                    Toggle("", isOn: Binding(
                        get: { enableStrictTimer },
                        set: { handleStrictTimerChanged($0) }
                    ))
                        .tint(Color.purple.opacity(0.8))
                        .labelsHidden()
                }
                .padding(.vertical, 8)
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color.white.opacity(0.08))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .stroke(Color.white.opacity(0.15), lineWidth: 1)
                    )
            )
        }
    }
    
    // MARK: - Start Button
    
    private var startButton: some View {
        Button(action: {
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
            handleStartQuiz()
        }) {
            HStack(spacing: 8) {
                Text("Start Interview Prep")
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                    .foregroundColor(canStart ? .black : .white.opacity(0.4))
                
                if canStart {
                    Image(systemName: "arrow.right")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.black)
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                Capsule()
                    .fill(
                        canStart ?
                        LinearGradient(
                            colors: [
                                Color.white,
                                Color.white.opacity(0.95)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        ) :
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.1),
                                Color.white.opacity(0.05)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .overlay(
                        // Subtle glow effect
                        Capsule()
                            .stroke(
                                LinearGradient(
                                    colors: canStart ? [
                                        Color.purple.opacity(0.6),
                                        Color.blue.opacity(0.6),
                                        Color.purple.opacity(0.6)
                                    ] : [],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ),
                                lineWidth: canStart ? 1.5 : 0
                            )
                            .blur(radius: canStart ? 4 : 0)
                    )
                    .shadow(
                        color: canStart ? Color.purple.opacity(0.3) : .clear,
                        radius: canStart ? 15 : 0,
                        x: 0,
                        y: canStart ? 6 : 0
                    )
            )
            .opacity(canStart ? 1.0 : 0.6)
            .scaleEffect(canStart ? pulseScale : 0.98)
        }
        .buttonStyle(SquishyButtonStyle())
        .disabled(!canStart)
        .animation(.spring(response: 0.4, dampingFraction: 0.75), value: canStart)
    }
    
    // MARK: - Pulse Animation
    
    private func startPulseAnimation() {
        withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
            pulseScale = 1.02
        }
    }
}

// MARK: - Preview

#Preview {
    QuizSetupView(
        selectedLevel: .normal,
        selectedQuestionCount: 20,
        enableHapticFeedback: true,
        enableStrictTimer: true,
        handleSelectLevel: { _ in },
        handleSelectQuestionCount: { _ in },
        handleHapticFeedbackChanged: { _ in },
        handleStrictTimerChanged: { _ in },
        handleStartQuiz: {},
        handleBack: {}
    )
}
