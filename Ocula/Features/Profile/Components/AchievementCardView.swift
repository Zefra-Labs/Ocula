//
//  AchievementCardView.swift
//  Ocula
//
//  Created by Tyson Miles on 7/2/2026.
//

import SwiftUI

struct AchievementCardView: View {
    let achievement: Achievement
    var onViewInsights: (() -> Void)? = nil
    var onShare: (() -> Void)? = nil

    private var progressFraction: CGFloat {
        CGFloat(min(max(achievement.progress, 0), 1))
    }

    private var accentColor: Color {
        achievement.isUnlocked ? .green : AppTheme.Colors.secondary
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: achievement.systemIcon)
                        .foregroundColor(accentColor)

                    Spacer()

                    Text(achievement.isUnlocked ? "Unlocked" : "In progress")
                        .font(AppTheme.Fonts.medium(11))
                        .foregroundColor(AppTheme.Colors.secondary)
                }

                Text(achievement.title)
                    .font(AppTheme.Fonts.semibold(16))
                    .foregroundColor(AppTheme.Colors.primary)

                Text(achievement.subtitle)
                    .font(AppTheme.Fonts.medium(12))
                    .foregroundColor(AppTheme.Colors.secondary)
                    .lineLimit(2)

                Capsule()
                    .fill(AppTheme.Colors.surfaceDark.opacity(0.5))
                    .frame(height: 6)
                    .overlay(
                        Capsule()
                            .fill(accentColor)
                            .frame(width: max(14, 160 * progressFraction), alignment: .leading)
                            .animation(.easeOut(duration: 0.4), value: progressFraction)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    )
            }

            Menu {
                Button {
                    onViewInsights?()
                } label: {
                    Label("View Insights", systemImage: "chart.line.uptrend.xyaxis")
                }

                Button {
                    onShare?()
                } label: {
                    Label("Share Badge", systemImage: "square.and.arrow.up")
                }
            } label: {
                Image(systemName: "ellipsis.circle")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(AppTheme.Colors.secondary.opacity(0.7))
                    .padding(6)
            }
        }
        .frame(width: 190)
        .padding(AppTheme.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.Radius.xlg)
                .fill(AppTheme.Colors.primary.opacity(0.08))
        )
    }
}
