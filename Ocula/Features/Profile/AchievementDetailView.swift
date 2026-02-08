//
//  AchievementDetailView.swift
//  Ocula
//
//  Created by Tyson Miles on 7/2/2026.
//

import SwiftUI

struct AchievementDetailView: View {
    let achievement: Achievement

    var body: some View {
        SettingsScaffold(title: "Achievement") {
            ScrollView {
                VStack(spacing: AppTheme.Spacing.lg) {
                    VStack(spacing: 10) {
                        Image(systemName: achievement.systemIcon)
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(achievement.isUnlocked ? .green : AppTheme.Colors.secondary)

                        Text(achievement.title)
                            .font(AppTheme.Fonts.bold(24))
                            .foregroundColor(AppTheme.Colors.primary)

                        Text(achievement.subtitle)
                            .font(AppTheme.Fonts.medium(13))
                            .foregroundColor(AppTheme.Colors.secondary)

                        Text(achievement.isUnlocked ? "Unlocked" : "In progress")
                            .font(AppTheme.Fonts.medium(12))
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
                            icon: "bell.fill",
                            iconColor: .yellow,
                            title: "Remind me",
                            subtitle: "Get notified when close",
                            trailingValue: nil,
                            action: setReminder
                        )

                        actionRow(
                            icon: "square.and.arrow.up",
                            iconColor: .green,
                            title: "Share badge",
                            subtitle: "Send to friends",
                            trailingValue: nil,
                            action: shareAchievement
                        )
                    }
                }
                .padding(.horizontal, AppTheme.Spacing.md)
                .padding(.bottom, AppTheme.Spacing.xl)
            }
        }
    }
}

private extension AchievementDetailView {
    func setReminder() {
        print("Set reminder for \(achievement.title)")
    }

    func shareAchievement() {
        print("Share achievement \(achievement.title)")
    }
}

#Preview {
    AchievementDetailView(
        achievement: Achievement(title: "100 Trips Club", subtitle: "Hit 100 recorded trips", progress: 1.0, isUnlocked: true, systemIcon: "trophy.fill")
    )
}
