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
            iconTint: .yellow,
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
        ScrollView {
            VStack(spacing: 12) {
                SettingsSectionHeader(title: "Account")
                groupedActionRow([
                    GroupedActionRowItem(
                        icon: "person.fill",
                        title: "Profile",
                        subtitle: "Manage your profile details like email, nickname and more",
                        destination: AnyView(SettingsAccountView())
                    ),
                    GroupedActionRowItem(
                        icon: "lock.fill",
                        title: "Privacy & Security",
                        subtitle: "Manage your account's security and data controls",
                        destination: AnyView(SettingsSecurityView())
                    )
                ])
                SettingsSectionHeader(title: "App")
                actionRow(
                    icon: "car.fill",
                    title: "Car",
                    subtitle: "Driver, vehicle, and color",
                    destination: AnyView(SettingsCarView())
                )
                SettingsSectionHeader(title: "Account Settings")
                groupedActionRow([
                    GroupedActionRowItem(
                        icon: "person.fill",
                        title: "Profile",
                        subtitle: "Manage your profile details like email, nickname and more",
                        destination: AnyView(SettingsAccountView())
                    ),
                    GroupedActionRowItem(
                        icon: "car.fill",
                        title: "Car",
                        subtitle: "Driver, vehicle, and color",
                        destination: AnyView(SettingsSecurityView())
                    )
                ])
                
                SettingsSectionHeader(title: "Preferences")

                actionRow(
                    icon: "slider.horizontal.3",
                    title: "Preferences",
                    subtitle: "Appearance, notifications, and units",
                    destination: AnyView(SettingsPreferencesView())
                )

                
                actionRow(
                    icon: "lock.fill",
                    title: "Privacy & Security",
                    subtitle: "Permissions and data controls",
                    destination: AnyView(SettingsSecurityView())
                )
                SettingsSectionHeader(title: "Group Settings")
                groupedActionRow([
                    GroupedActionRowItem(
                        icon: "wand.and.stars",
                        title: "Weekly driving report",
                        subtitle: "Your habits, highlights, and improvements",
                        destination: AnyView(SettingsSupportView())
                    ),
                    GroupedActionRowItem(
                        icon: "chart.line.uptrend.xyaxis",
                        title: "Compare time periods",
                        subtitle: "See how your score changed",
                        destination: AnyView(SettingsSupportView())
                    )
                ])

                


                SettingsSectionHeader(title: "Settings")
                actionRow(
                    icon: "rectangle.portrait.and.arrow.right",
                    iconColor: AppTheme.Colors.destructive,
                    title: "Sign Out",
                    subtitle: "Sign out of your account on this device",
                    action: {
                        animateIcon = true
                        session.signOut { success in
                            if success {
                                animateIcon = false
                            } else {
                                animateIcon = false
                            }
                        }
                    }
                )
            }
            .padding(.top, AppTheme.Spacing.sm)
            .padding(.horizontal, AppTheme.Spacing.md)
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
