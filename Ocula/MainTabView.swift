//
//  MainTabView.swift
//  Ocula
//
//  Created by Tyson Miles on 26/1/2026.
//

import SwiftUI
import UIKit

struct MainTabView: View {
    init() {
        UITabBar.appearance().unselectedItemTintColor = UIColor.secondary
        UITabBar.appearance().tintColor = UIColor.primary
    }

    var body: some View {
        TabView {
            HomeView()
                .tabItem { Image(systemName: "car.fill") }

            ClipsView()
                .tabItem { Image(systemName: "folder.fill") }

            TripsView()
                .tabItem { Image(systemName: "point.topleft.filled.down.to.point.bottomright.curvepath") }

            ProfileView()
                .tabItem { Image(systemName: "person.fill") }
        }
    }
}
#Preview ("Ocula App (PREVIEW ONLY)"){
    MainTabView()
}
