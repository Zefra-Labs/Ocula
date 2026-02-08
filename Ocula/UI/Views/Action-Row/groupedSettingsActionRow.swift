//
//  groupedSettingsActionRow.swift
//  Ocula
//
//  Created by Tyson Miles on 8/2/2026.
//

import SwiftUI

struct GroupedSettingsRowItem: Identifiable {
    let id = UUID()
    let heading: String?
    let subheading: String?
    let title: String
    let subtitle: String?
    let trailing: AnyView
    let destination: AnyView?
    let action: (() -> Void)?

    init(
        heading: String? = nil,
        subheading: String? = nil,
        title: String,
        subtitle: String? = nil,
        destination: AnyView? = nil,
        action: (() -> Void)? = nil
    ) {
        self.heading = heading
        self.subheading = subheading
        self.title = title
        self.subtitle = subtitle
        self.trailing = AnyView(EmptyView())
        self.destination = destination
        self.action = action
    }

    init<T: View>(
        heading: String? = nil,
        subheading: String? = nil,
        title: String,
        subtitle: String? = nil,
        destination: AnyView? = nil,
        action: (() -> Void)? = nil,
        @ViewBuilder trailing: () -> T
    ) {
        self.heading = heading
        self.subheading = subheading
        self.title = title
        self.subtitle = subtitle
        self.trailing = AnyView(trailing())
        self.destination = destination
        self.action = action
    }
}

@ViewBuilder
func groupedSettingsRow(_ items: [GroupedSettingsRowItem]) -> some View {
    VStack(spacing: AppTheme.Spacing.sm) {
        ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
            groupedSettingsRowItem(item, isFirst: index == 0, isLast: index == items.count - 1)
        }
    }
    .padding(AppTheme.Spacing.sm)
    .background(
        RoundedRectangle(cornerRadius: AppTheme.Radius.xlg, style: .continuous)
            .fill(AppTheme.Colors.primary.opacity(0.05))
    )
    .padding(.horizontal, AppTheme.Spacing.md)
}

@ViewBuilder
private func groupedSettingsRowItem(
    _ item: GroupedSettingsRowItem,
    isFirst: Bool,
    isLast: Bool
) -> some View {
    let rowContent = HStack(alignment: .center, spacing: AppTheme.Spacing.md) {
        VStack(alignment: .leading, spacing: 4) {
            if let heading = item.heading {
                Text(heading)
                    .captionStyle()
                    .foregroundColor(AppTheme.Colors.secondary)
            }

            Text(item.title)
                .headlineStyle()
                .foregroundColor(AppTheme.Colors.primary)

            if let subtitle = item.subtitle {
                Text(subtitle)
                    .captionStyle()
                    .foregroundColor(AppTheme.Colors.secondary)
            }

            if let subheading = item.subheading {
                Text(subheading)
                    .captionStyle()
                    .foregroundColor(AppTheme.Colors.secondary)
            }
        }
        .padding(.vertical, AppTheme.Spacing.md)

        Spacer(minLength: 0)

        item.trailing
    }

    let styledContent = rowContent
        .frame(minHeight: 37, alignment: .center)
        .padding(AppTheme.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.Radius.xlg, style: .continuous)
                .fill(AppTheme.Colors.primary.opacity(0.08))
        )
        .contentShape(Rectangle())

    if let destination = item.destination {
        NavigationLink { destination } label: { styledContent }
            .buttonStyle(GroupedSettingsRowStyle())
    } else if let action = item.action {
        Button(action: { action() }) {
            styledContent
        }
        .buttonStyle(GroupedSettingsRowStyle())
    } else {
        styledContent
    }
}

struct GroupedSettingsRowStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                RoundedRectangle(cornerRadius: AppTheme.Radius.xlg)
                    .fill(AppTheme.Colors.primary.opacity(configuration.isPressed ? 0.08 : 0))
            )
            .animation(.easeOut(duration: 0.25), value: configuration.isPressed)
    }
}
