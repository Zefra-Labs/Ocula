//
//  ProfileAvatarView.swift
//  Ocula
//
//  Created by Tyson Miles on 4/2/2026.
//

import SwiftUI

struct ProfileAvatarView: View {

    let imageURL: String?
    var size: CGFloat = 40

    var body: some View {
        Group {
            if let imageURL,
               let url = URL(string: imageURL) {
                AsyncImage(url: url) { image in
                    image.resizable()
                } placeholder: {
                    placeholder
                }
            } else {
                placeholder
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
    }

    private var placeholder: some View {
        Circle()
            .fill(AppTheme.Colors.surfaceDark)
    }
}
