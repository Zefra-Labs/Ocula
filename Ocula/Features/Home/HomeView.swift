//
//  HomeView.swift
//  Ocula
//
//  Created by Tyson Miles on 23/1/2026.
//

import SwiftUI
import RealityKit


struct HomeView: View {

    // MARK: - State
    @EnvironmentObject var session: SessionManager
    @State private var show = false
    @State private var show2 = false
    @State private var animateIcon = true
    @State private var selectedDevice: String = "Ocula One"

    // MARK: - Body
    var body: some View {
        ZStack {
            AppTheme.Colors.background.ignoresSafeArea()

            VStack(spacing: 0) {

                // Top Nav Bar
                topNavBar

                // 3D Device Area
                deviceHeroView

                // Action Sections (Scrollable)
                actionsSection
                
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    HomeView()
}
private extension HomeView {

    var topNavBar: some View {
        HStack {
            Menu {
                Text("Your Devices")
                Divider()
                Button("Ocula One") { selectedDevice = "Ocula One" }
                Button("Ocula Mini") { selectedDevice = "Ocula Mini" }
                Divider()
                Button {
                    // add device action
                } label: {
                    Label {
                        Text("Add Device")
                    } icon: {
                        Image(systemName: "plus").foregroundColor(Color.primary)
                    }
                }
            } label: {
                HStack(spacing: 6) {
                    Text(selectedDevice)
                        .titleStyle()

                    Image(systemName: "chevron.down")
                        .bodyStyle()
                        .foregroundColor(AppTheme.Colors.secondary)
                }
            }

            Spacer()
        }
        .padding(.horizontal, AppTheme.Spacing.md)
        .padding(.top, AppTheme.Spacing.xl)
        .padding(.bottom, AppTheme.Spacing.sm)
    }
}
private extension HomeView {

    var deviceHeroView: some View {
        ZStack {

            // Glow
            RadialGradient(
                colors: [
                    Color.white.opacity(0.25),
                    Color.clear
                ],
                center: .center,
                startRadius: 20,
                endRadius: 200
            )
            .frame(width: 300, height: 300)
            .blur(radius: 50)

            // 3D Model
            RealityView { content in
                if let entity = try? await Entity(named: "OculaDevice") {
                    entity.scale = SIMD3(repeating: 0.6)
                    entity.position = [0, 0, 0]
                    content.add(entity)
                }
            }
            .frame(height: 260)
        }
        .padding(.top, 10)
        .padding(.bottom, 8)
    }
    
}
private extension HomeView {

    var actionsSection: some View {
        ScrollView {
            VStack(spacing: 12) {
                
                actionRow(
                    icon: "map.fill",
                    title: "Location & Status",
                    subtitle: "View current location and stats"
                )
                actionRow(
                    icon: "video.fill",
                    title: "Live View",
                    subtitle: "View cameras in real time"
                )
                
                actionRow(
                    icon: "folder.fill",
                    title: "Clips",
                    subtitle: "Browse saved footage for this device"
                )
                
                actionRow(
                    icon: "map.fill",
                    title: "Trips",
                    subtitle: "View past drives"
                )
                
                actionRow(
                    icon: "gearshape.fill",
                    title: "Device Settings",
                    subtitle: "Manage settings for this device"
                )
                actionRow(
                    icon: "gearshape.fill",
                    title: "Signout",
                    subtitle: "Manage settings for this device",
                    action: {
                        session.signOut()
                    }
                )
                actionRow(
                    icon: "gearshape.fill",
                    title: "Signout",
                    subtitle: "Manage settings for this device",
                    action: {
                        session.signOut()
                    }
                )
                Button("Show Alert Sheet") { show = true }
                    .oculaAlertSheet(
                        isPresented: $show,
                        icon: "exclamationmark.triangle.fill",
                        iconTint: .yellow,
                        title: "Unknown Error",
                        message: "Just a second, we're gathering some quick diagnostic info...",
                        showsIconRing: false,                 // remove outer circle
                        iconModifier: { image in               // base styling (optional)
                            AnyView(image.symbolRenderingMode(.hierarchical))
                        },
                        iconAnimator: { image, isActive in     // conditional animation
                            if #available(iOS 17.0, *) {
                                return AnyView(
                                    image
                                        .symbolEffect(.breathe)
                                )
                            } else {
                                return AnyView(image)
                            }
                        },
                        iconAnimationActive: animateIcon,      // condition
                        autoDismissAfter: 5,
                        onAutoDismiss: { show2 = true }
                    )
                    .oculaAlertSheet(
                        isPresented: $show2,
                        icon: "checkmark",
                        iconTint: .green,
                        title: "Success",
                        message: "Sent diagnostic feedback successfully",
                        showsIconRing: false,                 // remove outer circle
                        iconAnimationActive: animateIcon,      // condition
                        autoDismissAfter: 5,
                        onAutoDismiss: { print("Auto dismissed") }
                    )
                

                Spacer(minLength: 80)
            }
            .padding(.horizontal, AppTheme.Spacing.md)
            .padding(.top, AppTheme.Spacing.sm)
        }
    }
    
}

