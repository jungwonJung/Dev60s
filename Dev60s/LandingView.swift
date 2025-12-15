//
//  LandingView.swift
//  Dev60s
//
//  First screen: Dev60s branding and "Get Started" button.
//

import SwiftUI

struct LandingView: View {
    let handleGetStarted: () -> Void

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.96, green: 0.95, blue: 1.0),
                    Color(red: 0.92, green: 0.96, blue: 1.0)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 32) {
                Spacer()

                VStack(spacing: 12) {
                    Text("Dev 60s")
                        .font(.system(size: 36, weight: .heavy))
                        .foregroundColor(.primary)

                    Text("Sharpen your interview thinking.\nSolve each question in 60 seconds.")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(Color(.systemGray))
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                }
                .padding(.horizontal, 32)

                Spacer()

                VStack(spacing: 12) {
                    Text("Interview‑style questions in short, focused sessions.")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(.systemGray))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)

                    Button(action: handleGetStarted) {
                        Text("Get Started")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 18, style: .continuous)
                                    .fill(Color.black)
                            )
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                }
            }
        }
    }
}

#Preview {
    LandingView(handleGetStarted: {})
}


