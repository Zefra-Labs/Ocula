//
//  SignupView.swift
//  Ocula
//
//  Created by Tyson Miles on 1/2/2026.
//
import SwiftUI
import FirebaseAuth
import Firebase
import FirebaseFirestore

struct SignupView: View {

    @State private var email = ""
    @State private var password = ""
    @State private var displayName = ""
    @State private var error: String?

    var body: some View {
        VStack(spacing: 16) {
            TextField("Display Name", text: $displayName)
                .textFieldStyle(.roundedBorder)

            TextField("Email", text: $email)
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
                .textFieldStyle(.roundedBorder)

            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)

            if let error {
                Text(error).foregroundColor(.red)
            }

            Button("Create Account") {
                signup()
            }
            .buttonStyle(.borderedProminent)
        }
    }

    private func signup() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error {
                self.error = error.localizedDescription
                return
            }

            guard let uid = result?.user.uid else { return }

            let user = AppUser(
                id: uid,
                email: email,
                displayName: displayName,
                createdAt: Date(),
                lastLogin: Date(),
                accountType: "standard",
                onboardingComplete: false,
                driverNickname: nil,
                vehicleNickname: nil,
                vehicleBrand: nil,
                vehicleColorHex: nil
            )

            try? Firestore.firestore()
                .collection("users")
                .document(uid)
                .setData(from: user)
        }
    }
}
