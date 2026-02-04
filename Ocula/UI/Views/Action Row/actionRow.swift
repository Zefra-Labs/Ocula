//
//  actionRow.swift
//  Ocula
//
//  Created by Tyson Miles on 28/1/2026.
//

import SwiftUI

@ViewBuilder
func actionRow(
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
                .font(.system(size: 25, weight: .bold))
                .foregroundColor(.white)
        }
        
        Image(systemName: "chevron.right")
            .font(.footnote.weight(.semibold))
            .foregroundColor(AppTheme.Colors.secondary)
    }
        .padding(AppTheme.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.Radius.xlg)
                .fill(AppTheme.Colors.primary.opacity(0.1))
        )
        .contentShape(Rectangle())
    
    if let destination {
        NavigationLink { destination } label: { rowContent }
            .buttonStyle(PressableRowStyle())
    } else {
        Button(action: { action?() }) {
            rowContent
        }
        .buttonStyle(PressableRowStyle())
    }
}
struct PressableRowStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.94 : 1.0)
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.Radius.lg)
                    .fill(Color.white.opacity(configuration.isPressed ? 0.08 : 0))
            )
            .animation(.easeOut(duration: 0.25), value: configuration.isPressed)
    }
}

