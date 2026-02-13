//
//  SignupView.swift
//  Ocula
//
//  Created by Tyson Miles on 1/2/2026.
//

import SwiftUI

struct SignUpView: View {
    enum Step {
        case email
        case password
    }

    @EnvironmentObject var session: SessionManager
    @ObservedObject var viewModel: AuthViewModel

    let onBack: () -> Void
    let onSwitchToLogin: () -> Void

    @State private var step: Step = .email
    @State private var showValidation = false

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 4) {
                AuthBackButton(action: handleBack)
                    .padding(.bottom, AppTheme.Spacing.sm)
                Text("Create An")
                    .font(AppTheme.Fonts.semibold(20))
                    .foregroundStyle(AppTheme.Colors.secondary)

                Text("Account")
                    .font(AppTheme.Fonts.bold(36))
                    .foregroundStyle(AppTheme.Colors.primary)
            }

            VStack(alignment: .leading, spacing: 0) {
                
                Spacer()
                VStack(alignment: .leading, spacing: 16) {
                    if step == .email {
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
                    } else {
                        AuthSecureField(
                            title: "Password",
                            placeholder: "Create a password",
                            text: $viewModel.password,
                            textContentType: .newPassword,
                            error: passwordError
                        )
                        .onChange(of: viewModel.password) { _ in
                            viewModel.clearErrors()
                        }

                        PasswordRequirementsView(password: viewModel.password)

                        AuthSecureField(
                            title: "Confirm password",
                            placeholder: "Re-enter password",
                            text: $viewModel.confirmPassword,
                            textContentType: .newPassword,
                            error: confirmPasswordError
                        )
                        .onChange(of: viewModel.confirmPassword) { _ in
                            viewModel.clearErrors()
                        }
                    }

                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            if step == .email {
                AuthPrimaryButton(
                    title: "Continue",
                    isLoading: viewModel.isLoading,
                    isDisabled: !viewModel.isEmailValid,
                    action: handleContinue
                )
            } else {
                AuthPrimaryButton(
                    title: "Create Account",
                    isLoading: viewModel.isLoading,
                    isDisabled: !viewModel.canSubmitSignUp,
                    action: handleSignUp
                )
            }

            Button(action: onSwitchToLogin) {
                Text("Already have an account? Log in")
                    .font(AppTheme.Fonts.semibold(13))
                    .foregroundStyle(AppTheme.Colors.secondary)
            }
            .buttonStyle(.plain)
        }
        .padding(.bottom, AppTheme.Spacing.xxl)
        .frame(maxWidth: .infinity, alignment: .leading)
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
            return "Use at least 6 characters."
        }
        return nil
    }

    private var confirmPasswordError: String? {
        if showValidation && !viewModel.isConfirmPasswordValid {
            return "Passwords do not match."
        }
        return nil
    }

    private func handleBack() {
        if step == .email {
            onBack()
        } else {
            step = .email
            showValidation = false
        }
    }

    private func handleContinue() {
        showValidation = true
        guard viewModel.isEmailValid else { return }
        viewModel.clearErrors()
        withAnimation(.spring(response: 0.45, dampingFraction: 0.9)) {
            step = .password
        }
    }

    private func handleSignUp() {
        showValidation = true
        guard viewModel.canSubmitSignUp else { return }
        session.shouldDeferMainView = true
        Task {
            let success = await viewModel.signUp()
            if !success {
                session.shouldDeferMainView = false
            }
        }
    }
}
