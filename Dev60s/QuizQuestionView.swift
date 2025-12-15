//
//  QuizQuestionView.swift
//  Dev60s
//
//  Main quiz question screen: header, progress bar, question text, options, bottom button.
//

import SwiftUI

struct QuizQuestionView: View {
    @ObservedObject var viewModel: QuizQuestionViewModel
    let handleCompleted: () -> Void

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.96, green: 0.95, blue: 1.0),
                         Color(red: 0.93, green: 0.96, blue: 1.0)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                header
                progressBar
                    .padding(.horizontal, 20)
                    .padding(.top, 8)

                if let question = viewModel.currentQuestion {
                    questionSection(question)
                        .padding(.horizontal, 20)
                        .padding(.top, 20)

                    optionsSection(question)
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                        .padding(.bottom, 12)
                        .frame(maxHeight: .infinity, alignment: .top)
                } else {
                    Spacer()
                }

                bottomButton
                    .padding(.horizontal, 20)
                    .padding(.bottom, 16)
            }
        }
    }

    private var header: some View {
        HStack {
            Image(systemName: "chevron.left")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.primary)

            Spacer()

            Text(viewModel.currentQuestion?.title ?? "Quiz")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.primary)

            Spacer()

            HStack(spacing: 4) {
                Image(systemName: "timer")
                    .font(.system(size: 15))
                Text("2:00")
                    .font(.system(size: 15, weight: .medium))
            }
            .foregroundColor(.primary)
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
    }

    private var progressBar: some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color(.systemGray5))
                    .frame(height: 6)

                Capsule()
                    .fill(Color(red: 0.61, green: 0.48, blue: 1.0))
                    .frame(width: proxy.size.width * viewModel.progressFraction,
                           height: 6)
            }
        }
        .frame(height: 6)
    }

    private func questionSection(_ question: QuizQuestion) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Question \(question.index) of \(question.total)")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(Color(.systemGray))

            Text(question.prompt)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
                .lineSpacing(4)
        }
    }

    private func optionsSection(_ question: QuizQuestion) -> some View {
        VStack(spacing: 12) {
            ForEach(question.options) { option in
                optionCard(option)
            }
        }
    }

    private func optionCard(_ option: QuizOption) -> some View {
        let isSelected = option == viewModel.selectedOption

        return Button {
            viewModel.handleSelect(option: option)
        } label: {
            HStack {
                Text(option.text)
                    .font(.system(size: 16))
                    .foregroundColor(isSelected ? Color(red: 0.30, green: 0.21, blue: 0.70) : .primary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(Color(red: 0.46, green: 0.34, blue: 0.85))
                }
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(isSelected ? Color(red: 0.94, green: 0.91, blue: 1.0) : .white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(isSelected ? Color(red: 0.80, green: 0.74, blue: 1.0) : Color(.systemGray5), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.04), radius: 10, x: 0, y: 6)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(option.text)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    private var bottomButton: some View {
        Button {
            let isLast = viewModel.currentIndex >= viewModel.questions.count - 1
            if isLast {
                handleCompleted()
            } else {
                viewModel.handleNext()
            }
        } label: {
            Text("Next →")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color.black.opacity(viewModel.isNextDisabled ? 0.4 : 1.0))
                )
        }
        .buttonStyle(.plain)
        .disabled(viewModel.isNextDisabled)
        .accessibilityLabel("Next question")
    }
}

#Preview {
    QuizQuestionView(
        viewModel: QuizQuestionViewModel(questions: QuizMockData.questions),
        handleCompleted: {}
    )
}


