//
//  SettingsSupportView.swift
//  Ocula
//
//  Created by Tyson Miles on 4/2/2026.
//

import SwiftUI

struct SettingsSupportView: View {
    var body: some View {
        SettingsScaffold(title: "Support") {
            ScrollView {
                VStack(spacing: 12) {
                    actionRow(
                        icon: "questionmark.circle.fill",
                        title: "Help Center",
                        subtitle: "FAQs and troubleshooting",
                        destination: AnyView(SettingsHelpCenterView())
                    )

                    actionRow(
                        icon: "exclamationmark.bubble.fill",
                        title: "Report a Problem",
                        subtitle: "Share feedback or issues",
                        destination: AnyView(SettingsReportProblemView())
                    )

                    actionRow(
                        icon: "info.circle.fill",
                        title: "About Ocula",
                        subtitle: "Version and legal information",
                        destination: AnyView(SettingsAboutView())
                    )

                    Spacer(minLength: 80)
                }
                .padding(.top, AppTheme.Spacing.sm)
                .padding(.horizontal, AppTheme.Spacing.md)
            }
        }
    }
}

struct SettingsHelpCenterView: View {
    @State private var tipsEnabled = true

    var body: some View {
        SettingsScaffold(title: "Help Center") {
            ScrollView {
                VStack(spacing: AppTheme.Spacing.md) {
                    settingsRow(title: "Show Driving Tips") {
                        Toggle("", isOn: $tipsEnabled)
                            .labelsHidden()
                            .tint(.blue)
                    }

                    settingsRow(
                        heading: "Quick Links",
                        title: "Getting Started",
                        subtitle: "Camera setup, night mode, and storage."
                    )

                    Spacer(minLength: 80)
                }
                .padding(.top, AppTheme.Spacing.sm)
                .padding(.horizontal, AppTheme.Spacing.md)
            }
        }
    }
}

struct SettingsReportProblemView: View {
    @State private var includeLogs = true
    @State private var description = ""

    var body: some View {
        SettingsScaffold(title: "Report a Problem") {
            ScrollView {
                VStack(spacing: AppTheme.Spacing.md) {
                    groupedSettingsRow([
                        GroupedSettingsRowItem(
                            title: "Include Diagnostics",
                            subtitle: "Attach logs to reports"
                        ) {
                            Toggle("", isOn: $includeLogs)
                                .labelsHidden()
                                .tint(.blue)
                        },
                        GroupedSettingsRowItem(
                            title: "Notifications",
                            subtitle: "Manage alerts",
                            action: { print("Compare") }
                        )
                    ])
                    settingsRow(title: "Describe the Issue") {
                        TextEditor(text: $description)
                            .frame(minHeight: 90, maxHeight: 110)
                            .padding(6)
                            .background(
                                RoundedRectangle(cornerRadius: AppTheme.Radius.md)
                                    .fill(AppTheme.Colors.primary.opacity(0.08))
                            )
                            .frame(maxWidth: 200)
                    }

                    Spacer(minLength: 80)
                }
                .padding(.top, AppTheme.Spacing.sm)
                .padding(.horizontal, AppTheme.Spacing.md)
            }
        }
    }
}

struct SettingsAboutView: View {
    @State private var betaFeatures = false

    var body: some View {
        SettingsScaffold(title: "About Ocula") {
            ScrollView {
                VStack(spacing: AppTheme.Spacing.md) {
                    settingsRow(title: "Version") {
                        Text("1.0.0")
                            .captionStyle()
                    }

                    settingsRow(title: "Enable Beta Features") {
                        Toggle("", isOn: $betaFeatures)
                            .labelsHidden()
                            .tint(.blue)
                    }

                    Spacer(minLength: 80)
                }
                .padding(.top, AppTheme.Spacing.sm)
                .padding(.horizontal, AppTheme.Spacing.md)
            }
        }
    }
}

#Preview {
    SettingsSupportView()
}
