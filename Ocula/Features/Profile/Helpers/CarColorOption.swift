//
//  CarColorOption.swift
//  Ocula
//
//  Created by Tyson Miles on 7/2/2026.
//

import Foundation

struct CarColorOption: Identifiable {
    let id = UUID()
    let name: String
    let hex: String

    static let standard: [CarColorOption] = [
        CarColorOption(name: "Midnight", hex: "0F172A"),
        CarColorOption(name: "Pearl", hex: "F8FAFC"),
        CarColorOption(name: "Graphite", hex: "374151"),
        CarColorOption(name: "Ocean", hex: "2563EB"),
        CarColorOption(name: "Forest", hex: "166534"),
        CarColorOption(name: "Crimson", hex: "B91C1C"),
        CarColorOption(name: "Sand", hex: "D97706")
    ]
}
