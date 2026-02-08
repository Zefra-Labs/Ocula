//
//  BreakdownCardView.swift
//  Ocula
//
//  Created by Tyson Miles on 7/2/2026.
//

import SwiftUI

struct BreakdownCardView: View {
    let metric: DrivingMetric
    var onCompareInsights: (() -> Void)? = nil
    var onShare: (() -> Void)? = nil

    private var scoreFraction: CGFloat {
        CGFloat(min(max(metric.score, 0), 100)) / 100
    }

    private var scoreColor: Color {
        SafetyScoreStyle.color(for: metric.score)
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 8) {
                    Image(systemName: metric.systemIcon)
                        .foregroundColor(scoreColor)

                    Text(metric.title)
                        .font(AppTheme.Fonts.semibold(14))
                        .foregroundColor(AppTheme.Colors.primary)
                }

                HStack {
                    Text("\(metric.score)")
                        .font(AppTheme.Fonts.bold(18))
                        .foregroundColor(AppTheme.Colors.primary)

                    Text("/ 100")
                        .font(AppTheme.Fonts.medium(12))
                        .foregroundColor(AppTheme.Colors.secondary)
                }

                Capsule()
                    .fill(AppTheme.Colors.surfaceDark.opacity(0.5))
                    .frame(height: 6)
                    .overlay(
                        Capsule()
                            .fill(scoreColor)
                            .frame(width: max(16, 160 * scoreFraction), alignment: .leading)
                            .animation(.easeOut(duration: 0.4), value: scoreFraction)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    )

                Text(metric.insight)
                    .font(AppTheme.Fonts.medium(12))
                    .foregroundColor(AppTheme.Colors.secondary)
                    .lineLimit(2)
            }

            Menu {
                Button {
                    onCompareInsights?()
                } label: {
                    Label("Compare Insights", systemImage: "chart.line.uptrend.xyaxis")
                }

                Button {
                    onShare?()
                } label: {
                    Label("Share Insight", systemImage: "square.and.arrow.up")
                }
            } label: {
                Image(systemName: "ellipsis.circle")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(AppTheme.Colors.secondary.opacity(0.7))
                    .padding(6)
            }
        }
        .frame(width: 180)
        .padding(AppTheme.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.Radius.xlg)
                .fill(AppTheme.Colors.primary.opacity(0.08))
        )
    }
}
