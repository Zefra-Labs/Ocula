//
//  ProfileActionRow.swift
//  Ocula
//
//  Created by Tyson Miles on 7/2/2026.
//

import SwiftUI

@ViewBuilder
func profileActionRow(
    icon: String,
    iconColor: Color? = nil,
    title: String,
    subtitle: String,
    trailingValue: String? = nil,
    destination: AnyView? = nil,
    action: (() -> Void)? = nil
) -> some View {

    let rowContent = HStack(spacing: 16) {
        Image(systemName: icon)
            .title2Style()
            .foregroundColor(iconColor ?? AppTheme.Colors.primary)
            .frame(width: 25)

        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .headlineStyle()
                .lineLimit(1)

            Text(subtitle)
                .captionStyle()
                .lineLimit(2)
        }

        Spacer()

        if let trailingValue {
            Text(trailingValue)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(AppTheme.Colors.primary)
        }
    }
        .padding(AppTheme.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.Radius.xlg)
                .fill(AppTheme.Colors.primary.opacity(0.08))
        )
        .contentShape(Rectangle())

    if let destination {
        NavigationLink { destination } label: { rowContent }
            .buttonStyle(PressableRowStyle())
    } else if action != nil {
        Button(action: { action?() }) {
            rowContent
        }
        .buttonStyle(PressableRowStyle())
    } else {
        rowContent
    }
}
