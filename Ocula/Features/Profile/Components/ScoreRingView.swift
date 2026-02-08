//
//  ScoreRingView.swift
//  Ocula
//
//  Created by Tyson Miles on 7/2/2026.
//

import SwiftUI

struct ScoreRingView: View {
    let score: Int
    let size: CGFloat
    let lineWidth: CGFloat

    @State private var progress: CGFloat = 0

    private var clampedScore: Int {
        min(max(score, 0), 100)
    }

    private var ringColor: Color {
        SafetyScoreStyle.color(for: clampedScore)
    }

    private var ringGradient: AngularGradient {
        AngularGradient(
            gradient: Gradient(colors: [ringColor.opacity(0.6), ringColor, ringColor.opacity(0.9)]),
            center: .center
        )
    }

    var body: some View {
        ZStack {
            Circle()
                .stroke(AppTheme.Colors.surfaceDark.opacity(0.35), lineWidth: lineWidth)

            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    ringGradient,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round)
                )
                .rotationEffect(.degrees(-90))
                .shadow(color: ringColor.opacity(0.35), radius: 6, x: 0, y: 3)

            VStack(spacing: 4) {
                Text("\(clampedScore)")
                    .font(AppTheme.Fonts.bold(size * 0.28))
                    .monospacedDigit()
                    .foregroundColor(AppTheme.Colors.primary)

                Text("Driver Score")
                    .font(AppTheme.Fonts.semibold(size * 0.12))
                    .foregroundColor(AppTheme.Colors.secondary)
            }
        }
        .frame(width: size, height: size)
        .onAppear {
            withAnimation(.easeOut(duration: 1.1)) {
                progress = CGFloat(clampedScore) / 100
            }
        }
        .onChange(of: score) { newValue in
            withAnimation(.easeOut(duration: 1.1)) {
                progress = CGFloat(min(max(newValue, 0), 100)) / 100
            }
        }
    }
}
