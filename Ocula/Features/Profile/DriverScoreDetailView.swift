//
//  DriverScoreDetailView.swift
//  Ocula
//
//  Created by Tyson Miles on 7/2/2026.
//

import SwiftUI

struct DriverScoreDetailView: View {
    let score: Int
    let timeRange: ProfileTimeRange
    let breakdown: [DrivingMetric]

    var body: some View {
        SettingsScaffold(title: "Driver Score") {
            ScrollView {
                VStack(spacing: AppTheme.Spacing.lg) {
                    VStack(spacing: AppTheme.Spacing.sm) {
                        ScoreRingView(score: score, size: 200, lineWidth: 16)

                        Text(timeRange.description)
                            .captionStyle()
                    }
                    .frame(maxWidth: .infinity)
                    .padding(AppTheme.Spacing.lg)
                    .background(
            RoundedRectangle(cornerRadius: AppTheme.Radius.xlg)
                .fill(AppTheme.Colors.primary.opacity(0.08))
        )

                    VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                        Text("What’s Affecting It")
                            .headlineStyle()

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: AppTheme.Spacing.sm) {
                                ForEach(breakdown) { metric in
                                    BreakdownCardView(metric: metric)
                                }
                            }
                            .padding(.horizontal, 2)
                        }
                    }

                    VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                        Text("Quick Wins")
                            .headlineStyle()

                        actionRow(
                            icon: "hand.raised.fill",
                            iconColor: .yellow,
                            title: "Reduce hard braking",
                            subtitle: "Smooth stops can add +6 points",
                            trailingValue: nil,
                            action: focusBraking
                        )

                        actionRow(
                            icon: "bolt.fill",
                            iconColor: .blue,
                            title: "Gentle acceleration",
                            subtitle: "Improves overall control",
                            trailingValue: nil,
                            action: focusAcceleration
                        )
                    }
                }
                .padding(.horizontal, AppTheme.Spacing.md)
                .padding(.bottom, AppTheme.Spacing.xl)
            }
        }
    }
}

private extension DriverScoreDetailView {
    func focusBraking() {
        print("Focus braking")
    }

    func focusAcceleration() {
        print("Focus acceleration")
    }
}

#Preview {
    DriverScoreDetailView(
        score: 78,
        timeRange: .last7Days,
        breakdown: [
            DrivingMetric(title: "Smooth Braking", score: 72, insight: "Hard stops dropped 3 points", systemIcon: "hand.raised.fill"),
            DrivingMetric(title: "Cornering", score: 54, insight: "Sharp turns reduced control", systemIcon: "arrow.triangle.turn.up.right.diamond.fill")
        ]
    )
}
