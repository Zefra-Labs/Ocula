//
//  ProfileTabView.swift
//  Ocula
//
//  Created by Tyson Miles on 26/1/2026.
//

import SwiftUI
import FirebaseAuth
import UIKit

struct ProfileView: View {

    // MARK: - State
    @EnvironmentObject var session: SessionManager

    @StateObject private var viewModel = ProfileViewModel()
    @State private var selectedRange: ProfileTimeRange = .last7Days
    @State private var breakdownSheetMetric: DrivingMetric? = nil
    @State private var achievementSheetItem: Achievement? = nil
    @State private var showAllAchievementsSheet = false

    // MARK: - Actions (Injectable)
    var onSafetyScoreTapped: (() -> Void)? = nil

    var body: some View {
        NavigationStack {
            VStack(spacing: AppTheme.Spacing.lg) {

                ProfileNavBar()

                ScrollView {
                    VStack(spacing: AppTheme.Spacing.lg) {
                        profileHeaderCard

                        Divider()
                            .overlay(AppTheme.Colors.surfaceDark.opacity(0.55))


                        driverScoreSection
                        
                        timeRangeSection

                        insightSection

                        statsSection

                        socialProofSection

                        breakdownSection

                        achievementsSection
                    }
                    .padding(.bottom, AppTheme.Spacing.xl)
                    .padding(.top, AppTheme.Spacing.sm)
                }
            }
            .padding(.horizontal, AppTheme.Spacing.md)
            .padding(.bottom, AppTheme.Spacing.sm)
            .background(AppTheme.Colors.background)
        }
        .toolbar(.hidden, for: .navigationBar)
        .sheet(item: $breakdownSheetMetric) { metric in
            sheetContent(BreakdownInsightsSheet(metric: metric))
        }
        .sheet(item: $achievementSheetItem) { achievement in
            sheetContent(AchievementInsightsSheet(achievement: achievement))
        }
        .sheet(isPresented: $showAllAchievementsSheet) {
            sheetContent(AchievementAllSheet(achievements: achievements))
        }
        .onAppear(perform: loadProfileStats)
        .onChange(of: session.user?.id) { _ in
            loadProfileStats()
        }
        .onChange(of: selectedRange) { _ in
            loadProfileStats()
        }
    }
}

private extension ProfileView {
    var profileHeaderCard: some View {
        ProfileHeaderCardView(
            driverNickname: driverNickname,
            email: userEmail,
            totalHours: "\(viewModel.stats.totalHoursDriven)h",
            imageURL: userImageURL
        )
    }

    var timeRangeSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            Text("Time Range")
                .headlineStyle()

