//
//  ProfileHeaderCardView.swift
//  Ocula
//
//  Created by Tyson Miles on 7/2/2026.
//

import SwiftUI

struct ProfileHeaderCardView: View {
    let displayName: String
    let nickname: String
    let vehicleNickname: String
    let vehicleBrand: String
    let vehicleColorHex: String
    let memberSince: String
    let totalHours: String
    let imageURL: String?

    var body: some View {
        HStack(alignment: .top, spacing: AppTheme.Spacing.md) {
            ProfileAvatarView(imageURL: imageURL, size: 56)

            VStack(alignment: .leading, spacing: 6) {
                Text(displayName)
                    .font(AppTheme.Fonts.bold(20))
                    .foregroundColor(AppTheme.Colors.primary)

                Text(nickname)
                    .font(AppTheme.Fonts.medium(13))
                    .foregroundColor(AppTheme.Colors.secondary)

                HStack(spacing: 8) {
                    Circle()
                        .fill(Color(hex: vehicleColorHex) ?? AppTheme.Colors.secondary)
                        .frame(width: 8, height: 8)

                    Image(systemName: "car.fill")
                        .font(.caption)

                    Text("\(vehicleBrand) \(vehicleNickname) • \(memberSince)")
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)
                        .layoutPriority(1)
                }
                .font(AppTheme.Fonts.medium(11))
                .foregroundColor(AppTheme.Colors.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text(totalHours)
                    .font(AppTheme.Fonts.bold(18))
                    .foregroundColor(AppTheme.Colors.primary)

                Text("Total hours")
                    .font(AppTheme.Fonts.medium(11))
                    .foregroundColor(AppTheme.Colors.secondary)
            }
        }
        .padding(AppTheme.Spacing.md)
        .glassEffect(in: RoundedRectangle(cornerRadius: AppTheme.Radius.xlg))
    }
}
