//
//  CarBrand.swift
//  Ocula
//
//  Created by Tyson Miles on 7/2/2026.
//

import Foundation

enum CarBrand: String, CaseIterable, Identifiable {
    case audi = "Audi"
    case bmw = "BMW"
    case chevrolet = "Chevrolet"
    case ford = "Ford"
    case honda = "Honda"
    case hyundai = "Hyundai"
    case kia = "Kia"
    case mercedes = "Mercedes-Benz"
    case nissan = "Nissan"
    case subaru = "Subaru"
    case tesla = "Tesla"
    case toyota = "Toyota"
    case volkswagen = "Volkswagen"

    var id: String { rawValue }
}
