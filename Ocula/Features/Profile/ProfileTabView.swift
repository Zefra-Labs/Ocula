//
//  ProfileTabView.swift
//  Ocula
//
//  Created by Tyson Miles on 26/1/2026.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct ProfileView: View {

    // MARK: - State
    @State private var userName: String = "Anonymous29211"
    @State private var userImageURL: String?

    @State private var tripsTaken = 246
    @State private var kmsDriven = 88
    @State private var uniqueRoutes = 444
    @State private var safetyScore = 60

    private let db = Firestore.firestore()

    // MARK: - Actions (Injectable)
    var onSafetyScoreTapped: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: AppTheme.Spacing.lg) {

            profileNavBar

            scrollViewSection
            
            HStack(alignment: .center, spacing: AppTheme.Spacing.sm) {
                Text("Your Stats")
                    .font(.headline)
                    .foregroundColor(AppTheme.Colors.secondary)
                    .frame(minWidth: 0, alignment: .leading)
                Rectangle()
                    .fill(AppTheme.Colors.secondary)
                    .frame(height: 1.5)
                    .clipShape(.capsule)
                    .frame(maxWidth: .infinity)
            }

            Spacer(minLength: AppTheme.Spacing.xl) // Reserved space for future sections
        }
        .padding(AppTheme.Spacing.lg)
        .background(AppTheme.Colors.background)
        //.onAppear(perform: loadUserData)
    }
}
private extension ProfileView {

    var scrollViewSection: some View {
        ScrollView {
            driveStats
                .padding(.bottom, AppTheme.Spacing.sm)
            VStack(spacing: 12) {
                actionRow(
                    icon: safetyIcon(for: safetyScore),
                    iconColor: safetyColor(for: safetyScore),
                    title: "Driver Scoreᴮᴱᵀᴬ",
                    subtitle: safetySubtitle(for: safetyScore),
                    trailingValue: "\(safetyScore)",
                    action: {
                        print("Safety Score tapped")
                    }
                )
                actionRow(
                    icon: "rosette",
                    iconColor: .yellow,
                    title: "Leaderboard",
                    subtitle: "Country Ranking",
                    trailingValue: "32,312th",
                    action: {
                        print("Safety Score tapped")
                    }
                )

                Spacer(minLength: 80)
                
            }
        }
    }
}

private extension ProfileView {

    var profileNavBar: some View {
        HStack {
            HStack(spacing: AppTheme.Spacing.sm) {

                ProfileAvatarView(imageURL: userImageURL)

                Text(userName)
                    .headlineStyle()
                    .fontWeight(.bold)
            }

            Spacer()

            Button {
                print("Settings tapped")
            } label: {
                Image(systemName: "gearshape.fill")
                    .foregroundColor(AppTheme.Colors.primary)
                    .font(.title2)
            }
            
        }
        
    }
}
private extension ProfileView {

    var driveStats: some View {
        ZStack {
            RadialGradient(
                colors: [
                    Color.blue.opacity(0.25),
                    Color.clear
                ],
                center: .center,
                startRadius: 20,
                endRadius: 200
            )
            .frame(width: 300, height: 300)
            .blur(radius: 50)
            HStack(spacing: -40) {

                StatCircleView(
                    number: uniqueRoutes,
                    title: "Routes",
                    icon: "map.fill",
                    size: 120,
                    isPrimary: false
                )

                Spacer(minLength: 60)

                StatCircleView(
                    number: kmsDriven,
                    title: "Traveled",
                    icon: "speedometer",
                    size: 120,
                    isPrimary: false
                )
            }

            StatCircleView(
                number: tripsTaken,
                title: "Trips",
                icon: "car.fill",
                size: 150,
                isPrimary: true
            )
        }
        .padding(.top, AppTheme.Spacing.sm)
    }
}
struct StatCircleView: View {

    let number: Int
    let title: String
    let icon: String
    let size: CGFloat
    let isPrimary: Bool

    @State private var isPressed = false
    @State private var animatedValue: Double = 0

    // MARK: - Scaling
    private var scale: CGFloat {
        isPrimary ? 0.90 : 0.80
    }

    var body: some View {
        VStack(spacing: AppTheme.Spacing.xs) {

            Image(systemName: icon)
                .foregroundColor(.white)
                .font(.system(size: size * 0.18 * scale))

            // Animated number
            Text("")
                .modifier(CountingText(value: animatedValue))
                .foregroundColor(.white)
                .font(.system(
                    size: size * 0.36 * scale,
                    weight: .bold
                ))

            Text(title)
                .foregroundColor(AppTheme.Colors.primary)
                .font(.system(
                    size: size * 0.14 * scale,
                    weight: isPrimary ? .bold : .semibold
                ))
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .frame(width: size, height: size)
        .background(
            Circle()
                .fill(
                    isPrimary
                    ? AppTheme.Colors.accent.opacity(0.75)
                    : AppTheme.Colors.surfaceDark
                )
        )
        .scaleEffect(isPressed ? 0.96 : 1)
        .animation(.spring(response: 0.25, dampingFraction: 0.7), value: isPressed)
        .onTapGesture {
            isPressed = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
                isPressed = false
            }
        }
        .onAppear {
            animatedValue = 0
            withAnimation(.easeOut(duration: isPrimary ? 0.9 : 0.6)) {
                animatedValue = Double(number)
            }
        }
    }
}

struct CountingText: AnimatableModifier {
    var value: Double

    var animatableData: Double {
        get { value }
        set { value = newValue }
    }

    func body(content: Content) -> some View {
        Text("\(Int(value))")
    }
}
private func safetyIcon(for score: Int) -> String {
    if score < 50 {
        return "gauge.with.dots.needle.0percent"
    } else if score <= 80 {
        return score < 65
            ? "gauge.with.dots.needle.50percent"
            : "gauge.with.dots.needle.67percent"
    } else {
        return "gauge.with.dots.needle.100percent"
    }
}
private func safetySubtitle(for score: Int) -> String {
    if score < 20 {
        return "Needs a loooooot of work"
    } else if score <= 60 {
        return score < 40
            ? "Needs some more work"
            : "Needs a bit more work"
    } else if score <= 80 {
        return score < 65
            ? "Needs just a little work"
            : "Almost there!"
    } else if score <= 99 {
        return score < 95
            ? "Keep up the great work!"
            : "So Close! Keep going!"
    }
    else if score >= 100 {
        return "Amazing work!"
    }
    else {
        return "Keep up the great work!"
    }
}
private func safetyColor(for score: Int) -> Color {
    if score < 50 { return .red }
    if score <= 80 { return .yellow }
    return .green
}
struct ProfileAvatarView: View {

    let imageURL: String?

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
        .frame(width: 40, height: 40)
        .clipShape(Circle())
    }

    private var placeholder: some View {
        Circle()
            .fill(AppTheme.Colors.surfaceDark)
    }
}


#Preview {
    ProfileView()
    
}
