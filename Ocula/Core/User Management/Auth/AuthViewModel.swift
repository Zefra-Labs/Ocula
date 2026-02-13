//
//  AuthViewModel.swift
//  Ocula
//
//  Created by Tyson Miles on 2/10/2026.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Combine
import GoogleSignInSwift
import GoogleSignIn

@MainActor
final class AuthViewModel: ObservableObject {
    enum SuccessContext {
        case auth
        case resetPassword
    }

    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var resetEmail: String = ""

    @Published var isLoading: Bool = false
    @Published var showLoadingSheet: Bool = false
    @Published var loadingTitle: String = "Signing In..."

    @Published var showSuccessSheet: Bool = false
    @Published var successTitle: String = "Success"
    @Published var successMessage: String = ""
    @Published var successContext: SuccessContext = .auth

    @Published var showErrorSheet: Bool = false
    @Published var errorTitle: String = "Unable to Continue"
    @Published var errorMessage: String?
    @Published var showForgotPassword: Bool = false

    var isEmailValid: Bool {
        let trimmed = email.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.contains("@") && trimmed.contains(".") && trimmed.count >= 5
    }

    var isPasswordValid: Bool {
        password.count >= 6
    }

    var isConfirmPasswordValid: Bool {
        !confirmPassword.isEmpty && confirmPassword == password
    }

    var canSubmitLogin: Bool {
        isEmailValid && isPasswordValid && !isLoading
    }

    var canSubmitSignUp: Bool {
        isEmailValid && isPasswordValid && isConfirmPasswordValid && !isLoading
    }

    var canSubmitReset: Bool {
        let trimmed = resetEmail.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.contains("@") && trimmed.contains(".") && trimmed.count >= 5 && !isLoading
    }

    func clearErrors() {
        errorMessage = nil
        errorTitle = "Unable to Continue"
        showErrorSheet = false
    }

    func prefillResetEmail() {
        if resetEmail.isEmpty {
            resetEmail = email
        }
    }

    func signIn() async -> Bool {
        clearErrors()
        guard isEmailValid else {
            presentError(title: "Unable to Sign In", message: "Please enter a valid email address.")
            return false
        }
        guard isPasswordValid else {
            presentError(title: "Unable to Sign In", message: "Your password must be at least 6 characters.")
            return false
        }

        loadingTitle = "Signing In..."
        showLoadingSheet = true
        isLoading = true
        do {
            _ = try await Auth.auth().signIn(withEmail: email, password: password)
            isLoading = false
            showLoadingSheet = false
            successTitle = "Signed In"
            successMessage = "Welcome back"
            successContext = .auth
            showSuccessSheet = true
            return true
        } catch {
            isLoading = false
            showLoadingSheet = false
            presentError(title: "Unable to Sign In", message: mapAuthError(error))
            return false
        }
    }

