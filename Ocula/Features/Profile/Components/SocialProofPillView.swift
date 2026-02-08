//
//  SocialProofPillView.swift
//  Ocula
//
//  Created by Tyson Miles on 7/2/2026.
//

import SwiftUI

struct SocialProofPillView: View {
    let text: String
    let icon: String

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(AppTheme.Colors.secondary)

            Text(text)
                .font(AppTheme.Fonts.medium(11))
                .foregroundColor(AppTheme.Colors.secondary)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(AppTheme.Colors.surfaceDark.opacity(0.5))
        )
    }
}
