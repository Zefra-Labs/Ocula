//
//  ProfileViewModel.swift
//  Ocula
//
//  Created by Tyson Miles on 7/2/2026.
//

import Foundation
import Combine

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var stats: ProfileStats = ProfileStats.placeholder()
    @Published var isLoading = false
    @Published var errorMessage: String? = nil

    func loadStats(range: ProfileTimeRange) {
        isLoading = true
        errorMessage = nil

        let trips = Trip.mockTrips()
        stats = ProfileStatsBuilder.buildStats(from: trips, range: range)
        isLoading = false
    }
}
