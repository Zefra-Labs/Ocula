//
//  TripsTabView.swift
//  Ocula
//
//  Created by Tyson Miles on 26/1/2026.
//

import SwiftUI
import MapKit

struct TripsView: View {

    @State private var trips: [Trip] = Trip.mockTrips()
    @State private var selectedTrip: Trip = Trip.mockTrips().first!
    @State private var detent: TripsSheetDetent = .collapsed
    @State private var showTripDetail = false

    var body: some View {
        NavigationStack {
            GeometryReader { proxy in
                ZStack(alignment: .bottom) {
                    mapLayer
                        .allowsHitTesting(detent != .large)
                    TripsBottomSheet(
                        trips: $trips,
                        selectedTrip: $selectedTrip,
                        detent: $detent,
                        showTripDetail: $showTripDetail
                    )
                    .frame(height: sheetHeight(in: proxy))
                    .frame(maxWidth: .infinity)
                    .glassEffect(in: .rect(cornerRadius: AppTheme.Radius.xxlg))
                    .overlay(alignment: .top) {
                        Capsule()
                            .fill(AppTheme.Colors.secondary.opacity(0.45))
                            .frame(width: 36, height: 4)
                            .padding(.top, AppTheme.Spacing.sm)
                    }
                    .padding(.horizontal, AppTheme.Spacing.md)
                    .padding(.bottom, 10)
                    .gesture(sheetDragGesture(in: proxy))
                    .animation(.spring(response: 0.35, dampingFraction: 0.85), value: detent)
                }
            }
            .navigationDestination(isPresented: $showTripDetail) {
                TripDetailView(trip: selectedTrip)
            }
        }
    }

    // MARK: - Map
    private var mapLayer: some View {
        Map {
            MapPolyline(coordinates: selectedTrip.route)
                .stroke(.black, lineWidth: 3)

            if let start = selectedTrip.route.first {
                Annotation("", coordinate: start) {
                    Circle()
                        .fill(.white)
                        .frame(width: 10, height: 10)
                        .overlay(Circle().stroke(.black, lineWidth: 3))
                }
            }

            if let end = selectedTrip.route.last {
                Annotation("", coordinate: end) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(.white)
                        .frame(width: 10, height: 10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 2)
                                .stroke(.black, lineWidth: 3)
                        )
                }
            }

            UserAnnotation()
        }
        .ignoresSafeArea(edges: .top)
    }
    
    private func availableHeight(in proxy: GeometryProxy) -> CGFloat {
        proxy.size.height
    }

    private func sheetHeight(in proxy: GeometryProxy) -> CGFloat {
        detent.height(availableHeight: availableHeight(in: proxy))
    }

    private func sheetDragGesture(in proxy: GeometryProxy) -> some Gesture {
        let threshold: CGFloat = 80

        return DragGesture(minimumDistance: 2)
            .onEnded { value in
                let translation = value.translation.height

                if translation < -threshold && detent == .collapsed {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                        detent = .large
                    }
                } else if translation > threshold && detent == .large {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                        detent = .collapsed
                    }
                }
            }
    }
}

#Preview {
    TripsView()
}
