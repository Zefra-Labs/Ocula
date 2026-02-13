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
            SettingsList {
                Section {
                    actionRow(
                        icon: "bell.fill",
                        title: "Notifications",
                        subtitle: "Alerts, summaries, and warnings",
                        destination: AnyView(SettingsNotificationsView()),
                        style: .list
                    )

                    actionRow(
                        icon: "paintbrush.fill",
                        title: "Appearance",
                        subtitle: "Theme and display settings",
                        destination: AnyView(SettingsAppearanceView()),
                        style: .list
                    )

                    actionRow(
                        icon: "ruler",
                        title: "Units",
                        subtitle: "Distance and speed preferences",
                        destination: AnyView(SettingsUnitsView()),
                        style: .list
                    )
                }
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
            SettingsList {
                Section(header: SettingsSectionHeader(title: "Alerts")) {
                    Toggle("Drive Alerts", isOn: $driveAlerts)
                        .tint(.blue)

                    Toggle("Daily Summary", isOn: $dailySummary)
                        .tint(.blue)

                    Toggle("Sounds", isOn: $soundEnabled)
                        .tint(.blue)
                }

                Section(
                    header: SettingsSectionHeader(title: "Quiet Hours"),
                    footer: Text("Notifications pause during this time.")
                        .captionStyle()
                ) {
                    DatePicker("Start Time", selection: $quietHoursStart, displayedComponents: .hourAndMinute)
                }
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
            SettingsList {
                Section {
                    Toggle("Large Text", isOn: $largeText)
                        .tint(.blue)

                    Toggle("Motion Effects", isOn: $motionEffects)
                        .tint(.blue)

                    Picker("Theme", selection: $theme) {
                        Text("System").tag("System")
                        Text("Light").tag("Light")
                        Text("Dark").tag("Dark")
                    }
                    .pickerStyle(.navigationLink)

                    ColorPicker("Accent Color", selection: $accentColor, supportsOpacity: false)
                }
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
            SettingsList {
                Section(header: SettingsSectionHeader(title: "Distance")) {
                    Picker("Distance Unit", selection: $distanceUnit) {
                        Text("Kilometers").tag(0)
                        Text("Miles").tag(1)
                    }
                    .pickerStyle(.navigationLink)
                }

                Section(header: SettingsSectionHeader(title: "Speed")) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Speed Limit Buffer")
                            .headlineStyle()
                        Text("\(Int(speedLimitAlert)) \(distanceUnit == 0 ? "km/h" : "mph") over limit")
                            .captionStyle()
                        Slider(value: $speedLimitAlert, in: 0...15, step: 1)
                            .tint(.blue)
                    }
                    .padding(.vertical, 4)
                }

                Section(header: SettingsSectionHeader(title: "Storage")) {
                    Stepper(value: $clipRetentionDays, in: 1...30) {
                        Text("Clip Retention (Days): \(clipRetentionDays)")
                            .headlineStyle()
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsPreferencesView()
}
