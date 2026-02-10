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

    @EnvironmentObject var session: SessionManager
    @State private var email = ""
    @State private var password = ""
    @State private var displayName = ""
    @State private var error: String?
    @State private var showSigningUpNotification = false
    @State private var animateIcon = false

    var onAuthSuccess: (() -> Void)? = nil

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
        .oculaAlertSheet(
            isPresented: $showSigningUpNotification,
            icon: "circle.dotted",
            iconTint: .yellow,
            title: "Creating Account...",
            message: "",
            showsIconRing: false,
            iconModifier: { image in
                AnyView(image.symbolRenderingMode(.hierarchical))
            },
            iconAnimator: { image, _ in
                if #available(iOS 17.0, *) {
                    return AnyView(
                        image
                            .symbolEffect(.rotate.byLayer, options: .repeat(.continuous))
                    )
                } else {
                    return AnyView(image)
                }
            },
            iconAnimationActive: animateIcon
        )
    }

    private func signup() {
        error = nil
        session.shouldDeferMainView = true
        animateIcon = true
        showSigningUpNotification = true
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error {
                self.error = error.localizedDescription
                showSigningUpNotification = false
                session.shouldDeferMainView = false
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

            do {
                try Firestore.firestore()
                    .collection("users")
                    .document(uid)
                    .setData(from: user) { error in
                    if let error {
                        self.error = error.localizedDescription
                        session.shouldDeferMainView = false
                    } else {
                        onAuthSuccess?()
                    }
                    showSigningUpNotification = false
                }
            } catch {
                self.error = error.localizedDescription
                showSigningUpNotification = false
                session.shouldDeferMainView = false
            }
        }
    }
}
