//
//  LoginView.swift
//  Ocula
//
//  Created by Tyson Miles on 1/2/2026.
//
import SwiftUI
import FirebaseCore
import Firebase
import FirebaseAuth
struct LoginView: View {

    @EnvironmentObject var session: SessionManager
    @State private var email = ""
    @State private var password = ""
    @State private var error: String?
    @State private var showSigningInNotification = false
    @State private var showSignInErrorNotification = false
    @State private var animateIcon = false

    var onAuthSuccess: (() -> Void)? = nil

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                TextField("Email", text: $email)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                    .textFieldStyle(.roundedBorder)

                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)

                if let error {
                    Text(error).foregroundColor(.red)
                }

                Button("Sign In") {
                    login()
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .oculaAlertSheet(
            isPresented: $showSigningInNotification,
            icon: "circle.dotted",
            iconTint: .blue,
            title: "Signing In...",
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
        .oculaAlertSheet(
            isPresented: $showSignInErrorNotification,
            icon: "person.crop.circle.badge.exclamationmark",
            title: "Unable to Sign In",
            message: "An error occured while signing you in. The error was \(error ?? "Unknown Error")",
            showsIconRing: false,
            iconModifier: { image in
                AnyView(image.symbolRenderingMode(.multicolor))
            },
            primaryTitle: "Try Again",
            primaryAction: { login() },
            secondaryTitle: "Learn More",
            secondaryAction: { print("Show Help page")},
        )
    }

    private func login() {
        error = nil
        session.shouldDeferMainView = true
        animateIcon = true
        showSigningInNotification = true
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            if let error {
                self.error = error.localizedDescription
                showSigningInNotification = false
                showSignInErrorNotification = true
                session.shouldDeferMainView = false
            } else {
                showSigningInNotification = false
                onAuthSuccess?()
            }
        }
    }
}
