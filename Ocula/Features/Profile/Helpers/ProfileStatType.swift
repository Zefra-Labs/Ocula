//
//  ProfileStatType.swift
//  Ocula
//
//  Created by Tyson Miles on 7/2/2026.
//

import Foundation

enum ProfileStatType: String {
    case trips
    case routes
    case distance

    var title: String {
        switch self {
        case .trips: return "Trips"
        case .routes: return "Routes"
        case .distance: return "Distance"
        }
    }

    var subtitle: String {
        switch self {
        case .trips: return "Total recorded trips"
        case .routes: return "Unique routes driven"
        case .distance: return "Total distance covered"
        }
    }
}