    func signUp() async -> Bool {
        clearErrors()
        guard isEmailValid else {
            presentError(title: "Unable to Create Account", message: "Please enter a valid email address.")
            return false
        }
        guard isPasswordValid else {
            presentError(title: "Unable to Create Account", message: "Please choose a password with at least 6 characters.")
            return false
        }
        guard isConfirmPasswordValid else {
            presentError(title: "Unable to Create Account", message: "The passwords do not match.")
            return false
        }

        loadingTitle = "Creating Account..."
        showLoadingSheet = true
        isLoading = true
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            let uid = result.user.uid
            let name = deriveDisplayName(from: email)

            let user = AppUser(
                id: uid,
                email: email,
                displayName: name,
                createdAt: Date(),
                lastLogin: Date(),
                accountType: "standard",
                onboardingComplete: false,
                driverNickname: nil,
                vehicleNickname: nil,
                vehiclePlate: nil,
                vehicleBrand: nil,
                vehicleColorHex: nil
            )

            try await Firestore.firestore()
                .collection("users")
                .document(uid)
                .setData(from: user, merge: true)

            isLoading = false
            showLoadingSheet = false
            successTitle = "Account Created"
            successMessage = "Welcome to Ocula"
            successContext = .auth
            showSuccessSheet = true
            return true
        } catch {
            isLoading = false
            showLoadingSheet = false
            presentError(title: "Unable to Create Account", message: mapAuthError(error))
            return false
        }
    }

    func sendPasswordReset() async -> Bool {
        clearErrors()
        guard canSubmitReset else {
            errorMessage = "Please enter a valid email address."
            return false
        }

        loadingTitle = "Sending Reset Email..."
        isLoading = true
        do {
            try await Auth.auth().sendPasswordReset(withEmail: resetEmail)
            isLoading = false
            successTitle = "Reset Email Sent"
            successMessage = "Check your inbox for the reset link."
            successContext = .resetPassword
            showSuccessSheet = true
            return true
        } catch {
            isLoading = false
            errorMessage = mapAuthError(error)
            return false
        }
    }

    func signInWithGoogle() async -> Bool {
        clearErrors()
        loadingTitle = "Connecting..."
        showLoadingSheet = true
        isLoading = true

        let provider = OAuthProvider(providerID: "google.com")
        do {
            _ = try await signIn(with: provider)
            isLoading = false
            showLoadingSheet = false
            successTitle = "Signed In"
            successMessage = "Welcome to Ocula"
            successContext = .auth
            showSuccessSheet = true
            return true
        } catch {
            isLoading = false
            showLoadingSheet = false
            presentError(title: "Unable to Sign In", message: mapAuthError(error))
            return false
        }
    }

    private func signIn(with provider: OAuthProvider) async throws -> AuthDataResult {
        try await withCheckedThrowingContinuation { continuation in
            Auth.auth().signIn(with: provider, uiDelegate: nil) { result, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }
                if let result {
                    continuation.resume(returning: result)
                    return
                }
                continuation.resume(throwing: NSError(domain: "OculaAuth", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to sign in."]))
            }
        }
    }

    private func deriveDisplayName(from email: String) -> String {
        let trimmed = email.trimmingCharacters(in: .whitespacesAndNewlines)
        if let name = trimmed.split(separator: "@").first {
            return name.isEmpty ? "Driver" : String(name)
        }
        return "Driver"
    }

    private func mapAuthError(_ error: Error) -> String {
        let nsError = error as NSError
        if let code = AuthErrorCode(rawValue: nsError.code) {
            switch code {
            case .wrongPassword:
                return "The password you entered does not match this account."
            case .userNotFound:
                return "We could not find an account with that email."
            case .emailAlreadyInUse:
                return "An account already exists for this email. Please sign in instead."
            case .weakPassword:
                return "Please choose a stronger password with at least 6 characters."
            case .invalidEmail:
                return "Please enter a valid email address."
            case .invalidCredential:
                return "The email or password you entered does not match our records."
            case .missingEmail:
                return "Please enter your email address."
            case .networkError:
                return "We could not connect to the network. Check your connection and try again."
            case .tooManyRequests:
                return "Too many attempts. Please wait a few minutes and try again."
            case .userDisabled:
                return "This account has been disabled. Contact support for help."
            case .credentialAlreadyInUse:
                return "That sign-in method is already linked to another account."
            case .accountExistsWithDifferentCredential:
                return "An account already exists with a different sign-in method. Use the original method to sign in."
            case .operationNotAllowed:
                return "This sign-in method is currently unavailable. Please try another option."
            case .invalidActionCode:
                return "That reset link is invalid. Please request a new one."
            case .expiredActionCode:
                return "That reset link has expired. Please request a new one."
            case .requiresRecentLogin:
                return "Please sign in again to continue."
            default:
                break
            }
        }
        if nsError.domain == FirestoreErrorDomain {
            return "Your account was created, but setup did not finish. Please sign in to continue."
        }
        return "We could not complete that request. Please try again."
    }

    private func presentError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showErrorSheet = true
    }
}
