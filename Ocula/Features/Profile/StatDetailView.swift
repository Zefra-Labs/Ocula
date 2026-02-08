//
//  StatDetailView.swift
//  Ocula
//
//  Created by Tyson Miles on 7/2/2026.
//

import SwiftUI

struct StatDetailView: View {
    let type: ProfileStatType
    let stats: ProfileStats
    let timeRange: ProfileTimeRange

    private var valueText: String {
        switch type {
        case .trips:
            return "\(stats.tripsTaken)"
        case .routes:
            return "\(stats.uniqueRoutes)"
        case .distance:
            return "\(stats.kmsDriven) km"
        }
    }

    var body: some View {
        SettingsScaffold(title: type.title) {
            ScrollView {
                VStack(spacing: AppTheme.Spacing.lg) {
                    VStack(spacing: 6) {
                        Text(valueText)
                            .font(AppTheme.Fonts.bold(36))
                            .foregroundColor(AppTheme.Colors.primary)

                        Text(timeRange.description)
                            .captionStyle()

                        Text(type.subtitle)
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
                        Text("Insights")
                            .headlineStyle()

                        actionRow(
                            icon: "chart.line.uptrend.xyaxis",
                            iconColor: .green,
                            title: "Trending up",
                            subtitle: "Up 12% vs previous period",
                            trailingValue: nil,
                            action: {}
                        )

                        actionRow(
                            icon: "clock.fill",
                            iconColor: .orange,
                            title: "Peak time",
                            subtitle: "Most activity between 6–9pm",
                            trailingValue: nil,
                            action: {}
                        )
                    }
                }
                .padding(.horizontal, AppTheme.Spacing.md)
                .padding(.bottom, AppTheme.Spacing.xl)
            }
        }
    }
}

#Preview {
    StatDetailView(type: .distance, stats: ProfileStats.placeholder(), timeRange: .last30Days)
}
