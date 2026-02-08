//
//  BreakdownDetailView.swift
//  Ocula
//
//  Created by Tyson Miles on 7/2/2026.
//

import SwiftUI

struct BreakdownDetailView: View {
    let metric: DrivingMetric
    let timeRange: ProfileTimeRange

    var body: some View {
        SettingsScaffold(title: metric.title) {
            ScrollView {
                VStack(spacing: AppTheme.Spacing.lg) {
                    VStack(spacing: 6) {
                        Text("\(metric.score)")
                            .font(AppTheme.Fonts.bold(36))
                            .foregroundColor(AppTheme.Colors.primary)

                        Text(timeRange.description)
                            .captionStyle()

                        Text(metric.insight)
                            .font(AppTheme.Fonts.medium(13))
                            .foregroundColor(AppTheme.Colors.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(AppTheme.Spacing.lg)
                    .background(
            RoundedRectangle(cornerRadius: AppTheme.Radius.xlg)
                .fill(AppTheme.Colors.primary.opacity(0.08))
        )

                    VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                        Text("Actions")
                            .headlineStyle()

                        actionRow(
                            icon: "chart.bar.fill",
                            iconColor: .blue,
                            title: "Compare periods",
                            subtitle: "See changes vs last period",
                            trailingValue: nil,
                            action: comparePeriods
                        )

                        actionRow(
                            icon: "square.and.arrow.up",
                            iconColor: .green,
                            title: "Share insight",
                            subtitle: "Export this metric",
                            trailingValue: nil,
                            action: shareMetric
                        )
                    }
                }
                .padding(.horizontal, AppTheme.Spacing.md)
                .padding(.bottom, AppTheme.Spacing.xl)
            }
        }
    }
}

private extension BreakdownDetailView {
    func comparePeriods() {
        print("Compare \(metric.title) periods")
    }

    func shareMetric() {
        print("Share \(metric.title)")
    }
}

#Preview {
    BreakdownDetailView(
        metric: DrivingMetric(title: "Cornering", score: 54, insight: "Sharp turns reduced control", systemIcon: "arrow.triangle.turn.up.right.diamond.fill"),
        timeRange: .last7Days
    )
}
