//
//  groupedActionRow.swift
//  Ocula
//
//  Created by Tyson Miles on 8/2/2026.
//

import SwiftUI

struct GroupedActionRowItem: Identifiable {
    let id: UUID
    let icon: String
    let title: String
    let subtitle: String?
    let destination: AnyView?
    let action: (() -> Void)?

    init(
        id: UUID = UUID(),
        icon: String,
        title: String,
        subtitle: String? = nil,
        destination: AnyView? = nil,
        action: (() -> Void)? = nil
    ) {
        #if DEBUG
        if destination != nil && action != nil {
            assertionFailure("GroupedActionRowItem: provide either destination or action, not both")
        }
        #endif
        self.id = id
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.destination = destination
        self.action = action
    }

    var preferredDestination: AnyView? {
        destination
    }
}

struct GroupedSettingsActionRow: View {
    let items: [GroupedActionRowItem]

    var body: some View {
        if items.isEmpty {
            EmptyView()
        } else {
            VStack(spacing: 0) {
                ForEach(Array(items.enumerated()), id: \..element.id) { index, item in
                    GroupedActionRowItemView(
                        item: item,
                        isFirst: index == 0,
                        isLast: index == items.count - 1
                    )

                    if index < items.count - 1 {
                        Divider()
                            .overlay(AppTheme.Colors.surfaceDark.opacity(0.35))
                    }
                }
            }
            .background(
                RoundedRectangle(cornerRadius: AppTheme.Radius.xlg, style: .continuous)
                    .fill(AppTheme.Colors.primary.opacity(0.08))
            )
        }
    }

    private var iconColumnWidth: CGFloat { 28 }
}

private struct GroupedActionRowItemView: View {
    let item: GroupedActionRowItem
    let isFirst: Bool
    let isLast: Bool

    private var cornerRadius: CGFloat { AppTheme.Radius.xlg }

    var body: some View {
        let content = HStack(spacing: AppTheme.Spacing.md) {
            Image(systemName: item.icon)
                .title2Style()
                .foregroundColor(AppTheme.Colors.primary)
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 2) {
                Text(item.title)
                    .headlineStyle()
                    .lineLimit(1)

                if let subtitle = item.subtitle {
                    Text(subtitle)
                        .captionStyle()
                        .lineLimit(2)
                }
            }

            Spacer(minLength: 0)

            if item.preferredDestination != nil {
                Image(systemName: "chevron.right")
                    .bodyStyle()
                    .foregroundColor(AppTheme.Colors.secondary)
            }
        }
        .padding(AppTheme.Spacing.md)
        .contentShape(Rectangle())

        if let destination = item.preferredDestination {
            NavigationLink { destination } label: { content }
                .buttonStyle(GroupedActionRowStyle(isFirst: isFirst, isLast: isLast, cornerRadius: cornerRadius))
        } else if let action = item.action {
            Button(action: action) { content }
                .buttonStyle(GroupedActionRowStyle(isFirst: isFirst, isLast: isLast, cornerRadius: cornerRadius))
        } else {
            content
        }
    }
}

private struct GroupedActionRowStyle: ButtonStyle {
    let isFirst: Bool
    let isLast: Bool
    let cornerRadius: CGFloat

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                RoundedCorner(radius: cornerRadius, corners: corners)
                    .fill(Color.primary.opacity(configuration.isPressed ? 0.06 : 0))
            )
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }

    private var corners: UIRectCorner {
        switch (isFirst, isLast) {
        case (true, true):
            return [.allCorners]
        case (true, false):
            return [.topLeft, .topRight]
        case (false, true):
            return [.bottomLeft, .bottomRight]
        default:
            return []
        }
    }
}

private struct RoundedCorner: Shape {
    let radius: CGFloat
    let corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

@ViewBuilder
func groupedActionRow(_ items: [GroupedActionRowItem]) -> some View {
    GroupedSettingsActionRow(items: items)
}

#Preview {
    VStack(spacing: AppTheme.Spacing.lg) {
        groupedActionRow([
            GroupedActionRowItem(
                icon: "wand.and.stars",
                title: "Weekly driving report",
                subtitle: "Your habits, highlights, and improvements",
                destination: AnyView(SettingsSupportView())
            )
        ])

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
                action: { print("Compare") }
            )
        ])

        groupedActionRow([
            GroupedActionRowItem(
                icon: "car.fill",
                title: "Drive Summary",
                subtitle: "A longer subtitle that should wrap onto a second line for dynamic type support",
                destination: AnyView(SettingsSupportView())
            ),
            GroupedActionRowItem(
                icon: "speedometer",
                title: "Speed Consistency",
                subtitle: "Monitoring highway and city patterns",
                action: { print("Speed") }
            ),
            GroupedActionRowItem(
                icon: "shield.lefthalf.filled",
                title: "Safety Checks",
                subtitle: "Everything running smoothly",
                destination: AnyView(SettingsSupportView())
            )
        ])
    }
    .padding(.vertical, AppTheme.Spacing.lg)
    .background(AppTheme.Colors.background)
}
