//
//  LoginView.swift
//  Ocula
//
//  Created by Tyson Miles on 1/2/2026.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var session: SessionManager
    @ObservedObject var viewModel: AuthViewModel

    let onBack: () -> Void
    let onForgotPassword: () -> Void
    let onSwitchToSignUp: () -> Void

    @State private var showValidation = false

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {

            VStack(alignment: .leading, spacing: 4) {
                AuthBackButton(action: onBack)
                    .padding(.bottom, AppTheme.Spacing.sm)
                Text("Continue with")
                    .font(AppTheme.Fonts.semibold(20))
                    .foregroundStyle(AppTheme.Colors.secondary)

                Text("Email")
                    .font(AppTheme.Fonts.bold(36))
                    .foregroundStyle(AppTheme.Colors.primary)
            }

            VStack(alignment: .leading, spacing: 0) {
                Spacer()
                VStack(alignment: .leading, spacing: 16) {
                    AuthTextField(
                        title: "Email",
                        placeholder: "you@ocula.com",
                        text: $viewModel.email,
                        keyboardType: .emailAddress,
                        textContentType: .emailAddress,
                        autocapitalization: .never,
                        error: emailError
                    )
                    .onChange(of: viewModel.email) { _ in
                        viewModel.clearErrors()
                    }

                    AuthSecureField(
                        title: "Password",
                        placeholder: "Password",
                        text: $viewModel.password,
                        textContentType: .password,
                        error: passwordError
                    )
                    .onChange(of: viewModel.password) { _ in
                        viewModel.clearErrors()
                    }

                    AuthLinkButton(title: "Forgot password?") {
                        onForgotPassword()
                    }

                }

            }
            .frame(maxWidth: .infinity, alignment: .leading)

            AuthPrimaryButton(
                title: "Sign In",
                isLoading: viewModel.isLoading,
                isDisabled: !viewModel.canSubmitLogin,
                action: handleLogin
            )

            Button(action: onSwitchToSignUp) {
                Text("Don't have an account? Sign up")
                    .font(AppTheme.Fonts.semibold(13))
                    .foregroundStyle(AppTheme.Colors.secondary)
            }
            .buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, AppTheme.Spacing.xxl)
        .disabled(viewModel.isLoading)
        .preferredColorScheme(.dark)
    }

    private var emailError: String? {
        if showValidation && !viewModel.isEmailValid {
            return "Enter a valid email address."
        }
        return nil
    }

    private var passwordError: String? {
        if showValidation && !viewModel.isPasswordValid {
            return "Use at least 6 characters and a capital letter."
        }
        return nil
    }

    private func handleLogin() {
        showValidation = true
        guard viewModel.canSubmitLogin else { return }
        session.shouldDeferMainView = true
        Task {
            let success = await viewModel.signIn()
            if !success {
                session.shouldDeferMainView = false
            }
        }
    }
}
