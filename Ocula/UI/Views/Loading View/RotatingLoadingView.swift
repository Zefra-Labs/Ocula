//
//  RotatingLoadingView.swift
//  Ocula
//
//  Created by Tyson Miles on 3/2/2026.
//


import SwiftUI

struct RotatingLoadingView: View {
    private let size: CGFloat = 50
    private let duration: Double = 1.0

    @State private var angle: Double = 0

    var body: some View {
        Image("loadingSymbol")
            .resizable()
            .renderingMode(.original)
            .scaledToFit()
            .frame(width: size, height: size)
            .rotationEffect(.degrees(angle))
            .task {
                // Reset, then start a forever-rotation animation explicitly
                angle = 10
                withAnimation(.linear(duration: duration).repeatForever(autoreverses: false)) {
                    angle = 360
                }
            }
            .accessibilityLabel("Loading")
    }
}
