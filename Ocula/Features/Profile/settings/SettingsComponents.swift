//
//  SettingsComponents.swift
//  Ocula
//
//  Created by Tyson Miles on 4/2/2026.
//

import SwiftUI

struct SettingsScaffold<Content: View>: View {

    let title: String
    let content: Content

    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            SettingsNavBar(title: title)
            content
        }
        .padding(.top, AppTheme.Spacing.md)
        .background(AppTheme.Colors.background)
        .toolbar(.hidden, for: .navigationBar)
    }
}

struct SettingsNavBar: View {

    let title: String
    var showsBackButton: Bool = true

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        HStack {
            if showsBackButton {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(AppTheme.Colors.primary)
                        .font(.title3.weight(.semibold))
                }
            } else {
                Color.clear
                    .frame(width: 28, height: 28)
            }

            Spacer()

            Text(title)
                .headlineStyle()
                .fontWeight(.bold)

            Spacer()

            Color.clear
                .frame(width: 28, height: 28)

        }
        .padding(.horizontal, AppTheme.Spacing.md)
    }
}

struct SettingsSectionHeader: View {

    let title: String

    var body: some View {
        Text(title)
            .font(.headline)
            .foregroundColor(AppTheme.Colors.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, AppTheme.Spacing.md)
    }
}

#Preview {
    SettingsScaffold(title: "Preview") {
        Text("Preview Content")
            .foregroundColor(AppTheme.Colors.primary)
    }
}
