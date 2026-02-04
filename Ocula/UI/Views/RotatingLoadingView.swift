import SwiftUI

struct RotatingLoadingView: View {
    private let size: CGFloat = 50
    private let rotationDuration: Double = 2.0

    @State private var isAnimating = false

    var body: some View {
        Image("loadingSymbol")
            .resizable()
            .renderingMode(.original)
            .scaledToFit()
            .frame(width: size, height: size)
            .rotationEffect(.degrees(isAnimating ? 360 : 0))
            .animation(
                .linear(duration: rotationDuration)
                    .repeatForever(autoreverses: false),
                value: isAnimating
            )
            .onAppear {
                isAnimating = true
            }
            .onDisappear {
                isAnimating = false
            }
            .accessibilityLabel("Loading")
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        RotatingLoadingView()
    }
}
