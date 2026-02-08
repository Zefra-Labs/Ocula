//
//  ProfileTimeRange.swift
//  Ocula
//
//  Created by Tyson Miles on 7/2/2026.
//

import Foundation

enum ProfileTimeRange: String, CaseIterable, Identifiable {
    case today = "Today"
    case last7Days = "Last 7 days"
    case last30Days = "Last 30 days"
    case lifetime = "Lifetime"

    var id: String { rawValue }

    var shortLabel: String {
        switch self {
        case .today: return "Today"
        case .last7Days: return "7 days"
        case .last30Days: return "30 days"
        case .lifetime: return "All"
        }
    }

    var description: String {
        rawValue
    }

    var documentID: String {
        switch self {
        case .today: return "today"
        case .last7Days: return "last7Days"
        case .last30Days: return "last30Days"
        case .lifetime: return "lifetime"
        }
    }
}
