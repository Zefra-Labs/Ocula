//
//  AchievementData.swift
//  Ocula
//
//  Created by Tyson Miles on 7/2/2026.
//

import Foundation

struct AchievementData: Codable {
    let title: String
    let subtitle: String
    let progress: Double
    let isUnlocked: Bool
    let systemIcon: String
}
