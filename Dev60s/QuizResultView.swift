//
//  QuizResultView.swift
//  Dev60s
//
//  Premium Apple-style Bento Quiz Result Screen
//

import SwiftUI
import UIKit

struct QuizResultView: View {
    let summary: QuizResultSummary
    let handleTryAgain: () -> Void
    let handleBackHome: () -> Void
    
    @State private var iconPulse: Bool = false
    @State private var shimmerOffset: CGFloat = -200
    
    private var scorePercentage: Double {
        guard summary.totalCount > 0 else { return 0 }
        return Double(summary.correctCount) / Double(summary.totalCount)
    }
    
    private var isPerfectScore: Bool {
        summary.incorrectItems.isEmpty && summary.correctCount == summary.totalCount
    }
    
    private var performanceMessage: String {
        if isPerfectScore {
            return "Perfect Score! You nailed every question. 🔥"
        } else if scorePercentage >= 0.9 {
            return "Excellent! You're ready for the interview."
        } else if scorePercentage >= 0.7 {
            return "Great job! Keep practicing to improve."
        } else if scorePercentage >= 0.5 {
            return "Good effort! Review the topics and try again."
        } else {
            return "Keep learning! Every mistake is a step forward."
        }
    }
    
    private var trophyIcon: String {
        if isPerfectScore {
            return "trophy.fill"
        } else if scorePercentage >= 0.9 {
            return "trophy.fill"
        } else if scorePercentage >= 0.7 {
            return "flame.fill"
        } else {
            return "star.fill"
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Header (Centered)
                headerSection
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                
                // Score Card (Bento Style)
                scoreCard
                    .padding(.horizontal, 20)
                
                // Performance Message
                performanceMessageCard
                    .padding(.horizontal, 20)
                
                // Incorrect Answers List (if any)
                if !summary.incorrectItems.isEmpty {
                    incorrectAnswersSection
                        .padding(.horizontal, 20)
                }
                
                // Action Buttons
                actionButtons
                    .padding(.horizontal, 20)
                    .padding(.bottom, 32)
            }
        }
        .premiumBackground()
        .onAppear {
            // Start gentle breathing animation for icon
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                iconPulse = true
            }
            
            // Start shimmer animation for perfect score
            if isPerfectScore {
                withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
                    shimmerOffset = 200
                }
            }
        }
    }
    
    // MARK: - Header Section (Centered)
    
    private var headerSection: some View {
        VStack(alignment: .center, spacing: 8) {
            Text("Quiz Complete")
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
            
            Text("Here's how you did")
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Score Card
    
    private var scoreCard: some View {
        ZStack {
            VStack(spacing: 20) {
                // Trophy/Flame Icon with Gentle Breathing Animation
                Image(systemName: trophyIcon)
                    .font(.system(size: 48, weight: .medium))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                Color(red: 0.95, green: 0.61, blue: 0.07),
                                Color(red: 0.91, green: 0.30, blue: 0.24)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .scaleEffect(iconPulse ? 1.05 : 1.0)
                    .opacity(iconPulse ? 0.95 : 1.0)
                
                // Score Display
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Text("\(summary.correctCount)")
                        .font(.system(size: 56, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("/")
                        .font(.system(size: 40, weight: .semibold, design: .rounded))
                        .foregroundColor(.white.opacity(0.6))
                    
                    Text("\(summary.totalCount)")
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundColor(.white.opacity(0.8))
                }
                
                // Percentage
                Text("\(Int(scorePercentage * 100))%")
                    .font(.system(size: 24, weight: .semibold, design: .rounded))
                    .foregroundColor(.white.opacity(0.7))
            }
            .frame(maxWidth: .infinity)
            .padding(32)
            .background(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(Color.white.opacity(0.08))
                    .overlay(
                        RoundedRectangle(cornerRadius: 28, style: .continuous)
                            .stroke(Color.white.opacity(0.15), lineWidth: 1)
                    )
            )
            .overlay(
                // Shimmer effect for perfect score
                Group {
                    if isPerfectScore {
                        LinearGradient(
                            colors: [
                                Color.clear,
                                Color.white.opacity(0.3),
                                Color.clear
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .frame(width: 100)
                        .offset(x: shimmerOffset)
                        .blur(radius: 20)
                    }
                }
            )
        }
    }
    
    // MARK: - Performance Message Card
    
    private var performanceMessageCard: some View {
        Text(performanceMessage)
            .font(.system(size: 17, weight: .medium, design: .rounded))
            .foregroundColor(.white.opacity(0.9))
            .multilineTextAlignment(.center)
            .lineSpacing(4)
            .frame(maxWidth: .infinity)
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(Color.white.opacity(0.06))
                    .overlay(
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .stroke(Color.white.opacity(0.12), lineWidth: 1)
                    )
            )
    }
    
    // MARK: - Incorrect Answers Section
    
    private var incorrectAnswersSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Incorrect Answers")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .padding(.bottom, 8)
            
            ForEach(summary.incorrectItems) { item in
                incorrectAnswerCard(item)
            }
        }
    }
    
    private func incorrectAnswerCard(_ item: QuizResultItem) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(item.questionText)
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundColor(.white.opacity(0.9))
                .multilineTextAlignment(.leading)
                .lineSpacing(4)
            
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text("Correct:")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.6))
                Text(item.correctAnswer)
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(Color(red: 0.18, green: 0.80, blue: 0.44)) // Emerald Green
            }
            
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text("Your answer:")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.6))
                Text(item.userAnswer)
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundColor(.white.opacity(0.7))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
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
    
    // MARK: - Action Buttons
    
    private var actionButtons: some View {
        VStack(spacing: 16) {
            // Try Again Button
            Button(action: {
                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                impactFeedback.impactOccurred()
                handleTryAgain()
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 16, weight: .semibold))
                    Text("Try Again")
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                }
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
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
                        .shadow(color: .black.opacity(0.2), radius: 12, x: 0, y: 4)
                )
            }
            .buttonStyle(SquishyButtonStyle())
            
            // Back to Home Button
            Button(action: {
                let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                impactFeedback.impactOccurred()
                handleBackHome()
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "house.fill")
                        .font(.system(size: 16, weight: .semibold))
                    Text("Back to Home")
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    Capsule()
                        .fill(Color.white.opacity(0.1))
                        .overlay(
                            Capsule()
                                .stroke(
                                    LinearGradient(
                                        colors: [
                                            Color.white.opacity(0.3),
                                            Color.white.opacity(0.2)
                                        ],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    ),
                                    lineWidth: 1.5
                                )
                        )
                )
            }
            .buttonStyle(SquishyButtonStyle())
        }
    }
}

// MARK: - Preview

#Preview {
    QuizResultView(
        summary: QuizMockData.resultSummary,
        handleTryAgain: {},
        handleBackHome: {}
    )
}
