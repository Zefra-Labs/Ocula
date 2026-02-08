//
//  ProfileNavBar.swift
//  Ocula
//
//  Created by Tyson Miles on 7/2/2026.
//

import SwiftUI

struct ProfileNavBar: View {
    var body: some View {
        HStack {
            Text("Profile")
                .titleStyle()

            Spacer()
            
            NavigationLink {
                SettingsView()
            } label: {
                Image(systemName: "gearshape.fill")
                    .foregroundColor(AppTheme.Colors.primary)
                    .font(.title2)
            }
        }
        .padding(.top, AppTheme.Spacing.xl)
        .padding(.bottom, AppTheme.Spacing.sm)
    }
}
