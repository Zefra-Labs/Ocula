//
//  OculaAlertSheet.swift
//  Ocula
//
//  Created by Tyson Miles on 4/2/2026.
//


import SwiftUI

// MARK: - Ocula Alert Sheet

struct OculaAlertSheet: View {
    let icon: String
    let iconTint: Color

    let title: String
    let message: String

    let primaryTitle: String
    let primaryAction: () -> Void

    let secondaryTitle: String?
    let secondaryAction: (() -> Void)?

    var body: some View {
        VStack(spacing: 18) {

            // Drag indicator (visible), but sheet is fixed height + no swipe-to-dismiss
            Capsule()
                .fill(.secondary.opacity(0.35))
                .frame(width: 46, height: 5)
                .padding(.top, 8)

            ZStack {
                Circle()
                    .stroke(iconTint, lineWidth: 4)
                    .frame(width: 84, height: 84)

                Image(systemName: icon)
                    .font(.system(size: 34, weight: .semibold))
                    .foregroundStyle(iconTint)
            }
            .padding(.top, 6)

            Text(title)
                .font(.system(size: 28, weight: .bold))
                .multilineTextAlignment(.center)
                .padding(.top, 6)

            Text(message)
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 18)

            VStack(spacing: 12) {
                Button(action: primaryAction) {
                    Text(primaryTitle)
                        .font(.system(size: 17, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)

                if let secondaryTitle, let secondaryAction {
                    Button(action: secondaryAction) {
                        Text(secondaryTitle)
                            .font(.system(size: 17, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                    }
                    .buttonStyle(.bordered)
                }
            }
            .padding(.top, 8)
            .padding(.horizontal, 18)

            Spacer(minLength: 10)
        }
        .padding(.bottom, 14)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .padding(.horizontal, 12)
    }
}

// MARK: - Easy Implementation

private struct OculaAlertSheetPresenter: ViewModifier {
    @Binding var isPresented: Bool

    let icon: String
    let iconTint: Color
    let title: String
    let message: String
    let primaryTitle: String
    let primaryAction: () -> Void
    let secondaryTitle: String?
    let secondaryAction: (() -> Void)?

    func body(content: Content) -> some View {
        content.sheet(isPresented: $isPresented) {
            OculaAlertSheet(
                icon: icon,
                iconTint: iconTint,
                title: title,
                message: message,
                primaryTitle: primaryTitle,
                primaryAction: {
                    isPresented = false
                    primaryAction()
                },
                secondaryTitle: secondaryTitle,
                secondaryAction: {
                    guard let secondaryAction else { return }
                    isPresented = false
                    secondaryAction()
                }
            )
            .presentationDetents([.height(360)])               // fixed height = can’t resize
            .presentationDragIndicator(.visible)              // indicator shown
            .interactiveDismissDisabled(true)                 // can’t swipe down to dismiss
            .presentationBackground(.clear)
        }
    }
}

extension View {
    func oculaAlertSheet(
        isPresented: Binding<Bool>,
        icon: String = "xmark",
        iconTint: Color = .red,
        title: String,
        message: String,
        primaryTitle: String,
        primaryAction: @escaping () -> Void,
        secondaryTitle: String? = nil,
        secondaryAction: (() -> Void)? = nil
    ) -> some View {
        modifier(OculaAlertSheetPresenter(
            isPresented: isPresented,
            icon: icon,
            iconTint: iconTint,
            title: title,
            message: message,
            primaryTitle: primaryTitle,
            primaryAction: primaryAction,
            secondaryTitle: secondaryTitle,
            secondaryAction: secondaryAction
        ))
    }
}

// MARK: - Example

struct DemoView: View {
    @State private var show = false

    var body: some View {
        Button("Show Alert Sheet") { show = true }
            .oculaAlertSheet(
                isPresented: $show,
                icon: "xmark",
                iconTint: .red,
                title: "We’re sorry, something has gone wrong.",
                message: "Please try later",
                primaryTitle: "Retry",
                primaryAction: { print("Retry tapped") }
                // Optional second button:
                // secondaryTitle: "Cancel",
                // secondaryAction: { print("Cancel") }
            )
    }
}
