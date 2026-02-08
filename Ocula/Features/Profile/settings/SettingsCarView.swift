//
//  SettingsCarView.swift
//  Ocula
//
//  Created by Tyson Miles on 7/2/2026.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct SettingsCarView: View {
    @EnvironmentObject var session: SessionManager

    @State private var driverNickname: String = ""
    @State private var vehicleNickname: String = ""
    @State private var selectedBrand: CarBrand = .bmw
    @State private var selectedColor: CarColorOption = CarColorOption.standard[0]
    @State private var isSaving = false
    @State private var saveMessage: String? = nil

    var body: some View {
        SettingsScaffold(title: "Car") {
            ScrollView {
                VStack(spacing: AppTheme.Spacing.lg) {
                    SettingsSectionHeader(title: "Driver")

                    VStack(spacing: AppTheme.Spacing.sm) {
                        textFieldCard(title: "Driver nickname", text: $driverNickname)
                    }

                    SettingsSectionHeader(title: "Vehicle")

                    VStack(spacing: AppTheme.Spacing.sm) {
                        textFieldCard(title: "Vehicle nickname", text: $vehicleNickname)

                        brandPicker

                        colorPicker
                    }

                    Button(isSaving ? "Saving..." : "Save Changes") {
                        saveProfilePreferences()
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .disabled(isSaving)

                    if let saveMessage {
                        Text(saveMessage)
                            .captionStyle()
                    }
                }
                .padding(.horizontal, AppTheme.Spacing.md)
                .padding(.bottom, AppTheme.Spacing.xl)
            }
            .onAppear(perform: loadCurrentValues)
        }
    }
}

private extension SettingsCarView {

    var brandPicker: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Car brand")
                .captionStyle()

            Menu {
                ForEach(CarBrand.allCases) { brand in
                    Button(brand.rawValue) {
                        selectedBrand = brand
                    }
                }
            } label: {
                HStack {
                    Text(selectedBrand.rawValue)
                        .foregroundColor(AppTheme.Colors.primary)

                    Spacer()

                    Image(systemName: "chevron.down")
                        .foregroundColor(AppTheme.Colors.secondary)
                }
                .padding(AppTheme.Spacing.md)
                .background(
                    RoundedRectangle(cornerRadius: AppTheme.Radius.xlg, style: .continuous)
                        .fill(AppTheme.Colors.surfaceDark.opacity(0.35))
                        .overlay(
                            RoundedRectangle(cornerRadius: AppTheme.Radius.xlg, style: .continuous)
                                .stroke(AppTheme.Colors.primary.opacity(0.07), lineWidth: 1)
                        )
                )
            }
        }
    }

    var colorPicker: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Car color")
                .captionStyle()

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(CarColorOption.standard) { option in
                        Button {
                            selectedColor = option
                        } label: {
                            VStack(spacing: 6) {
                                Circle()
                                    .fill(Color(hex: option.hex) ?? AppTheme.Colors.secondary)
                                    .frame(width: 26, height: 26)
                                    .overlay(
                                        Circle()
                                            .stroke(AppTheme.Colors.primary, lineWidth: selectedColor.id == option.id ? 2 : 0)
                                    )

                                Text(option.name)
                                    .font(AppTheme.Fonts.medium(11))
                                    .foregroundColor(AppTheme.Colors.secondary)
                            }
                            .padding(.vertical, 6)
                            .padding(.horizontal, 4)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    func textFieldCard(title: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .captionStyle()

            TextField("", text: text)
                .foregroundColor(AppTheme.Colors.primary)
                .padding(AppTheme.Spacing.md)
                .background(
                    RoundedRectangle(cornerRadius: AppTheme.Radius.xlg, style: .continuous)
                        .fill(AppTheme.Colors.surfaceDark.opacity(0.35))
                        .overlay(
                            RoundedRectangle(cornerRadius: AppTheme.Radius.xlg, style: .continuous)
                                .stroke(AppTheme.Colors.primary.opacity(0.07), lineWidth: 1)
                        )
                )
        }
    }

    func loadCurrentValues() {
        driverNickname = session.user?.driverNickname ?? "Night Runner"
        vehicleNickname = session.user?.vehicleNickname ?? "Midnight Coupe"

        if let brand = session.user?.vehicleBrand, let matched = CarBrand(rawValue: brand) {
            selectedBrand = matched
        }

        if let colorHex = session.user?.vehicleColorHex,
           let matched = CarColorOption.standard.first(where: { $0.hex.lowercased() == colorHex.lowercased() }) {
            selectedColor = matched
        }
    }

    func saveProfilePreferences() {
        guard let uid = session.user?.id ?? Auth.auth().currentUser?.uid else { return }

        isSaving = true
        saveMessage = nil

        let payload: [String: Any] = [
            "driverNickname": driverNickname,
            "vehicleNickname": vehicleNickname,
            "vehicleBrand": selectedBrand.rawValue,
            "vehicleColorHex": selectedColor.hex
        ]

        Firestore.firestore().collection("users").document(uid).setData(payload, merge: true) { error in
            Task { @MainActor in
                isSaving = false
                if let error {
                    saveMessage = error.localizedDescription
                } else {
                    saveMessage = "Saved"
                    session.refreshUser()
                }
            }
        }
    }
}

#Preview {
    SettingsCarView()
        .environmentObject(SessionManager())
}
