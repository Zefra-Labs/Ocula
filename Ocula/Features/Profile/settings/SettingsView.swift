//
//  SettingsView.swift
//  Ocula
//
//  Created by Tyson Miles on 4/2/2026.
//

import SwiftUI
import FirebaseAuth

struct SettingsView: View {

    @EnvironmentObject var session: SessionManager
    @State private var animateIcon = false

    var body: some View {
        SettingsScaffold(title: "Settings") {
                settingsActions
        }
        .oculaAlertSheet(
            isPresented: $session.showSignOutOverlay,
            icon: "circle.dotted",
            iconTint: .blue,
            title: "Signing Out...",
            message: "",
            showsIconRing: false,
            iconModifier: { image in
                AnyView(image.symbolRenderingMode(.hierarchical))
            },
            iconAnimator: { image, _ in
                if #available(iOS 17.0, *) {
                    return AnyView(
                        image
                            .symbolEffect(.rotate.byLayer, options: .repeat(.continuous))
                    )
                } else {
                    return AnyView(image)
                }
            },
            iconAnimationActive: animateIcon
        )
    }
}

private extension SettingsView {

    var settingsActions: some View {
        SettingsList {
            Section(header: SettingsSectionHeader(title: "Account")) {
                actionRow(
                    icon: "person.fill",
                    title: "Profile",
                    subtitle: "Manage your profile and account info like email, nickname, and more",
                    destination: AnyView(SettingsAccountView()),
                    style: .list
                )
                actionRow(
                    icon: "lock.fill",
                    title: "Privacy & Security",
                    subtitle: "Manage your account's priavacy, security and data controls",
                    destination: AnyView(SettingsSecurityView()),
                    style: .list
                )
                actionRow(
                    icon: "bell.fill",
                    title: "Notifications",
                    subtitle: "Manage your account's push notification preferences",
                    destination: AnyView(SettingsSecurityView()),
                    style: .list
                )
                
            }
            Section(header: SettingsSectionHeader(title: "Trips & Devices")) {
                actionRow(
                    icon: "point.topright.filled.arrow.triangle.backward.to.point.bottomleft.scurvepath",
                    title: "Trips",
                    subtitle: "Manage preferences and settings for trips that your Ocula records",
                    destination: AnyView(SettingsAccountView()),
                    style: .list
                )

                actionRow(
                    icon: "car.fill",
                    title: "Devices",
                    subtitle: "Manage, add or remove Ocula devices connected to your account ",
                    destination: AnyView(SettingsSecurityView()),
                    style: .list
                )
            }

            Section(header: SettingsSectionHeader(title: "App Settings")) {
                actionRow(
                    icon: "car.fill",
                    title: "Car",
                    subtitle: "Driver, vehicle, and color",
                    destination: AnyView(SettingsCarView()),
                    style: .list
                )
            }
            Section(header: SettingsSectionHeader(title: "Emergency SOS")) {
                actionRow(
                    icon: "sos.circle.fill",
                    title: "Emergency SOS",
                    subtitle: "Manage preferences for your Ocula's Emergency SOS system",
                    destination: AnyView(SettingsSecurityView()),
                    style: .list
                )
            }

            Section(header: SettingsSectionHeader(title: "")) {
                actionRow(
                    icon: "book.pages.fill",
                    title: "User Guides",
                    subtitle: "Search and view user guides and manuals for any Ocula device",
                    destination: AnyView(SettingsAccountView()),
                    style: .list
                )
                actionRow(
                    icon: "info.circle.text.page.fill",
                    title: "App Information",
                    subtitle: "View app information, version information and debug information",
                    destination: AnyView(SettingsSecurityView()),
                    style: .list
                )
                actionRow(
                    icon: "books.vertical.fill",
                    title: "Legal Information",
                    subtitle: "View the Ocula Privacy Policy, Terms of Service and other legal information",
                    destination: AnyView(SettingsLegalView()),
                    style: .list
                )
            }
            Section(header: SettingsSectionHeader(title: "")) {
                actionRow(
                    icon: "rectangle.portrait.and.arrow.right",
                    iconColor: AppTheme.Colors.destructive,
                    title: "Sign Out",
                    subtitle: "Sign out of your account on this device only",
                    action: {
                        animateIcon = true
                        session.signOut { success in
                            if success {
                                animateIcon = false
                            } else {
                                animateIcon = false
                            }
                        }
                    },
                    style: .list
                )
            }
        }
    }

    var userDisplayName: String {
        session.user?.displayName
        ?? Auth.auth().currentUser?.displayName
        ?? "Anonymous"
    }

    var userEmail: String {
        session.user?.email
        ?? Auth.auth().currentUser?.email
        ?? ""
    }

    var userImageURL: String? {
        Auth.auth().currentUser?.photoURL?.absoluteString
    }
}

#Preview {
    SettingsView()
        .environmentObject(SessionManager())
}
