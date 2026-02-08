//
//  LeaderboardView.swift
//  Ocula
//
//  Created by Tyson Miles on 7/2/2026.
//

import SwiftUI

struct LeaderboardView: View {
    let stats: ProfileStats

    var body: some View {
        SettingsScaffold(title: "Leaderboard") {
            ScrollView {
                VStack(spacing: AppTheme.Spacing.lg) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Top \(stats.topPercent)% in \(stats.region)")
                            .font(AppTheme.Fonts.bold(24))
                            .foregroundColor(AppTheme.Colors.primary)

                        Text(stats.weeklyMovement)
                            .font(AppTheme.Fonts.medium(13))
                            .foregroundColor(AppTheme.Colors.secondary)

                        Text("You beat \(stats.friendsBeaten) friends")
                            .font(AppTheme.Fonts.medium(13))
                            .foregroundColor(AppTheme.Colors.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(AppTheme.Spacing.lg)
                    .background(
            RoundedRectangle(cornerRadius: AppTheme.Radius.xlg)
                .fill(AppTheme.Colors.primary.opacity(0.08))
        )

                    VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                        Text("Nearby Drivers")
                            .headlineStyle()

                        actionRow(
                            icon: "medal.fill",
                            iconColor: .yellow,
                            title: "You",
                            subtitle: "Score \(stats.driverScore)",
                            trailingValue: "#1",
                            action: {}
                        )

                        actionRow(
                            icon: "person.fill",
                            iconColor: .blue,
                            title: "Alex",
                            subtitle: "Score 78",
                            trailingValue: "#2",
                            action: {}
                        )

                        actionRow(
                            icon: "person.fill",
                            iconColor: .purple,
                            title: "Jordan",
                            subtitle: "Score 74",
                            trailingValue: "#3",
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
    LeaderboardView(stats: ProfileStats.placeholder())
}
