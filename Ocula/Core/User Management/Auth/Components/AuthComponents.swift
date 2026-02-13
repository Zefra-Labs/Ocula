//
//  AuthComponents.swift
//  Ocula
//
//  Created by Tyson Miles on 2/10/2026.
//

import SwiftUI
import SafariServices

struct AuthCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(AppTheme.Spacing.lg)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.Radius.xlg, style: .continuous)
                    .fill(.ultraThinMaterial)
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.Radius.xlg, style: .continuous)
                    .stroke(AppTheme.Colors.secondary.opacity(0.15), lineWidth: 1)
            )
    }
}

struct AuthTextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var textContentType: UITextContentType? = nil
    var autocapitalization: TextInputAutocapitalization = .never
    var error: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(AppTheme.Fonts.medium(13))
                .foregroundStyle(AppTheme.Colors.secondary)

            TextField(placeholder, text: $text)
                .textInputAutocapitalization(autocapitalization)
                .keyboardType(keyboardType)
                .textContentType(textContentType)
                .autocorrectionDisabled()
                .padding(.horizontal, 14)
                .frame(height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .fill(AppTheme.Colors.background.opacity(0.6))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .stroke(AppTheme.Colors.secondary.opacity(0.35), lineWidth: 1)
                )
                .accessibilityLabel(title)

            if let error {
                AuthInlineMessage(text: error, style: .error)
            }
        }
    }
}

struct AuthSecureField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var textContentType: UITextContentType? = .password
    var error: String? = nil

    @State private var isSecure: Bool = true

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(AppTheme.Fonts.medium(13))
                .foregroundStyle(AppTheme.Colors.secondary)
            HStack(spacing: 8) {
                Group {
                    if isSecure {
                        SecureField(placeholder, text: $text)
                    } else {
                        TextField(placeholder, text: $text)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                    }
                }
                .textContentType(textContentType)

                Button {
                    isSecure.toggle()
                } label: {
                    Image(systemName: isSecure ? "eye" : "eye.slash")
                        .foregroundStyle(AppTheme.Colors.secondary)
                        .frame(width: 28, height: 28)
                }
                .accessibilityLabel(isSecure ? "Show password" : "Hide password")
            }
            .padding(.horizontal, 14)
            .frame(height: 50)
            .background(
                RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .fill(AppTheme.Colors.background.opacity(0.6))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .stroke(AppTheme.Colors.secondary.opacity(0.35), lineWidth: 1)
            )

            if let error {
                AuthInlineMessage(text: error, style: .error)
            }
        }
    }
}

struct AuthPrimaryButton: View {
    let title: String
    let isLoading: Bool
    let isDisabled: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.white)
                } else {
                    Text(title)
                        .font(AppTheme.Fonts.semibold(16))
                }
            }
        }
        .buttonStyle(PrimaryAuthButtonStyle())
        .disabled(isDisabled || isLoading)
        .opacity(isDisabled ? 0.6 : 1)
        .accessibilityLabel(title)
    }
}

struct AuthGhostButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppTheme.Fonts.semibold(15))
                .foregroundStyle(AppTheme.Colors.primary)
        }
        .buttonStyle(SecondaryLightButtonStyle())
    }
}
struct AuthPrimaryGhostButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppTheme.Fonts.semibold(15))
                .foregroundStyle(AppTheme.Colors.primary)
        }
        .buttonStyle(PrimaryLightButtonStyle())
    }
}
struct AuthInlineMessage: View {
    enum Style {
        case error
        case info
    }

    let text: String
    var style: Style = .error

    var body: some View {
        Text(text)
            .font(AppTheme.Fonts.medium(13))
            .foregroundStyle(style == .error ? AppTheme.Colors.destructive.opacity(0.8) : AppTheme.Colors.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .accessibilityLabel(text)
    }
}

struct AuthLinkButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppTheme.Fonts.semibold(13))
                .foregroundStyle(AppTheme.Colors.accent)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 6)
        }
        .buttonStyle(.plain)
    }
}

struct AuthBackButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "chevron.left")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(AppTheme.Colors.primary)
                .frame(width: 36, height: 36)
                .background(
                    Circle().fill(AppTheme.Colors.secondary.opacity(0.15))
                )
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Back")
    }
}

struct AuthDivider: View {
    var body: some View {
        HStack(spacing: 12) {
            Rectangle()
                .fill(AppTheme.Colors.secondary.opacity(0.25))
                .frame(height: 1)
            Text("or")
                .font(AppTheme.Fonts.medium(12))
                .foregroundStyle(AppTheme.Colors.secondary)
            Rectangle()
                .fill(AppTheme.Colors.secondary.opacity(0.25))
                .frame(height: 1)
        }
    }
}
struct TermsConditionsLinkConsent: View {
    @State private var isShowingLegal = false

    private var legalAttributedText: AttributedString {
        var text = AttributedString("Terms of Use and Privacy Policy")
        if let range = text.range(of: "Terms of Use") {
            text[range].font = AppTheme.Fonts.bold(12)
        }
        if let range = text.range(of: " and ") {
            text[range].font = AppTheme.Fonts.semibold(12)
        }
        if let range = text.range(of: "Privacy Policy") {
            text[range].font = AppTheme.Fonts.bold(12)
        }
        return text
    }

    var body: some View {
        Button {
            isShowingLegal = true
        } label: {
            VStack(alignment: .center, spacing: 4) {
                Text("By continuing, you agree to our")
                    .font(AppTheme.Fonts.semibold(12))
                    .foregroundStyle(AppTheme.Colors.secondary)

                Text(legalAttributedText)
                .foregroundStyle(AppTheme.Colors.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .multilineTextAlignment(.center)
        }
        .buttonStyle(.plain)
        .contentShape(Rectangle())
        .sheet(isPresented: $isShowingLegal) {
            SafariWebView(url: URL(string: "https://milescomedia.com.au/legal")!)
        }
    }
}

private struct SafariWebView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}
struct PasswordRequirementsView: View {
    let password: String

    private var score: CGFloat {
        let rules = [hasMinLength]
        let passed = rules.filter { $0 }.count
        return CGFloat(passed) / CGFloat(rules.count)
    }

    private var hasMinLength: Bool { password.count >= 6 }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(AppTheme.Colors.secondary.opacity(0.2))
                    .frame(height: 6)
                Capsule()
                    .fill(AppTheme.Colors.accent)
                    .frame(width: max(8, score * 360), height: 6)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            RequirementRow(text: "At least 6 characters", satisfied: hasMinLength)
        }
    }

    private struct RequirementRow: View {
        let text: String
        let satisfied: Bool

        var body: some View {
            HStack(spacing: 6) {
                Circle()
                    .fill(satisfied ? AppTheme.Colors.accent : AppTheme.Colors.secondary.opacity(0.35))
                    .frame(width: 6, height: 6)
                Text(text)
                    .font(AppTheme.Fonts.medium(12))
                    .foregroundStyle(AppTheme.Colors.secondary)
            }
        }
    }
}
