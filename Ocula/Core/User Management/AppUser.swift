//
//  AppUser.swift
//  Ocula
//
//  Created by Tyson Miles on 1/2/2026.
//

import Foundation

struct AppUser: Identifiable, Codable {
    let id: String
    let email: String
    let displayName: String
    let createdAt: Date
    let lastLogin: Date
    let accountType: String
    let onboardingComplete: Bool
    let driverNickname: String?
    let vehicleNickname: String?
    let vehicleBrand: String?
    let vehicleColorHex: String?
}
