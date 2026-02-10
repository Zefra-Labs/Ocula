//
//  SettingsPreferencesView.swift
//  Ocula
//
//  Created by Tyson Miles on 4/2/2026.
//

import SwiftUI

struct SettingsPreferencesView: View {
    var body: some View {
        SettingsScaffold(title: "Preferences") {
            ScrollView {
                VStack(spacing: 12) {
                    actionRow(
                        icon: "bell.fill",
                        title: "Notifications",
                        subtitle: "Alerts, summaries, and warnings",
                        destination: AnyView(SettingsNotificationsView())
                    )

                    actionRow(
                        icon: "paintbrush.fill",
                        title: "Appearance",
                        subtitle: "Theme and display settings",
                        destination: AnyView(SettingsAppearanceView())
                    )

                    actionRow(
                        icon: "ruler",
                        title: "Units",
                        subtitle: "Distance and speed preferences",
                        destination: AnyView(SettingsUnitsView())
                    )

                    Spacer(minLength: 80)
                }
                .padding(.top, AppTheme.Spacing.sm)
                .padding(.horizontal, AppTheme.Spacing.md)
            }
        }
    }
}

struct SettingsNotificationsView: View {
    @State private var driveAlerts = true
    @State private var dailySummary = false
    @State private var soundEnabled = true
    @State private var quietHoursStart = Date()

    var body: some View {
        SettingsScaffold(title: "Notifications") {
            ScrollView {
                VStack(spacing: AppTheme.Spacing.md) {
                    settingsRow(heading: "Alerts", title: "Drive Alerts") {
                        Toggle("", isOn: $driveAlerts)
                            .labelsHidden()
                            .tint(.blue)
                    }

                    settingsRow(title: "Daily Summary") {
                        Toggle("", isOn: $dailySummary)
                            .labelsHidden()
                            .tint(.blue)
                    }

                    settingsRow(title: "Sounds") {
                        Toggle("", isOn: $soundEnabled)
                            .labelsHidden()
                            .tint(.blue)
                    }

                    settingsRow(
                        heading: "Quiet Hours",
                        subheading: "Notifications pause during this time.",
                        title: "Start Time"
                    ) {
                        DatePicker("", selection: $quietHoursStart, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                    }

                    Spacer(minLength: 80)
                }
                .padding(.top, AppTheme.Spacing.sm)
                .padding(.horizontal, AppTheme.Spacing.md)
            }
        }
    }
}

struct SettingsAppearanceView: View {
    @State private var largeText = false
    @State private var motionEffects = true
    @State private var theme = "System"
    @State private var accentColor = Color.blue

    var body: some View {
        SettingsScaffold(title: "Appearance") {
            ScrollView {
                VStack(spacing: AppTheme.Spacing.md) {
                    settingsRow(title: "Large Text") {
                        Toggle("", isOn: $largeText)
                            .labelsHidden()
                            .tint(.blue)
                    }

                    settingsRow(title: "Motion Effects") {
                        Toggle("", isOn: $motionEffects)
                            .labelsHidden()
                            .tint(.blue)
                    }

                    settingsRow(title: "Theme") {
                        Picker("", selection: $theme) {
                            Text("System").tag("System")
                            Text("Light").tag("Light")
                            Text("Dark").tag("Dark")
                        }
                        .pickerStyle(.navigationLink)
                    }

                    settingsRow(title: "Accent Color") {
                        ColorPicker("", selection: $accentColor, supportsOpacity: false)
                            .labelsHidden()
                    }

                    Spacer(minLength: 80)
                }
                .padding(.top, AppTheme.Spacing.sm)
                .padding(.horizontal, AppTheme.Spacing.md)
            }
        }
    }
}

struct SettingsUnitsView: View {
    @State private var distanceUnit = 0
    @State private var speedLimitAlert = 6.0
    @State private var clipRetentionDays = 7

    var body: some View {
        SettingsScaffold(title: "Units") {
            ScrollView {
                VStack(spacing: AppTheme.Spacing.md) {
                    settingsRow(title: "Distance Unit") {
                        Picker("Distance", selection: $distanceUnit) {
                            Text("Kilometers").tag(0)
                            Text("Miles").tag(1)
                        }
                        .pickerStyle(.segmented)
                        .frame(maxWidth: 200)
                    }

                    settingsRow(
                        heading: "Speed",
                        title: "Speed Limit Buffer",
                        subtitle: "\(Int(speedLimitAlert)) \(distanceUnit == 0 ? "km/h" : "mph") over limit"
                    ) {
                        Slider(value: $speedLimitAlert, in: 0...15, step: 1)
                            .tint(.blue)
                            .frame(maxWidth: 160)
                    }

                    settingsRow(title: "Clip Retention (Days)") {
                        Stepper(value: $clipRetentionDays, in: 1...30) {
                            Text("\(clipRetentionDays)")
                                .headlineStyle()
                        }
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
    SettingsPreferencesView()
}
