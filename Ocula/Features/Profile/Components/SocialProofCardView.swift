//
//  SocialProofCardView.swift
//  Ocula
//
//  Created by Tyson Miles on 7/2/2026.
//

import SwiftUI

struct SocialProofCardView: View {
    let topPercent: Int
    let region: String
    let weeklyMovement: String
    let friendsBeaten: Int
    var onTap: (() -> Void)? = nil
    var isInteractive: Bool = true

    @State private var isPressed = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Your Standing")
                    .headlineBoldStyle()

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.footnote.weight(.semibold))
                    .foregroundColor(AppTheme.Colors.secondary)
            }

            Text("Top \(topPercent)% in \(region)")
                .font(AppTheme.Fonts.bold(20))
                .foregroundColor(AppTheme.Colors.primary)

            HStack(spacing: 8) {
                SocialProofPillView(text: weeklyMovement, icon: "arrow.up.right")
                SocialProofPillView(text: "You beat \(friendsBeaten) friends", icon: "person.2.fill")
            }
        }
        .padding(AppTheme.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.Radius.xlg)
                .fill(AppTheme.Colors.primary.opacity(0.08))
        )
        .scaleEffect(isPressed ? 0.98 : 1)
        .animation(.spring(response: 0.25, dampingFraction: 0.7), value: isPressed)
        .if(isInteractive) { view in
            view.onTapGesture {
                isPressed = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
                    isPressed = false
                }
                onTap?()
            }
        }
    }
}
