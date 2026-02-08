//
//  SettingsAccountView.swift
//  Ocula
//
//  Created by Tyson Miles on 4/2/2026.
//

import SwiftUI

struct SettingsAccountView: View {
    var body: some View {
        SettingsScaffold(title: "Account") {
            ScrollView {
                VStack(spacing: 12) {
                    actionRow(
                        icon: "person.crop.circle",
                        title: "Profile Info",
                        subtitle: "Update your name and photo",
                        destination: AnyView(SettingsProfileInfoView())
                    )

                    actionRow(
                        icon: "envelope.fill",
                        title: "Email",
                        subtitle: "Manage login email",
                        destination: AnyView(SettingsEmailView())
                    )

                    actionRow(
                        icon: "ipad.and.iphone",
                        title: "Devices",
                        subtitle: "Manage linked Ocula devices",
                        destination: AnyView(SettingsDevicesView())
                    )

                    Spacer(minLength: 80)
                }
                .padding(.top, AppTheme.Spacing.sm)
                .padding(.horizontal, AppTheme.Spacing.md)
            }
        }
    }
}

struct SettingsProfileInfoView: View {
    @State private var displayName = "Ocula Driver"
    @State private var bio = "Night drives, clean footage."
    @State private var autoUpload = true

    var body: some View {
        SettingsScaffold(title: "Profile Info") {
            ScrollView {
                VStack(spacing: AppTheme.Spacing.md) {
                    settingsRow(title: "Display Name") {
                        TextField("Name", text: $displayName)
                            .textFieldStyle(.roundedBorder)
                            .frame(maxWidth: 180)
                    }

                    settingsRow(title: "Bio") {
                        VStack(alignment: .trailing) {
                            TextField("Short bio", text: $bio)
                                .textFieldStyle(.roundedBorder)
                                .frame(maxWidth: 180)
                            Toggle("", isOn: $autoUpload)
                                .labelsHidden()
                                .tint(.blue)
                        }
                    }

                    settingsRow(title: "Auto Upload Clips") {
                        Toggle("", isOn: $autoUpload)
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

struct SettingsEmailView: View {
    @State private var email = "driver@ocula.app"
    @State private var marketingEmails = false

    var body: some View {
        SettingsScaffold(title: "Email") {
            ScrollView {
                VStack(spacing: AppTheme.Spacing.md) {
                    settingsRow(title: "Primary Email") {
                        TextField("Email", text: $email)
                            .textFieldStyle(.roundedBorder)
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                            .frame(maxWidth: 200)
                    }

                    settingsRow(title: "Product Updates") {
                        Toggle("", isOn: $marketingEmails)
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

struct SettingsDevicesView: View {
    @State private var crashDetection = true
    @State private var autoSync = true

    var body: some View {
        SettingsScaffold(title: "Devices") {
            ScrollView {
                VStack(spacing: AppTheme.Spacing.md) {
                    settingsRow(title: "Crash Detection Alerts") {
                        Toggle("", isOn: $crashDetection)
                            .labelsHidden()
                            .tint(.blue)
                    }

                    settingsRow(title: "Auto Sync Footage") {
                        Toggle("", isOn: $autoSync)
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
    SettingsAccountView()
}
