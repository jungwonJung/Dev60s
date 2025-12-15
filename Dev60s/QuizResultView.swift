//
//  QuizResultView.swift
//  Dev60s
//
//  Simple, clean result screen using mock summary data.
//

import SwiftUI

struct QuizResultView: View {
    let summary: QuizResultSummary
    let handleBackHome: () -> Void

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.98, green: 0.97, blue: 1.0),
                         Color(red: 0.95, green: 0.97, blue: 1.0)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                header

                ScrollView {
                    VStack(alignment: .center, spacing: 20) {
                        scoreSection
                        incorrectSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }

                Button(action: handleBackHome) {
                    Text("Back to Home")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(Color.black)
                        )
                        .padding(.horizontal, 20)
                        .padding(.bottom, 16)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var header: some View {
        HStack {
            Text("Results")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.primary)
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 8)
    }

    private var scoreSection: some View {
        VStack(spacing: 8) {
            Text("Your Score")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Color(.systemGray))

            Text("\(summary.correctCount) / \(summary.totalCount)")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.primary)

            Text("Incorrect Answers")
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(Color(red: 0.30, green: 0.21, blue: 0.70))
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 12)
    }

    private var incorrectSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(summary.incorrectItems) { item in
                VStack(alignment: .leading, spacing: 10) {
                    Text(item.questionText)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                        .lineSpacing(4)

                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text("Correct:")
                            .font(.system(size: 14))
                            .foregroundColor(Color(.systemGray))
                        Text(item.correctAnswer)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color.green)
                    }

                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text("Your answer:")
                            .font(.system(size: 14))
                            .foregroundColor(Color(.systemGray))
                        Text(item.userAnswer)
                            .font(.system(size: 14))
                            .foregroundColor(Color(.systemGray3))
                    }
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color.white)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color(.systemGray5), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 6)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    QuizResultView(
        summary: QuizMockData.resultSummary,
        handleBackHome: {}
    )
}


