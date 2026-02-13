//
//  CarBrand.swift
//  Ocula
//
//  Created by Tyson Miles on 7/2/2026.
//

import Foundation

enum CarBrand: String, CaseIterable, Identifiable {
    case acura = "Acura"
    case alfaRomeo = "Alfa Romeo"
    case astonMartin = "Aston Martin"
    case audi = "Audi"
    case bentley = "Bentley"
    case bmw = "BMW"
    case buick = "Buick"
    case cadillac = "Cadillac"
    case chevrolet = "Chevrolet"
    case chrysler = "Chrysler"
    case dodge = "Dodge"
    case fiat = "Fiat"
    case ford = "Ford"
    case genesis = "Genesis"
    case gmc = "GMC"
    case honda = "Honda"
    case hyundai = "Hyundai"
    case infiniti = "Infiniti"
    case jaguar = "Jaguar"
    case jeep = "Jeep"
    case kia = "Kia"
    case landRover = "Land Rover"
    case lexus = "Lexus"
    case lincoln = "Lincoln"
    case maserati = "Maserati"
    case mazda = "Mazda"
    case mercedes = "Mercedes-Benz"
    case mini = "MINI"
    case mitsubishi = "Mitsubishi"
    case nissan = "Nissan"
    case porsche = "Porsche"
    case ram = "RAM"
    case rollsRoyce = "Rolls-Royce"
    case subaru = "Subaru"
    case tesla = "Tesla"
    case toyota = "Toyota"
    case volvo = "Volvo"
    case volkswagen = "Volkswagen"
    case other = "Other"

    var id: String { rawValue }
}
