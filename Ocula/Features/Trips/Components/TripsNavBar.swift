//
//  ProfileNavBar.swift
//  Ocula
//
//  Created by Tyson Miles on 7/2/2026.
//

import SwiftUI

struct TripsNavBar: View {
    var body: some View {
        HStack {
            Text("Trips")
                .titleStyle()

            Spacer()
            
            NavigationLink {
                Text("TripsChanger")
            } label: {
                Image(systemName: "ellipsis.circle")
                    .foregroundColor(AppTheme.Colors.primary)
                    .font(.title2)
            }
        }
        .padding(.top, AppTheme.Spacing.xl)
        .padding(.bottom, AppTheme.Spacing.sm)
    }
}
