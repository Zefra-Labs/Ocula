//
//  DriverScoreHeroView.swift
//  Ocula
//
//  Created by Tyson Miles on 7/2/2026.
//

import SwiftUI

struct DriverScoreHeroView: View {
    let score: Int
    let insightText: String
    let comparisonText: String
    let timeRangeLabel: String
    var onTap: (() -> Void)? = nil
    var isInteractive: Bool = true

    @State private var isPressed = false

    private var ringColor: Color {
        SafetyScoreStyle.color(for: score)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Driver Score")
                        .headlineBoldStyle()

                    Text(timeRangeLabel)
                        .captionStyle()
                }

                Spacer()

                Image(systemName: "arrow.up.right")
                    .bodyStyle()
                    .padding(.bottom)
                    .foregroundColor(AppTheme.Colors.secondary.opacity(0.7))
            }

            HStack {
                Spacer()
                ScoreRingView(score: score, size: 160, lineWidth: 14)
                Spacer()
            }
            .padding(.vertical)

            VStack(alignment: .leading, spacing: 6) {
                Text(insightText)
                    .font(AppTheme.Fonts.semibold(16))
                    .foregroundColor(AppTheme.Colors.primary)

                Text(comparisonText)
                    .captionStyle()
            }
        }
        .padding(AppTheme.Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.Radius.xlg)
                .fill(AppTheme.Colors.primary.opacity(0.08))
        )
        .scaleEffect(isPressed ? 0.98 : 1)
        .animation(.spring(response: 0.25, dampingFraction: 0.7), value: isPressed)
        .if(isInteractive) { view in
            view.onTapGesture {
                isPressed = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
                    isPressed = false
                }
                onTap?()
            }
        }
    }
}
