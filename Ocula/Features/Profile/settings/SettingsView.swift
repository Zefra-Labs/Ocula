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

    var body: some View {
        SettingsScaffold(title: "Settings") {
            VStack(spacing: AppTheme.Spacing.lg) {
                settingsHeader
                settingsActions
            }
        }
    }
}

private extension SettingsView {

    var settingsHeader: some View {
        HStack(spacing: AppTheme.Spacing.md) {
            ProfileAvatarView(imageURL: userImageURL)

            VStack(alignment: .leading, spacing: 4) {
                Text(userDisplayName)
                    .headlineStyle()
                    .fontWeight(.bold)

                Text(userEmail)
                    .captionStyle()
            }

            Spacer()
        }
        .padding(.top, AppTheme.Spacing.lg)
        .padding(.horizontal, AppTheme.Spacing.md)
        .glassEffect(in:
            RoundedRectangle(cornerRadius: AppTheme.Radius.xlg)
        )
    }

    var settingsActions: some View {
        ScrollView {
            VStack(spacing: 12) {
                SettingsSectionHeader(title: "Settings")

                actionRow(
                    icon: "person.fill",
                    title: "Account",
                    subtitle: "Profile, email, and devices",
                    destination: AnyView(SettingsAccountView())
                )

                actionRow(
                    icon: "car.fill",
                    title: "Car",
                    subtitle: "Driver, vehicle, and color",
                    destination: AnyView(SettingsCarView())
                )
                
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
                    subtitle: "Sign out of your account",
                    action: {
                        session.signOut()
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
