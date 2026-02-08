//
//  ProfileStatsBuilder.swift
//  Ocula
//
//  Created by Tyson Miles on 7/2/2026.
//

import Foundation

enum ProfileStatsBuilder {
    static func buildStats(from trips: [Trip], range: ProfileTimeRange) -> ProfileStats {
        let filtered = filterTrips(trips, range: range)
        let tripsTaken = filtered.count
        let kmsDriven = Int(filtered.reduce(0) { $0 + $1.distanceKM }.rounded())
        let uniqueRoutes = Set(filtered.map { "\($0.startLocationName)-\($0.endLocationName)" }).count
        let totalMinutes = filtered.reduce(0) { $0 + $1.durationMinutes }
        let totalHoursDriven = Int(round(Double(totalMinutes) / 60.0))

        let avgBraking = average(filtered.map { $0.hardBraking })
        let avgAccel = average(filtered.map { $0.hardAcceleration })
        let avgCorner = average(filtered.map { $0.sharpTurns })

        let brakingScore = score(from: avgBraking, scale: 12)
        let accelScore = score(from: avgAccel, scale: 12)
        let cornerScore = score(from: avgCorner, scale: 12)

        let speedConsistency = speedConsistencyScore(from: filtered)
        let phoneHandling = filtered.isEmpty ? 0 : 90

        let driverScore = clamp(
            Int(round((Double(brakingScore + accelScore + cornerScore + speedConsistency + phoneHandling) / 5.0))),
            min: 0,
            max: 100
        )

        let breakdown: [DrivingMetricData] = [
            DrivingMetricData(title: "Smooth Braking", score: brakingScore, insight: insight(for: brakingScore, low: "Hard stops dropping points", high: "Braking is controlled"), systemIcon: "hand.raised.fill"),
            DrivingMetricData(title: "Acceleration", score: accelScore, insight: insight(for: accelScore, low: "Ease into starts", high: "Smooth launches"), systemIcon: "bolt.fill"),
            DrivingMetricData(title: "Cornering", score: cornerScore, insight: insight(for: cornerScore, low: "Sharp turns reduce control", high: "Corners are stable"), systemIcon: "arrow.triangle.turn.up.right.diamond.fill"),
            DrivingMetricData(title: "Speed Consistency", score: speedConsistency, insight: insight(for: speedConsistency, low: "Frequent speed swings", high: "Consistent pace"), systemIcon: "speedometer"),
            DrivingMetricData(title: "Phone Handling", score: phoneHandling, insight: insight(for: phoneHandling, low: "Reduce phone use", high: "Focused driving"), systemIcon: "iphone.gen3")
        ]

        let achievements = buildAchievements(from: trips, filteredTrips: filtered, driverScore: driverScore)
        let topPercent = percentile(for: driverScore)
        let weeklyMovement = movementText(for: trips, range: range, currentScore: driverScore)
        let friendsBeaten = max(0, (100 - topPercent) / 10)

        return ProfileStats(
            driverScore: driverScore,
            tripsTaken: tripsTaken,
            kmsDriven: kmsDriven,
            uniqueRoutes: uniqueRoutes,
            topPercent: topPercent,
            region: "Australia",
            weeklyMovement: weeklyMovement,
            friendsBeaten: friendsBeaten,
            totalHoursDriven: totalHoursDriven,
            breakdown: breakdown,
            achievements: achievements,
            lastUpdated: Date()
        )
    }

    private static func filterTrips(_ trips: [Trip], range: ProfileTimeRange) -> [Trip] {
        let now = Date()
        switch range {
        case .today:
            return trips.filter { Calendar.current.isDate($0.startDate, inSameDayAs: now) }
        case .last7Days:
            let start = Calendar.current.date(byAdding: .day, value: -7, to: now) ?? now
            return trips.filter { $0.startDate >= start }
        case .last30Days:
            let start = Calendar.current.date(byAdding: .day, value: -30, to: now) ?? now
            return trips.filter { $0.startDate >= start }
        case .lifetime:
            return trips
        }
    }

    private static func average(_ values: [Int]) -> Double {
        guard !values.isEmpty else { return 0 }
        return Double(values.reduce(0, +)) / Double(values.count)
    }

    private static func score(from averageEvents: Double, scale: Double) -> Int {
        let penalty = averageEvents * scale
        return clamp(Int(round(100 - penalty)), min: 0, max: 100)
    }

