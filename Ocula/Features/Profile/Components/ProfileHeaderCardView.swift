//
//  ProfileHeaderCardView.swift
//  Ocula
//
//  Created by Tyson Miles on 7/2/2026.
//

import SwiftUI

struct ProfileHeaderCardView: View {
    let driverNickname: String
    let email: String
    let totalHours: String
    let imageURL: String?

    var body: some View {
        HStack(alignment: .center, spacing: AppTheme.Spacing.md) {
            ProfileAvatarView(imageURL: imageURL, size: 56)

            VStack(alignment: .leading, spacing: 6) {
                Text(driverNickname)
                    .font(AppTheme.Fonts.bold(20))
                    .lineLimit(1)
                    .foregroundColor(AppTheme.Colors.primary)

                Text(email)
                    .font(AppTheme.Fonts.medium(13))
                    .lineLimit(1)
                    .foregroundColor(AppTheme.Colors.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text(totalHours)
                    .font(AppTheme.Fonts.bold(18))
                    .lineLimit(1)
                    .foregroundColor(AppTheme.Colors.primary)

                Text("Total hours")
                    .font(AppTheme.Fonts.medium(11))
                    .foregroundColor(AppTheme.Colors.secondary)
            }
        }
        .padding(AppTheme.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.Radius.xlg)
                .fill(AppTheme.Colors.primary.opacity(0.08))
        )
    }
}
