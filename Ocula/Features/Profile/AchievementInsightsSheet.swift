//
//  AchievementInsightsSheet.swift
//  Ocula
//
//  Created by Tyson Miles on 7/2/2026.
//

import SwiftUI
import UIKit

struct AchievementInsightsSheet: View {
    let achievement: Achievement

    @State private var showActionAlert = false

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
                Text(achievement.title)
                    .headlineBoldStyle()

                Text(achievement.subtitle)
                    .captionStyle()

                HStack(spacing: 12) {
                    Label(unlockDateText, systemImage: "calendar")
                    Label(peopleText, systemImage: "person.2.fill")
                }
                .font(AppTheme.Fonts.medium(11))
                .foregroundColor(AppTheme.Colors.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        .padding(AppTheme.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.Radius.xlg)
                .fill(AppTheme.Colors.primary.opacity(0.08))
        )

            VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                Text("Actions")
                    .headlineStyle()

                actionRow(
                    icon: "square.and.arrow.up",
                    iconColor: .green,
                    title: "Share badge",
                    subtitle: "Copy achievement summary",
                    trailingValue: nil,
                    action: shareBadge
                )

                actionRow(
                    icon: "bell.fill",
                    iconColor: .yellow,
                    title: "Set reminder",
                    subtitle: "Nudge me when close",
                    trailingValue: nil,
                    action: setReminder
                )
            }

            Spacer(minLength: 0)
        }
        .padding(.horizontal, AppTheme.Spacing.md)
        .padding(.top, AppTheme.Spacing.md)
        .alert("Done", isPresented: $showActionAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Action completed.")
        }
    }
}

private extension AchievementInsightsSheet {
    var unlockDateText: String {
        achievement.isUnlocked ? "Unlocked Jan 2026" : "Not unlocked yet"
    }

    var peopleText: String {
        let percent = max(5, 100 - Int(achievement.progress * 70))
        return "\(percent)% of drivers"
    }

    func shareBadge() {
        UIPasteboard.general.string = "\(achievement.title) — \(achievement.subtitle)"
        showActionAlert = true
    }

    func setReminder() {
        showActionAlert = true
    }
}