            TimeRangePickerView(selection: $selectedRange)
                .padding(.horizontal, AppTheme.Spacing.sm)
        }
    }

    var driverScoreSection: some View {
        NavigationLink {
            DriverScoreDetailView(
                score: viewModel.stats.driverScore,
                timeRange: selectedRange,
                breakdown: drivingMetrics
            )
        } label: {
            DriverScoreHeroView(
                score: viewModel.stats.driverScore,
                insightText: SafetyScoreStyle.subtitle(for: viewModel.stats.driverScore),
                comparisonText: SafetyScoreStyle.comparison(for: viewModel.stats.driverScore),
                timeRangeLabel: selectedRange.description,
                onTap: onSafetyScoreTapped,
                isInteractive: false
            )
        }
        .buttonStyle(.plain)
    }

    var insightSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            Text("Insights")
                .headlineStyle()

            actionRow(
                icon: "wand.and.stars",
                iconColor: .yellow,
                title: "Weekly driving report",
                subtitle: "Your habits, highlights, and improvements",
                trailingValue: nil,
                action: { print("Weekly report") }
            )

            actionRow(
                icon: "chart.line.uptrend.xyaxis",
                iconColor: .green,
                title: "Compare time periods",
                subtitle: "See how your score changed",
                trailingValue: nil,
                action: { print("Compare periods") }
            )

            profileActionRow(
                icon: "flame.fill",
                iconColor: .orange,
                title: "Current streak",
                subtitle: "6 days without hard braking",
                trailingValue: nil,
                action: nil
            )
        }
    }

    var statsSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            Text("Your Stats")
                .headlineStyle()

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: AppTheme.Spacing.sm) {
                NavigationLink {
                    StatDetailView(type: .trips, stats: viewModel.stats, timeRange: selectedRange)
                } label: {
                    StatChipView(
                        title: "Trips Taken",
                        value: "\(viewModel.stats.tripsTaken)",
                        icon: "car.fill",
                        isInteractive: false
                    )
                }
                .buttonStyle(.plain)

                NavigationLink {
                    StatDetailView(type: .routes, stats: viewModel.stats, timeRange: selectedRange)
                } label: {
                    StatChipView(
                        title: "Unique Routes",
                        value: "\(viewModel.stats.uniqueRoutes)",
                        icon: "map.fill",
                        isInteractive: false
                    )
                }
                .buttonStyle(.plain)

                NavigationLink {
                    StatDetailView(type: .distance, stats: viewModel.stats, timeRange: selectedRange)
                } label: {
                    StatChipView(
                        title: "Distance Traveled",
                        value: "\(viewModel.stats.kmsDriven) km",
                        icon: "speedometer",
                        isInteractive: false
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }

    var socialProofSection: some View {
        NavigationLink {
            LeaderboardView(stats: viewModel.stats)
        } label: {
            SocialProofCardView(
                topPercent: viewModel.stats.topPercent,
                region: viewModel.stats.region,
                weeklyMovement: viewModel.stats.weeklyMovement,
                friendsBeaten: viewModel.stats.friendsBeaten,
                onTap: { print("Leaderboard tapped") },
                isInteractive: false
            )
        }
        .buttonStyle(.plain)
    }

    var breakdownSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            HStack() {
                Text("Driving Breakdown")
                    .headlineStyle()
                Spacer()
                // ADD HERE
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppTheme.Spacing.sm) {
                    ForEach(drivingMetrics) { metric in
                        BreakdownCardView(
                            metric: metric,
                            onCompareInsights: {
                                breakdownSheetMetric = metric
                            },
                            onShare: {
                                UIPasteboard.general.string = "\(metric.title): \(metric.score)"
                            }
                        )
                    }
                }
                .padding(.horizontal, 2)
            }
        }
    }

    var achievementsSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            HStack {
                Text("Achievements")
                    .headlineStyle()

                Spacer()

                Button("View all") {
                    showAllAchievementsSheet = true
                }
                .font(AppTheme.Fonts.medium(12))
                .foregroundColor(AppTheme.Colors.secondary)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppTheme.Spacing.sm) {
                    ForEach(achievements) { achievement in
                        AchievementCardView(
                            achievement: achievement,
                            onViewInsights: {
                                achievementSheetItem = achievement
                            },
                            onShare: {
                                UIPasteboard.general.string = "\(achievement.title) — \(achievement.subtitle)"
                            }
                        )
                    }
                }
                .padding(.horizontal, 2)
            }
        }
    }
}

private extension ProfileView {
    var userDisplayName: String {
        session.user?.displayName
        ?? Auth.auth().currentUser?.displayName
        ?? "Anonymous"
    }

    var userImageURL: String? {
        Auth.auth().currentUser?.photoURL?.absoluteString
    }

    var userEmail: String {
        session.user?.email
        ?? Auth.auth().currentUser?.email
        ?? "hello@ocula.app"
    }
}

private extension ProfileView {
    var drivingMetrics: [DrivingMetric] {
        viewModel.stats.breakdown.map { metric in
            DrivingMetric(
                title: metric.title,
                score: metric.score,
                insight: metric.insight,
                systemIcon: metric.systemIcon
            )
        }
    }

    var achievements: [Achievement] {
        viewModel.stats.achievements.map { achievement in
            Achievement(
                title: achievement.title,
                subtitle: achievement.subtitle,
                progress: achievement.progress,
                isUnlocked: achievement.isUnlocked,
                systemIcon: achievement.systemIcon
            )
        }
    }

}

private extension ProfileView {
    var driverNickname: String {
        session.user?.driverNickname ?? "Ocula Driver"
    }

    func loadProfileStats() {
        viewModel.loadStats(range: selectedRange)
    }

    @ViewBuilder
    func sheetContent<Content: View>(_ content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        } else {
            content
        }
    }
}

#if DEBUG
#Preview {
    ProfileView()
        .environmentObject(SessionManager())
}
#endif
