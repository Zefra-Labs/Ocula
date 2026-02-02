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
            // Start
            MapPolyline(coordinates: selectedTrip.route)
                .stroke(.black, lineWidth: 3)

            // START MARKER
            if let start = selectedTrip.route.first {
                Annotation("", coordinate: start) {
                    Circle()
                        .fill(.white)
                        .frame(width: 10, height: 10)
                        .overlay(
                            Circle()
                                .stroke(.black, lineWidth: 3)
                        )
                        .shadow(radius: 1)
                }
            }

            // END MARKER
            if let end = selectedTrip.route.last {
                Annotation("", coordinate: end) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(.white)
                        .frame(width: 10, height: 10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 2)
                                .stroke(.black, lineWidth: 3)
                        )
                        .shadow(radius: 1)
                }
            }
            
            // Apple blue dot
            UserAnnotation()
            
        }
        .ignoresSafeArea()
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

enum TripsSheetDetent: CaseIterable {
    case collapsed
    case large

    func height(availableHeight: CGFloat) -> CGFloat {
        switch self {
        case .collapsed:
            return max(70, availableHeight * 0.12)
        case .large:
            return availableHeight * 0.75
        }
    }
}
struct TripsBottomSheet: View {

    @Binding var trips: [Trip]
    @Binding var selectedTrip: Trip
    @Binding var detent: TripsSheetDetent
    @Binding var showTripDetail: Bool

    @State private var searchText: String = ""
    @FocusState private var isSearchFocused: Bool

    private var filteredTrips: [Trip] {
        guard !searchText.isEmpty else { return trips }

        return trips.filter {
            $0.startLocationName.localizedCaseInsensitiveContains(searchText) ||
            $0.endLocationName.localizedCaseInsensitiveContains(searchText) ||
            $0.dateString.localizedCaseInsensitiveContains(searchText) ||
            $0.timeRangeString.localizedCaseInsensitiveContains(searchText) ||
            "\(Int($0.distanceKM)) km".localizedCaseInsensitiveContains(searchText) ||
            "\($0.durationMinutes) mins".localizedCaseInsensitiveContains(searchText)
        }
    }

    private var isCollapsed: Bool {
        detent == .collapsed
    }
    var body: some View {
        VStack(spacing: 16) {

            // LAST TRIP (always visible)
            if !(isSearchFocused && !isCollapsed) {
                VStack(alignment: .leading, spacing: 8) {
                    if isCollapsed {
                        HStack {
                            LastTripCompactRow(trip: selectedTrip) {
                                showTripDetail = true
                            }
                            .padding(.top, AppTheme.Spacing.sm)
                            .padding(.bottom, AppTheme.Spacing.lg)
                            Spacer()
                        }
                    } else {
                        Text("Last Trip")
                            .title2Style()
                            .foregroundStyle(AppTheme.Colors.secondary)

                        LastTripCompactRow(trip: selectedTrip) {
                            showTripDetail = true
                        }
                    }
                }
            }

            // EVERYTHING ELSE hidden at lowest detent//
            if !isCollapsed {

                Divider()

                VStack(alignment: .leading, spacing: 12) {

                    Text("Recent Trips")
                        .title2Style()
                        .foregroundStyle(AppTheme.Colors.secondary)

                    SearchField(text: $searchText, placeholder: "Search Trips", isFocused: $isSearchFocused)

                    ScrollView {
                        VStack(alignment: .leading, spacing: 12) {
                            ForEach(filteredTrips) { trip in
                        TripRow(
                            trip: trip,
                            isStarred: trip.isStarred,
                            onStar: toggleStar,
                            onTap: {
                                selectedTrip = trip
                                showTripDetail = true
                            }
                        )
                            }

                            if filteredTrips.isEmpty {
                                ContentUnavailableView.search
                            }
                        }
                    }
                }
            }
        }
        .padding(.top)
        .padding(.horizontal)
        
    }


    private func toggleStar(_ trip: Trip) {
        if let index = trips.firstIndex(of: trip) {
            trips[index].isStarred.toggle()
            if selectedTrip.id == trip.id {
                selectedTrip = trips[index]
            }
        }
    }
}
struct LastTripCompactRow: View {

