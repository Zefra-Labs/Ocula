//
//  SafetyScoreStyle.swift
//  Ocula
//
//  Created by Tyson Miles on 4/2/2026.
//

import SwiftUI

enum SafetyScoreStyle {
    static func icon(for score: Int) -> String {
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

    static func subtitle(for score: Int) -> String {
        if score < 50 {
            return "Hard braking is hurting your score"
        } else if score < 70 {
            return "Improve cornering to gain +8 points"
        } else if score < 85 {
            return "You're smoother than 62% of drivers"
        } else {
            return "Elite control. Keep it up."
        }
    }

    static func comparison(for score: Int) -> String {
        if score < 50 {
            return "You're smoother than 22% of drivers"
        } else if score < 70 {
            return "You're smoother than 41% of drivers"
        } else if score < 85 {
            return "You're smoother than 62% of drivers"
        } else {
            return "Top 12% in your region"
        }
    }

    static func color(for score: Int) -> Color {
        if score < 50 { return .red }
        if score < 70 { return .yellow }
        if score < 85 { return .blue }
        return .green
    }
}
