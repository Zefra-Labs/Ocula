//
//  OculaAlertSheet.swift
//  Ocula
//
//  Created by Tyson Miles on 4/2/2026.
//


import SwiftUI
import Combine

// MARK: - Ocula Alert Sheet (dynamic height + timed auto-slide + progress drag indicator)

struct OculaAlertSheet: View {
    let icon: String
    let iconTint: Color
    let title: String
    let message: String
    let showsIconRing: Bool
    let iconModifier: ((Image) -> AnyView)?
    let iconAnimator: ((Image, Bool) -> AnyView)?
    let iconAnimationActive: Bool

    let primaryTitle: String?
    let primaryAction: (() -> Void)?

    let secondaryTitle: String?
    let secondaryAction: (() -> Void)?

    /// If set, the “drag indicator” becomes a progress bar and the sheet auto-slides down when it completes.
    let autoDismissAfter: TimeInterval?
    let onAutoDismiss: (() -> Void)?
    let requestDismiss: () -> Void

    @State private var start = Date()
    @State private var progress: CGFloat = 0
    @State private var closing = false

    // Dynamic detent
    @State private var contentHeight: CGFloat = 420

    private let tick = Timer.publish(every: 0.02, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 18) {
            contentBlock

            if hasButtons { buttonBlock }
        }
        .fixedSize(horizontal: false, vertical: true)
        .padding(.bottom, AppTheme.Spacing.sm)
        .background(.clear)
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .padding(.horizontal, AppTheme.Spacing.sm)
        .overlay(alignment: .top) {
            progressDragIndicator
                .padding(.top, 5)
        }
        .offset(y: closing ? 520 : 0) // slide down animation

