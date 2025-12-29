//
//  QuizQuestionView.swift
//  Dev60s
//
//  Premium Apple-style Bento Quiz Session View
//

import SwiftUI
import UIKit

struct QuizQuestionView: View {
    @ObservedObject var viewModel: QuizQuestionViewModel
    let handleCompleted: () -> Void
    
    @State private var showConfetti: Bool = false
    @State private var correctAnswerPulse: Bool = false
    @Namespace private var questionNamespace
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Top Section: Progress Bar & Timer
                    topSection
                        .padding(.horizontal, 20)
                        .padding(.top, 12)
                    
                    if let question = viewModel.currentQuestion {
                        // Question Card (Bento Style)
                        questionCard(question)
                            .padding(.horizontal, 20)
                            .matchedGeometryEffect(id: "question-\(question.id)", in: questionNamespace)
                        
                        // Options Grid (2x2)
                        optionsGrid(question)
                            .padding(.horizontal, 20)
                    }
                    
                    Spacer()
                        .frame(height: 20)
                    
                    // Bottom Button
                    bottomButton
                        .padding(.horizontal, 20)
                        .padding(.bottom, 32)
                }
            }
            
            // Confetti Effect
            if showConfetti {
                confettiEffect
            }
        }
        .premiumBackground()
        .onChange(of: viewModel.answerState) { _, newState in
            if newState == .correct {
                showConfetti = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    showConfetti = false
                }
            }
            if newState == .incorrect {
                // Start pulse animation for correct answer
                withAnimation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true)) {
                    correctAnswerPulse = true
                }
            } else {
                correctAnswerPulse = false
            }
        }
    }
    
    // MARK: - Top Section
    
    private var topSection: some View {
        VStack(spacing: 16) {
            // Progress Bar
            progressBar
            
            // Timer
            timerView
        }
    }
    
    private var progressBar: some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.white.opacity(0.1))
                    .frame(height: 4)
                
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.purple.opacity(0.8),
                                Color.blue.opacity(0.8)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: proxy.size.width * viewModel.progressFraction, height: 4)
            }
        }
        .frame(height: 4)
    }
    
    private var timerView: some View {
        HStack(spacing: 8) {
            Image(systemName: "timer")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white.opacity(0.8))
            
            Text("\(viewModel.timeRemaining)s")
                .font(.system(size: 18, weight: .bold, design: .monospaced))
                .foregroundColor(timerColor)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(
            Capsule()
                .fill(Color.white.opacity(0.1))
                .overlay(
                    Capsule()
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.purple.opacity(0.6),
                                    Color.blue.opacity(0.6)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            lineWidth: 1
                        )
                )
        )
    }
    
    private var timerColor: Color {
        if viewModel.timeRemaining <= 10 {
            return Color(red: 0.91, green: 0.30, blue: 0.24) // Alizarin Red
        } else if viewModel.timeRemaining <= 20 {
            return Color(red: 0.95, green: 0.61, blue: 0.07) // Orange
        } else {
            return .white
        }
    }
    
    // MARK: - Question Card
    
    private func questionCard(_ question: QuizQuestion) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Question \(question.index) of \(question.total)")
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.6))
            
            Text(question.prompt)
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .tracking(-0.2)
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
                .lineSpacing(6)
                .lineLimit(3)
                .minimumScaleFactor(0.8)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.white.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .stroke(Color.white.opacity(0.15), lineWidth: 1)
                )
        )
    }
    
    // MARK: - Options Grid
    
    private func optionsGrid(_ question: QuizQuestion) -> some View {
        let options = question.options
        let rows = (options.count + 1) / 2
        
        return VStack(spacing: 12) {
            ForEach(0..<rows, id: \.self) { row in
                HStack(spacing: 12) {
                    if row * 2 < options.count {
                        optionCard(options[row * 2], question: question)
                    }
                    if row * 2 + 1 < options.count {
                        optionCard(options[row * 2 + 1], question: question)
                    }
                }
            }
        }
    }
    
    private func optionCard(_ option: QuizOption, question: QuizQuestion) -> some View {
        let isSelected = option == viewModel.selectedOption
        // For demo: second option (index 1) is correct, or first if only one option
        let correctOption = question.options.indices.contains(1) ? question.options[1] : question.options.first
        let isCorrect = option == correctOption
        let isIncorrect = isSelected && viewModel.answerState == .incorrect
        let showAsCorrect = (isCorrect && viewModel.showCorrectAnswer)
        
        var backgroundColor: Color {
            if showAsCorrect {
                return Color(red: 0.18, green: 0.80, blue: 0.44) // Emerald Green
            } else if isIncorrect {
                return Color(red: 0.91, green: 0.30, blue: 0.24) // Alizarin Red
            } else if isSelected {
                return Color.white.opacity(0.15)
            } else {
                return Color.white.opacity(0.08)
            }
        }
        
        var borderColor: Color {
            if isSelected && viewModel.answerState == .selected {
                return Color.purple.opacity(0.6)
            } else if showAsCorrect || isIncorrect {
                return Color.white.opacity(0.3)
            } else {
                return Color.white.opacity(0.15)
            }
        }
        
        var glowRadius: CGFloat {
            if isSelected && viewModel.answerState == .selected {
                return 8
            } else {
                return 0
            }
        }
        
        var pulseScale: CGFloat {
            if showAsCorrect && viewModel.answerState == .incorrect && correctAnswerPulse {
                return 1.05
            } else {
                return 1.0
            }
        }
        
        return Button {
            // Only allow selection if not evaluated yet
            if viewModel.answerState == .none {
                viewModel.handleSelect(option: option)
            }
        } label: {
            HStack {
                Text(option.text)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                
                Spacer()
                
                if showAsCorrect {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .transition(.scale.combined(with: .opacity))
                } else if isIncorrect {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity)
            .frame(minHeight: 70)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(backgroundColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .stroke(borderColor, lineWidth: 1.5)
                    )
                    .shadow(color: Color.purple.opacity(0.3), radius: glowRadius, x: 0, y: 0)
            )
            .scaleEffect(pulseScale)
        }
        .buttonStyle(SquishyButtonStyle())
        .disabled(viewModel.answerState == .correct || viewModel.answerState == .incorrect)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: viewModel.answerState)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        .animation(.easeInOut(duration: 0.6), value: correctAnswerPulse)
    }
    
    // MARK: - Bottom Button
    
    private var bottomButton: some View {
        Button {
            // Haptic feedback for button press
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
            
            if viewModel.answerState == .selected {
                // Evaluate answer on Next click
                viewModel.evaluateAnswer()
                
                // If last question, handle navigation based on result
                if viewModel.isLastQuestion {
                    // Use a small delay to ensure answerState is updated
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        if viewModel.answerState == .correct {
                            // Correct answer - auto-navigate after 1 second
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                handleCompleted()
                            }
                        }
                        // For incorrect, user will click "Got it" to proceed
                    }
                }
            } else {
                // Proceed to next question or finish
                if viewModel.isLastQuestion {
                    // Last question - navigate to result
                    handleCompleted()
                } else {
                    // Move to next question
                    viewModel.handleNext()
                }
            }
        } label: {
            HStack(spacing: 8) {
                Text(viewModel.buttonText)
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                    .foregroundColor(.black)
                    .animation(.easeInOut(duration: 0.3), value: viewModel.buttonText)
                
                if viewModel.answerState != .incorrect {
                    Image(systemName: "arrow.right")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.black)
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                ZStack {
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.white,
                                    Color.white.opacity(0.95)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                    
                    // Auto-advance progress indicator
                    Group {
                        if viewModel.answerState == .correct && viewModel.autoAdvanceProgress > 0 {
                            GeometryReader { geometry in
                                Capsule()
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                Color.purple.opacity(0.3),
                                                Color.blue.opacity(0.3)
                                            ],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .frame(width: geometry.size.width * viewModel.autoAdvanceProgress)
                            }
                        }
                    }
                }
                .shadow(color: .black.opacity(0.2), radius: 12, x: 0, y: 4)
            )
            .overlay(
                // Subtle pulse for auto-advance
                Group {
                    if viewModel.answerState == .correct {
                        Capsule()
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color.purple.opacity(0.6),
                                        Color.blue.opacity(0.6)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ),
                                lineWidth: 1.5
                            )
                            .opacity(viewModel.autoAdvanceProgress > 0 ? 0.8 : 0)
                            .blur(radius: 2)
                    }
                }
            )
        }
        .buttonStyle(SquishyButtonStyle())
        .disabled(viewModel.isNextDisabled)
        .animation(.spring(response: 0.4, dampingFraction: 0.75), value: viewModel.answerState)
        .animation(.linear(duration: 0.1), value: viewModel.autoAdvanceProgress)
    }
    
    // MARK: - Confetti Effect
    
    private var confettiEffect: some View {
        ZStack {
            ForEach(0..<20, id: \.self) { index in
                Circle()
                    .fill([
                        Color.purple,
                        Color.blue,
                        Color.green,
                        Color.yellow,
                        Color.orange
                    ].randomElement() ?? .purple)
                    .frame(width: 8, height: 8)
                    .offset(
                        x: CGFloat.random(in: -100...100),
                        y: CGFloat.random(in: -100...100)
                    )
                    .opacity(showConfetti ? 0 : 1)
            }
        }
        .allowsHitTesting(false)
    }
}

// MARK: - Preview

#Preview {
    QuizQuestionView(
        viewModel: QuizQuestionViewModel(questions: QuizMockData.questions),
        handleCompleted: {}
    )
}
