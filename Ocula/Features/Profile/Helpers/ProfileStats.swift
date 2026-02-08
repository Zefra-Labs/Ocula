//
//  ProfileStats.swift
//  Ocula
//
//  Created by Tyson Miles on 7/2/2026.
//

import Foundation

struct ProfileStats: Codable {
    let driverScore: Int
    let tripsTaken: Int
    let kmsDriven: Int
    let uniqueRoutes: Int
    let topPercent: Int
    let region: String
    let weeklyMovement: String
    let friendsBeaten: Int
    let totalHoursDriven: Int
    let breakdown: [DrivingMetricData]
    let achievements: [AchievementData]
    let lastUpdated: Date?

    static func placeholder() -> ProfileStats {
        ProfileStats(
            driverScore: 60,
            tripsTaken: 246,
            kmsDriven: 88,
            uniqueRoutes: 444,
            topPercent: 38,
            region: "Australia",
            weeklyMovement: "Up 214 places this week",
            friendsBeaten: 3,
            totalHoursDriven: 128,
            breakdown: [
                DrivingMetricData(title: "Smooth Braking", score: 72, insight: "Hard stops dropped 3 points", systemIcon: "hand.raised.fill"),
                DrivingMetricData(title: "Acceleration", score: 68, insight: "Ease into starts for +5", systemIcon: "bolt.fill"),
                DrivingMetricData(title: "Cornering", score: 54, insight: "Sharp turns reduced control", systemIcon: "arrow.triangle.turn.up.right.diamond.fill"),
                DrivingMetricData(title: "Speed Consistency", score: 81, insight: "Highway control is strong", systemIcon: "speedometer"),
                DrivingMetricData(title: "Phone Handling", score: 92, insight: "Great focus while driving", systemIcon: "iphone.gen3")
            ],
            achievements: [
                AchievementData(title: "100 Trips Club", subtitle: "Hit 100 recorded trips", progress: 1.0, isUnlocked: true, systemIcon: "trophy.fill"),
                AchievementData(title: "7 Days Without Hard Braking", subtitle: "Stay smooth for 7 days", progress: 0.72, isUnlocked: false, systemIcon: "calendar.badge.checkmark"),
                AchievementData(title: "Night Driver", subtitle: "10 safe night trips", progress: 0.4, isUnlocked: false, systemIcon: "moon.stars.fill"),
                AchievementData(title: "Smooth Operator", subtitle: "Average score above 85", progress: 0.6, isUnlocked: false, systemIcon: "sparkles")
            ],
            lastUpdated: nil
        )
    }
}
