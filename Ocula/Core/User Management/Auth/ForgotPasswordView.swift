//
//  ForgotPasswordView.swift
//  Ocula
//
//  Created by Tyson Miles on 2/10/2026.
//

import SwiftUI

struct ForgotPasswordView: View {
    @ObservedObject var viewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var showValidation = false

    var body: some View {
        NavigationStack {
            ZStack {
                VStack(alignment: .leading, spacing: 20) {
                    AuthBackButton(action: {dismiss()})
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Reset your password")
                            .font(AppTheme.Fonts.semibold(22))
                            .foregroundStyle(AppTheme.Colors.primary)

                        Text("Enter your email and we'll send you a reset link.")
                            .font(AppTheme.Fonts.regular(15))
                            .foregroundStyle(AppTheme.Colors.secondary)

                    }
                        VStack(alignment: .leading, spacing: 16) {
                            AuthTextField(
                                title: "Email",
                                placeholder: "you@ocula.com",
                                text: $viewModel.resetEmail,
                                keyboardType: .emailAddress,
                                textContentType: .emailAddress,
                                autocapitalization: .never,
                                error: resetEmailError
                            )

                            if let errorMessage = viewModel.errorMessage {
                                AuthInlineMessage(text: errorMessage, style: .error)
                                
                            }
                    }

                    AuthPrimaryButton(
                        title: "Send Reset Link",
                        isLoading: viewModel.isLoading,
                        isDisabled: !viewModel.canSubmitReset,
                        action: handleReset
                    )
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(AppTheme.Spacing.md)
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            viewModel.clearErrors()
        }
        .preferredColorScheme(.dark)
    }

    private var resetEmailError: String? {
        if showValidation && !viewModel.canSubmitReset {
            return "Enter a valid email address."
        }
        return nil
    }
    private func handleReset() {
        showValidation = true
        guard viewModel.canSubmitReset else { return }
        Task {
            let success = await viewModel.sendPasswordReset()
            if success {
                dismiss()
            }
        }
    }
}
