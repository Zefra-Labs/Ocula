//
//  settingsActionRow.swift
//  Ocula
//
//  Created by Tyson Miles on 4/2/2026.
//

import SwiftUI

@ViewBuilder
func settingsRow<Content: View>(
    heading: String? = nil,
    subheading: String? = nil,
    title: String,
    subtitle: String? = nil,
    @ViewBuilder trailing: () -> Content
) -> some View {
    settingsRowBase(
        heading: heading,
        subheading: subheading,
        title: title,
        subtitle: subtitle
    ) {
        trailing()
    }
}

@ViewBuilder
func settingsRow(
    heading: String? = nil,
    subheading: String? = nil,
    title: String,
    subtitle: String? = nil
) -> some View {
    settingsRowBase(
        heading: heading,
        subheading: subheading,
        title: title,
        subtitle: subtitle
    ) {
        EmptyView()
    }
}

private func settingsRowBase<Content: View>(
    heading: String?,
    subheading: String?,
    title: String,
    subtitle: String?,
    @ViewBuilder trailing: () -> Content
) -> some View {
    let rowContent = HStack(alignment: .center, spacing: AppTheme.Spacing.md) {
        VStack(alignment: .leading, spacing: 4) {
            if let heading {
                Text(heading)
                    .captionStyle()
                    .foregroundColor(AppTheme.Colors.secondary)
            }

            Text(title)
                .headlineStyle()
                .foregroundColor(AppTheme.Colors.primary)

            if let subtitle {
                Text(subtitle)
                    .captionStyle()
                    .foregroundColor(AppTheme.Colors.secondary)
            }

            if let subheading {
                Text(subheading)
                    .captionStyle()
                    .foregroundColor(AppTheme.Colors.secondary)
            }
        }

        Spacer(minLength: 0)

        trailing()
    }

    return rowContent
        .frame(minHeight: 37, alignment: .center)
        .padding(AppTheme.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.Radius.xlg)
                .fill(AppTheme.Colors.primary.opacity(0.08))
        )
}
#Preview {
    @Previewable @State var includeLogs: Bool = false
    VStack(spacing: 12) {
        
        actionRow(
            icon: "map.fill",
            title: "Location & Status",
            subtitle: "View current location and stats"
        )
        actionRow(
            icon: "video.fill",
            title: "Live View",
            subtitle: "View cameras in real time"
        )
        settingsRow(title: "Include Diagnostics", subtitle: "Lorem Ipsum") {
            Toggle("", isOn: $includeLogs)
                .labelsHidden()
                .tint(.blue)
        }
        
    }
}
