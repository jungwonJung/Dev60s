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
    let handleSelectLevel: (QuizLevel) -> Void
    let handleSelectQuestionCount: (Int) -> Void
    let handleStartQuiz: () -> Void
    let handleBack: () -> Void
    
    private var canStart: Bool {
        selectedLevel != nil
    }
    
    private let questionCountOptions = [5, 10, 15, 20]
    
    var body: some View {
        ZStack {
            // Deep Off-black Background
            Color(red: 0.06, green: 0.06, blue: 0.07)
                .ignoresSafeArea()
            
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
                    
                    Spacer()
                        .frame(height: 20)
                    
                    // Start Quiz Button
                    startButton
                        .padding(.horizontal, 20)
                        .padding(.bottom, 32)
                }
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
                    .animation(.easeOut(duration: 0.2), value: isSelected)
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
                    .animation(.easeOut(duration: 0.2), value: isSelected)
                }
            }
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
                    .shadow(
                        color: canStart ? .black.opacity(0.2) : .clear,
                        radius: canStart ? 12 : 0,
                        x: 0,
                        y: canStart ? 4 : 0
                    )
            )
            .opacity(canStart ? 1.0 : 0.6)
            .scaleEffect(canStart ? 1.0 : 0.98)
        }
        .buttonStyle(SquishyButtonStyle())
        .disabled(!canStart)
        .animation(.spring(response: 0.4, dampingFraction: 0.75), value: canStart)
    }
}

// MARK: - Preview

#Preview {
    QuizSetupView(
        selectedLevel: .normal,
        selectedQuestionCount: 10,
        handleSelectLevel: { _ in },
        handleSelectQuestionCount: { _ in },
        handleStartQuiz: {},
        handleBack: {}
    )
}