    let trip: Trip
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {

                Image(systemName: "clock.arrow.circlepath")
                    .title2Style()
                    .foregroundStyle(AppTheme.Colors.primary)

                VStack(alignment: .leading, spacing: 2) {
                    Text("\(trip.startLocationName) → \(trip.endLocationName)")
                        .headlineBoldStyle()
                        .foregroundStyle(AppTheme.Colors.primary)

                    Text(meta)
                        .subheadline()
                        .foregroundColor(AppTheme.Colors.secondary)
                        .lineLimit(1)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(AppTheme.Colors.secondary)
            }
            .padding(.top, AppTheme.Spacing.md)
            .padding(.bottom, AppTheme.Spacing.md)
            .contentShape(RoundedRectangle(cornerRadius: AppTheme.Radius.xlg, style: .continuous))
        }
        .buttonStyle(.plain)
        
    }
    private var meta: String {
        "\(Int(trip.distanceKM)) km  •  \(trip.durationMinutes) mins  •  \(trip.endDate.relativeFormatted())"
    }
}

struct SearchField: View {
    @Binding var text: String
    let placeholder: String
    @FocusState.Binding var isFocused: Bool

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(AppTheme.Colors.secondary)

            TextField(placeholder, text: $text)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .focused($isFocused)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.Radius.mdlg, style: .continuous)
                .fill(AppTheme.Colors.primary.opacity(0.08))
        )
    }
}


struct TripRow: View {

    let trip: Trip
    let isStarred: Bool
    let onStar: (Trip) -> Void
    let onTap: () -> Void

    var body: some View {
        Button {
            onTap()
        } label: {
            HStack(spacing: 16) {

                VStack(alignment: .leading, spacing: 4) {
                    Text("\(trip.startLocationName) → \(trip.endLocationName)")
                        .headlineStyle()
                        .foregroundColor(AppTheme.Colors.primary)
                        .lineLimit(1)

                    Text(meta)
                        .subheadline()
                        .foregroundColor(AppTheme.Colors.secondary)
                        .lineLimit(1)
                }

                Spacer()

                // Star (secondary action)
                Button {
                    onStar(trip)
                } label: {
                    Image(systemName: isStarred ? "star.fill" : "star")
                        .foregroundStyle(isStarred ? .yellow : AppTheme.Colors.secondary)
                }
                .buttonStyle(.plain)

                Image(systemName: "chevron.right")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(AppTheme.Colors.secondary)
            }
            .padding(AppTheme.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.Radius.xlg)
                    .fill(AppTheme.Colors.primary.opacity(0.08))
            )
        }
        .buttonStyle(PressableRowStyle())
    }

    private var meta: String {
        "\(Int(trip.distanceKM)) km  •  \(trip.durationMinutes) mins  •  \(trip.endDate.relativeFormatted())"
    }
}
extension Trip {

    static func mockTrips() -> [Trip] {

        let now = Date()

        let baseRoute = [
            CLLocationCoordinate2D(latitude: -28.0116, longitude: 153.4052),
            CLLocationCoordinate2D(latitude: -28.0408, longitude: 153.3991),
            CLLocationCoordinate2D(latitude: -28.0700, longitude: 153.3930),
            CLLocationCoordinate2D(latitude: -28.0780, longitude: 153.4075),
            CLLocationCoordinate2D(latitude: -28.0860, longitude: 153.4220),
            CLLocationCoordinate2D(latitude: -28.0930, longitude: 153.4310),
            CLLocationCoordinate2D(latitude: -28.1000, longitude: 153.4400)
        ]

        return [
            Trip(
                id: UUID(),
                startLocationName: "Burleigh",
                endLocationName: "Bundall",
                startDate: now.addingTimeInterval(-3600),
                endDate: now,
                distanceKM: 44,
                durationMinutes: 45,
                route: baseRoute,
                hardBraking: 3,
                hardAcceleration: 1,
                sharpTurns: 2
            ),
            Trip(
                id: UUID(),
                startLocationName: "Miami",
                endLocationName: "Ashmore",
                startDate: now.addingTimeInterval(-7200),
                endDate: now.addingTimeInterval(-3600),
                distanceKM: 32,
                durationMinutes: 38,
                route: baseRoute,
                hardBraking: 1,
                hardAcceleration: 0,
                sharpTurns: 1
            ),
            Trip(
                id: UUID(),
                startLocationName: "Burleigh",
                endLocationName: "Southport",
                startDate: now.addingTimeInterval(-7200),
                endDate: now.addingTimeInterval(-3600),
                distanceKM: 32,
                durationMinutes: 38,
                route: baseRoute,
                hardBraking: 1,
                hardAcceleration: 0,
                sharpTurns: 1
            ),
            Trip(
                id: UUID(),
                startLocationName: "Arundel",
                endLocationName: "Southport",
                startDate: now.addingTimeInterval(-7200),
                endDate: now.addingTimeInterval(-3600),
                distanceKM: 32,
                durationMinutes: 38,
                route: baseRoute,
                hardBraking: 1,
                hardAcceleration: 0,
                sharpTurns: 1
            )
        ]
    }
}




#Preview {
    TripsView()
}
