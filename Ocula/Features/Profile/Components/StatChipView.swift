//
//  StatChipView.swift
//  Ocula
//
//  Created by Tyson Miles on 7/2/2026.
//

import SwiftUI

struct StatChipView: View {
    let title: String
    let value: String
    let icon: String
    var onTap: (() -> Void)? = nil
    var onLongPress: (() -> Void)? = nil
    var isInteractive: Bool = true

    @State private var isPressed = false

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    Image(systemName: icon)
                        .foregroundColor(AppTheme.Colors.secondary)
                        .font(.subheadline)

                    Text(title)
                        .captionStyle()
                    
                }

                Text(value)
                    .font(AppTheme.Fonts.bold(20))
                    .foregroundColor(AppTheme.Colors.primary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(AppTheme.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.Radius.xlg)
                .fill(AppTheme.Colors.primary.opacity(0.08))
        )
        .scaleEffect(isPressed ? 0.97 : 1)
        .animation(.spring(response: 0.25, dampingFraction: 0.7), value: isPressed)
        .if(isInteractive) { view in
            view.onTapGesture {
                isPressed = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
                    isPressed = false
                }
                onTap?()
            }
            .onLongPressGesture(minimumDuration: 0.3) {
                onLongPress?()
            }
        }
    }
}