    private static func speedConsistencyScore(from trips: [Trip]) -> Int {
        guard !trips.isEmpty else { return 0 }
        let speeds = trips.map { $0.distanceKM / max(0.1, Double($0.durationMinutes) / 60.0) }
        let avg = speeds.reduce(0, +) / Double(speeds.count)
        let variance = speeds.reduce(0) { $0 + pow($1 - avg, 2) } / Double(speeds.count)
        let normalized = min(1.0, max(0.0, 1.0 - (variance / max(1.0, avg))))
        return clamp(Int(round(60 + (normalized * 40))), min: 0, max: 100)
    }

    private static func insight(for score: Int, low: String, high: String) -> String {
        score < 70 ? low : high
    }

    private static func percentile(for score: Int) -> Int {
        switch score {
        case 0..<50: return 72
        case 50..<70: return 59
        case 70..<85: return 38
        default: return 12
        }
    }

    private static func movementText(for trips: [Trip], range: ProfileTimeRange, currentScore: Int) -> String {
        let now = Date()
        let previousTrips: [Trip]
        switch range {
        case .today:
            let start = Calendar.current.date(byAdding: .day, value: -1, to: now) ?? now
            let end = Calendar.current.startOfDay(for: now)
            previousTrips = trips.filter { $0.startDate >= start && $0.startDate < end }
        case .last7Days:
            let start = Calendar.current.date(byAdding: .day, value: -14, to: now) ?? now
            let end = Calendar.current.date(byAdding: .day, value: -7, to: now) ?? now
            previousTrips = trips.filter { $0.startDate >= start && $0.startDate < end }
        case .last30Days:
            let start = Calendar.current.date(byAdding: .day, value: -60, to: now) ?? now
            let end = Calendar.current.date(byAdding: .day, value: -30, to: now) ?? now
            previousTrips = trips.filter { $0.startDate >= start && $0.startDate < end }
        case .lifetime:
            previousTrips = []
        }

        guard !previousTrips.isEmpty else {
            return "No prior data"
        }

        let previousScore = buildStats(from: previousTrips, range: .lifetime).driverScore
        let delta = currentScore - previousScore
        if delta > 0 {
            return "Up \(delta) points vs last period"
        } else if delta < 0 {
            return "Down \(abs(delta)) points vs last period"
        }
        return "No change vs last period"
    }

    private static func buildAchievements(from trips: [Trip], filteredTrips: [Trip], driverScore: Int) -> [AchievementData] {
        let totalTrips = trips.count
        let streakDays = uniqueDrivingDays(in: filteredTrips)

        return [
            AchievementData(
                title: "100 Trips Club",
                subtitle: "Hit 100 recorded trips",
                progress: min(1.0, Double(totalTrips) / 100.0),
                isUnlocked: totalTrips >= 100,
                systemIcon: "trophy.fill"
            ),
            AchievementData(
                title: "7 Days Without Hard Braking",
                subtitle: "Stay smooth for 7 days",
                progress: min(1.0, Double(streakDays) / 7.0),
                isUnlocked: streakDays >= 7,
                systemIcon: "calendar.badge.checkmark"
            ),
            AchievementData(
                title: "Night Driver",
                subtitle: "10 safe night trips",
                progress: min(1.0, Double(nightTrips(in: trips)) / 10.0),
                isUnlocked: nightTrips(in: trips) >= 10,
                systemIcon: "moon.stars.fill"
            ),
            AchievementData(
                title: "Smooth Operator",
                subtitle: "Average score above 85",
                progress: min(1.0, Double(driverScore) / 85.0),
                isUnlocked: driverScore >= 85,
                systemIcon: "sparkles"
            )
        ]
    }

    private static func uniqueDrivingDays(in trips: [Trip]) -> Int {
        let days = trips.map { Calendar.current.startOfDay(for: $0.startDate) }
        return Set(days).count
    }

    private static func nightTrips(in trips: [Trip]) -> Int {
        trips.filter { trip in
            let hour = Calendar.current.component(.hour, from: trip.startDate)
            return hour >= 20 || hour <= 5
        }.count
    }

    private static func clamp(_ value: Int, min: Int, max: Int) -> Int {
        Swift.max(min, Swift.min(max, value))
    }
}