        // Measure the actual content height so detent can match it
        .readHeight { h in
            // Clamp so it never becomes absurdly small or too tall for the screen.
            // You can tune these numbers.
            let minH: CGFloat = 220
            let maxH: CGFloat = 520
            let padded = h + 18 // small buffer so it doesn't feel "tight"
            let clamped = min(max(padded, minH), maxH)

            // Avoid thrashing: only update if it changed meaningfully
            if abs(clamped - contentHeight) > 2 {
                contentHeight = clamped
            }
        }
    }

    private func beginAutoClose() {
        withAnimation(.easeInOut(duration: 0.32)) { closing = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.33) {
            requestDismiss()
            onAutoDismiss?()
        }
    }

    private var contentBlock: some View {
        VStack(spacing: 18) {
            ZStack {
                if showsIconRing {
                    Circle()
                        .stroke(iconTint, lineWidth: 4)
                        .frame(width: 65, height: 65)
                }

                iconView
            }
            .padding(.top, 60)

            // Title: FIXED (was forcing 1 line due to your minHeight frame + lineLimit combo)
            Text(title)
                .titleStyle()
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true) // allow wrapping
                .lineLimit(nil)                                // unlimited lines
                .padding(.top, 6)
                .padding(.horizontal, 18)

            Text(message)
                .bodyStyle()
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 18)
        }
    }

    private var buttonBlock: some View {
        VStack(spacing: 12) {
            if let primaryTitle {
                Button {
                    requestDismiss()
                    primaryAction?()
                } label: {
                    Text(primaryTitle)
                        .font(.system(size: 17, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                }
                .buttonStyle(PrimaryButtonStyle())
                .tint(.blue)
            }

            if let secondaryTitle {
                Button {
                    requestDismiss()
                    secondaryAction?()
                } label: {
                    Text(secondaryTitle)
                        .font(.system(size: 17, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                }
                .buttonStyle(SecondaryButtonStyle())
                .tint(.gray)
            }
        }
        .padding(.horizontal, AppTheme.Spacing.lg)
        .padding(.top, AppTheme.Spacing.lg)
    }

    private var hasButtons: Bool {
        primaryTitle != nil || secondaryTitle != nil
    }

    private var iconView: some View {
        let baseImage = Image(systemName: icon)
        let content: AnyView
        if let iconAnimator {
            content = iconAnimator(baseImage, iconAnimationActive)
        } else if let iconModifier {
            content = iconModifier(baseImage)
        } else {
            content = AnyView(baseImage)
        }
        return AnyView(
            content
                .font(.system(size: 40, weight: .regular))
                .foregroundStyle(iconTint)
        )
    }

    private var progressDragIndicator: some View {
        // Progress drag indicator (looks like the iOS handle, but fills over time)
        ZStack(alignment: .leading) {
            Capsule().fill(.primary.opacity(0.25))
            Capsule().fill(.primary.opacity(1))
                .frame(width: 50 * progress)
        }
        .frame(width: 50, height: 6)
        .opacity(autoDismissAfter == nil ? 0.6 : 1.0)
        .onAppear { start = Date(); progress = 0 }
        .onReceive(tick) { _ in
            guard let d = autoDismissAfter, d > 0, !closing else { return }
            let t = Date().timeIntervalSince(start)
            progress = min(1, CGFloat(t / d))
            if progress >= 1 { beginAutoClose() }
        }
    }
}

// MARK: - Presenter

private struct OculaAlertSheetPresenter: ViewModifier {
    @Binding var isPresented: Bool

    let icon: String
    let iconTint: Color
    let title: String
    let message: String
    let showsIconRing: Bool
    let iconModifier: ((Image) -> AnyView)?
    let iconAnimator: ((Image, Bool) -> AnyView)?
    let iconAnimationActive: Bool
    let primaryTitle: String?
    let primaryAction: (() -> Void)?
    let secondaryTitle: String?
    let secondaryAction: (() -> Void)?

    let autoDismissAfter: TimeInterval?
    let onAutoDismiss: (() -> Void)?

    // Detent height managed at the presenter level
    @State private var detentHeight: CGFloat = 400

    func body(content: Content) -> some View {
        content.sheet(isPresented: $isPresented) {
            OculaAlertSheet(
                icon: icon,
                iconTint: iconTint,
                title: title,
                message: message,
                showsIconRing: showsIconRing,
                iconModifier: iconModifier,
                iconAnimator: iconAnimator,
                iconAnimationActive: iconAnimationActive,
                primaryTitle: primaryTitle,
                primaryAction: primaryAction,
                secondaryTitle: secondaryTitle,
                secondaryAction: secondaryAction,
                autoDismissAfter: autoDismissAfter,
                onAutoDismiss: onAutoDismiss,
                requestDismiss: { isPresented = false }
            )
            // push measured height up to the presenter so the detent can follow it
            .onPreferenceChange(HeightPreferenceKey.self) { h in
                let minH: CGFloat = 220
                let maxH: CGFloat = 520
                let clamped = min(max(h + 18, minH), maxH)
                if abs(clamped - detentHeight) > 2 {
                    detentHeight = clamped
                }
            }

            // Dynamic height detent (adjusts to content)
            .presentationDetents([.height(detentHeight)])

            .presentationDragIndicator(.hidden)   // we draw our own
            .interactiveDismissDisabled(true)     // can’t swipe down
            .presentationBackground(.clear)
        }
    }
}

extension View {
    /// `autoDismissAfter`: seconds until the sheet auto-slides down (and dismisses). Nil disables the timer.
    func oculaAlertSheet(
        isPresented: Binding<Bool>,
        icon: String = "xmark",
        iconTint: Color = .red,
        title: String,
        message: String,
        showsIconRing: Bool = true,
        iconModifier: ((Image) -> AnyView)? = nil,
        iconAnimator: ((Image, Bool) -> AnyView)? = nil,
        iconAnimationActive: Bool = true,
        primaryTitle: String? = nil,
        primaryAction: (() -> Void)? = nil,
        secondaryTitle: String? = nil,
        secondaryAction: (() -> Void)? = nil,
        autoDismissAfter: TimeInterval? = nil,
        onAutoDismiss: (() -> Void)? = nil
    ) -> some View {
        modifier(OculaAlertSheetPresenter(
            isPresented: isPresented,
            icon: icon,
            iconTint: iconTint,
            title: title,
            message: message,
            showsIconRing: showsIconRing,
            iconModifier: iconModifier,
            iconAnimator: iconAnimator,
            iconAnimationActive: iconAnimationActive,
            primaryTitle: primaryTitle,
            primaryAction: primaryAction,
            secondaryTitle: secondaryTitle,
            secondaryAction: secondaryAction,
            autoDismissAfter: autoDismissAfter,
            onAutoDismiss: onAutoDismiss
        ))
    }
}

// MARK: - Height Measuring (no UIKit needed)

private struct HeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        let n = nextValue()
        if n > value { value = n }
    }
}

private struct HeightReader: ViewModifier {
    let onChange: (CGFloat) -> Void
    func body(content: Content) -> some View {
        content.background(
            GeometryReader { proxy in
                Color.clear
                    .preference(key: HeightPreferenceKey.self, value: proxy.size.height)
            }
        )
        .onPreferenceChange(HeightPreferenceKey.self, perform: onChange)
    }
}

private extension View {
    func readHeight(_ onChange: @escaping (CGFloat) -> Void) -> some View {
        modifier(HeightReader(onChange: onChange))
    }
}

//: MARK - Examples for Preview
#Preview("Ocula Alert Sheet – Example") {
    PreviewHost()
}

private struct PreviewHost: View {
    @State private var show = true
    @State private var animateIcon = true
    
    var body: some View {
        Color.black
            .ignoresSafeArea()
            .oculaAlertSheet(
                isPresented: $show,
                icon: "info.bubble.fill",
                iconTint: .blue,
                title: "This page is currently unavailable.",
                message: "We're sorry for the inconvenience. We're working on it.",
                showsIconRing: false,                 // remove outer circle
                iconModifier: { image in               // base styling (optional)
                    AnyView(image.symbolRenderingMode(.hierarchical))
                },
                iconAnimator: { image, isActive in     // conditional animation
                    if #available(iOS 17.0, *) {
                        return AnyView(
                            image
                                .symbolEffect(.breathe)
                        )
                    } else {
                        return AnyView(image)
                    }
                },
                iconAnimationActive: animateIcon,      // condition
            )
    }
}
private struct PreviewHost2: View {
    @State private var show = true

    var body: some View {
        Color.black
            .ignoresSafeArea()
            .oculaAlertSheet(
                isPresented: $show,
                icon: "globe.badge.chevron.backward",
                iconTint: .green,
                title: "Success",
                message: "Connected to your device",
                showsIconRing: false,
                iconAnimator: { image, isActive in
                    if #available(iOS 17.0, *) {
                        return AnyView(
                            image.symbolEffect(.bounce.up.byLayer,
                                               options: .repeat(.continuous),
                                               isActive: isActive)
                        )
                    } else {
                        return AnyView(image)
                    }
                },
                iconAnimationActive: show,
                autoDismissAfter: 21
            )
    }
}
