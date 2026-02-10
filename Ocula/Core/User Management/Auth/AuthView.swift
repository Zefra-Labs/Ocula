//
//  AuthView.swift
//  Ocula
//
//  Created by Tyson Miles on 1/2/2026.
//
import SwiftUI

struct AuthView: View {

    @EnvironmentObject var session: SessionManager
    @State private var showSignup = false
    @State private var showAuthSuccess = false
    @State private var animateIcon = false
    @State private var successTitle = "Success"

    var body: some View {
        VStack(spacing: 24) {
            Text("Ocula One")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("AI-powered driving intelligence")
                .foregroundStyle(.secondary)

            if showSignup {
                SignupView(onAuthSuccess: {
                    successTitle = "Account Created"
                    animateIcon = true
                    showAuthSuccess = true
                })
            } else {
                LoginView(onAuthSuccess: {
                    successTitle = "Signed In"
                    animateIcon = true
                    showAuthSuccess = true
                })
            }

            Button(showSignup ? "Already have an account?" : "Create an account") {
                showSignup.toggle()
            }
            .buttonStyle(PrimaryButtonStyle())
            
        }
        .oculaAlertSheet(
            isPresented: $session.showSignOutSuccess,
            icon: "checkmark",
            iconTint: .green,
            title: "Success",
            message: "",
            showsIconRing: false,
            iconAnimationActive: animateIcon,
            autoDismissAfter: 1.5,
            onAutoDismiss: { print("Auto dismissed") }
        )
        .padding()
        .oculaAlertSheet(
            isPresented: $showAuthSuccess,
            icon: "checkmark",
            iconTint: .green,
            title: successTitle,
            message: "",
            showsIconRing: false,
            iconAnimationActive: animateIcon,
            autoDismissAfter: 2,
            onAutoDismiss: {
                session.shouldDeferMainView = false
            }
        )
    }
}
#Preview {
    AuthView()
}
