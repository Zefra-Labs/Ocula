//
//  AchievementAllSheet.swift
//  Ocula
//
//  Created by Tyson Miles on 8/2/2026.
//

import SwiftUI

struct AchievementAllSheet: View {
    let achievements: [Achievement]

    var body: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            HStack {
                Text("Achievements")
                    .title2Style()
                    .foregroundColor(AppTheme.Colors.secondary)

                Spacer()

                Image(systemName: "chart.line.uptrend.xyaxis")
                    .foregroundColor(AppTheme.Colors.secondary)
            }

            VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                Text("Your Progress")
                    .headlineStyle()

                ProgressView(value: Double(unlockedCount), total: Double(max(totalCount, 1)))
                    .tint(AppTheme.Colors.primary)

                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(unlockedCount)")
                            .font(AppTheme.Fonts.bold(22))
                            .foregroundColor(AppTheme.Colors.primary)

                        Text("Unlocked")
                            .font(AppTheme.Fonts.medium(11))
                            .foregroundColor(AppTheme.Colors.secondary)
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 4) {
                        Text("\(remainingCount)")
                            .font(AppTheme.Fonts.bold(22))
                            .foregroundColor(AppTheme.Colors.primary)

                        Text("Left to unlock")
                            .font(AppTheme.Fonts.medium(11))
                            .foregroundColor(AppTheme.Colors.secondary)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(AppTheme.Spacing.md)
            .background(
            RoundedRectangle(cornerRadius: AppTheme.Radius.xlg)
                .fill(AppTheme.Colors.primary.opacity(0.08))
        )

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppTheme.Spacing.sm) {
                    ForEach(achievements) { achievement in
                        AchievementCardView(
                            achievement: achievement,
                            onViewInsights: nil,
                            onShare: nil
                        )
                    }
                }
                .padding(.horizontal, 2)
            }

            Spacer(minLength: 0)
        }
        .padding(.horizontal, AppTheme.Spacing.md)
        .padding(.top, AppTheme.Spacing.md)
    }
}

private extension AchievementAllSheet {
    var totalCount: Int {
        achievements.count
    }

    var unlockedCount: Int {
        achievements.filter { $0.isUnlocked }.count
    }

    var remainingCount: Int {
        max(totalCount - unlockedCount, 0)
    }
}
