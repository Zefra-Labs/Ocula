//
//  SettingsSecurityView.swift
//  Ocula
//
//  Created by Tyson Miles on 4/2/2026.
//

import SwiftUI

struct SettingsSecurityView: View {
    var body: some View {
        SettingsScaffold(title: "Privacy & Security") {
            SettingsList {
                Section {
                    actionRow(
                        icon: "hand.raised.fill",
                        title: "Privacy",
                        subtitle: "Control what data is shared",
                        destination: AnyView(SettingsPrivacyView()),
                        style: .list
                    )

                    actionRow(
                        icon: "lock.shield.fill",
                        title: "Security",
                        subtitle: "Password and login settings",
                        destination: AnyView(SettingsSecurityDetailView()),
                        style: .list
                    )

                    actionRow(
                        icon: "location.fill",
                        title: "Permissions",
                        subtitle: "Location, camera, and motion",
                        destination: AnyView(SettingsPermissionsView()),
                        style: .list
                    )
                }
            }
        }
    }
}

struct SettingsPrivacyView: View {
    @State private var shareDiagnostics = true
    @State private var cloudBackups = true

    var body: some View {
        SettingsScaffold(title: "Privacy") {
            SettingsList {
                Section {
                    Toggle("Share Diagnostics", isOn: $shareDiagnostics)
                        .tint(.blue)

                    Toggle("Cloud Backups", isOn: $cloudBackups)
                        .tint(.blue)
                }
            }
        }
    }
}

struct SettingsSecurityDetailView: View {
    @State private var faceId = true
    @State private var requirePasscode = true

    var body: some View {
        SettingsScaffold(title: "Security") {
            SettingsList {
                Section(footer: Text("Understand what data and information the Ocula app collects by reading the Terms of Use and Privacy Policy.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)) {
                    Toggle("Use Face ID", isOn: $faceId)
                        .tint(.blue)

                    Toggle("Require Passcode", isOn: $requirePasscode)
                        .tint(.blue)
                }
            }
        }
    }
}

struct SettingsPermissionsView: View {
    @State private var locationAccess = 1
    @State private var cameraAccess = true
    @State private var motionAccess = true

    var body: some View {
        SettingsScaffold(title: "Permissions") {
            SettingsList {
                Section {
                    Picker("Location Access", selection: $locationAccess) {
                        Text("Always").tag(0)
                        Text("While Using").tag(1)
                        Text("Never").tag(2)
                    }
                    .pickerStyle(.segmented)

                    Toggle("Camera", isOn: $cameraAccess)
                        .tint(.blue)

                    Toggle("Motion & Fitness", isOn: $motionAccess)
                        .tint(.blue)
                }
            }
        }
    }
}

#Preview {
    SettingsSecurityView()
}
