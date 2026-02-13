//
//  SettingsCarView.swift
//  Ocula
//
//  Created by Tyson Miles on 7/2/2026.
//

import SwiftUI
import UIKit
import FirebaseAuth
import FirebaseFirestore

struct SettingsCarView: View {
    @EnvironmentObject var session: SessionManager

    @State private var driverNickname: String = ""
    @State private var vehicleNickname: String = ""
    @State private var vehiclePlate: String = ""
    @State private var selectedBrand: CarBrand = .bmw
    @State private var customBrand: String = ""
    @State private var vehicleColor: Color = Color(hex: "2563EB") ?? .blue
    @State private var isSaving = false
    @State private var saveMessage: String? = nil
    @State private var showSuccessSheet = false
    @State private var animateIcon = false

    var body: some View {
        
        SettingsScaffold(title: "Car") {
            SettingsList {
                Section(header: SettingsSectionHeader(title: "Driver Nickname")) {
                    TextField("Driver nickname", text: $driverNickname)
                }

                Section(header: SettingsSectionHeader(title: "Vehicle")) {
                    TextField("Vehicle nickname", text: $vehicleNickname)
                    
                    TextField("License plate", text: $vehiclePlate)

                    Picker("Car Brand", selection: $selectedBrand) {
                        ForEach(brandOptions) { brand in
                            Text(brand.rawValue).tag(brand)
                        }
                    }
                    .pickerStyle(.navigationLink)

                    if selectedBrand == .other {
                        TextField("Custom brand", text: $customBrand)
                    }

                    ColorPicker("Car Color", selection: $vehicleColor, supportsOpacity: false)
                }

                Section {
                    Button(isSaving ? "Saving..." : "Save Changes") {
                        saveProfilePreferences()
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .disabled(isSaving)
                }
                
            }
            .onAppear(perform: loadCurrentValues)
        }
        .oculaAlertSheet(
            isPresented: $showSuccessSheet,
            icon: "checkmark",
            iconTint: .green,
            title: "Saved",
            message: "",
            showsIconRing: false,
            iconAnimationActive: animateIcon,
            autoDismissAfter: 1.8,
            onAutoDismiss: {
                showSuccessSheet = false
                animateIcon = false
            }
        )
    }
}

private extension SettingsCarView {
    var brandOptions: [CarBrand] {
        [.other] + CarBrand.allCases.filter { $0 != .other }
    }


    func loadCurrentValues() {
        driverNickname = session.user?.driverNickname ?? "Night Runner"
        vehicleNickname = session.user?.vehicleNickname ?? "Midnight Coupe"
        vehiclePlate = session.user?.vehiclePlate ?? ""

        if let brand = session.user?.vehicleBrand {
            if let matched = CarBrand(rawValue: brand) {
                selectedBrand = matched
                customBrand = ""
            } else {
                selectedBrand = .other
                customBrand = brand
            }
        }

        if let colorHex = session.user?.vehicleColorHex,
           let color = Color(hex: colorHex) {
            vehicleColor = color
        }
    }

    func saveProfilePreferences() {
        guard let uid = session.user?.id ?? Auth.auth().currentUser?.uid else { return }

        isSaving = true
        saveMessage = nil

        let brandToStore: String = {
            if selectedBrand == .other {
                let trimmed = customBrand.trimmingCharacters(in: .whitespacesAndNewlines)
                return trimmed.isEmpty ? CarBrand.other.rawValue : trimmed
            }
            return selectedBrand.rawValue
        }()

        let payload: [String: Any] = [
            "driverNickname": driverNickname,
            "vehicleNickname": vehicleNickname,
            "vehiclePlate": vehiclePlate,
            "vehicleBrand": brandToStore,
            "vehicleColorHex": colorHex(from: vehicleColor)
        ]

        Firestore.firestore().collection("users").document(uid).setData(payload, merge: true) { error in
            Task { @MainActor in
                isSaving = false
                if let error {
                    saveMessage = error.localizedDescription
                } else {
                    saveMessage = "Saved"
                    session.refreshUser()
                    animateIcon = true
                    showSuccessSheet = true
                }
            }
        }
    }

    func colorHex(from color: Color) -> String {
        let uiColor = UIColor(color)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        guard uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return "000000"
        }
        return String(format: "%02X%02X%02X",
                      Int(red * 255),
                      Int(green * 255),
                      Int(blue * 255))
    }
}

#Preview {
    SettingsCarView()
        .environmentObject(SessionManager())
}
