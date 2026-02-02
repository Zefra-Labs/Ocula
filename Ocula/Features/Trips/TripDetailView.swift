//
//  TripDetailView.swift
//  Ocula
//
//  Created by Tyson Miles on 31/1/2026.
//
import SwiftUI
import MapKit

struct TripDetailView: View {

    let trip: Trip
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {

                // MARK: - Map Header
                TripMapHeader(trip: trip)
                    .frame(minHeight: 350, maxHeight: 450)

                // MARK: - Content
                VStack(spacing: 24) {
                    header
                    incidentsSection
                    clipsSection
                    safetyScoreSection
                }
                .padding()
                .padding(.top, 20)
                .background(
                    RoundedRectangle(cornerRadius: AppTheme.Radius.xxlg, style: .continuous)
                        .fill(.thinMaterial)
                )
                .offset(y: -28)
            }
        }
        .ignoresSafeArea(edges: .top)
        .navigationTitle("Trip Info")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button { shareTrip() } label: {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
    }
    //
    struct TripMapHeader: View {
        
        let trip: Trip
        @State private var cameraPosition: MapCameraPosition = .automatic
        
        var body: some View {
            Map(position: $cameraPosition, interactionModes: []) {
                MapPolyline(coordinates: trip.route)
                    .stroke(.black, lineWidth: 3)

                // START MARKER
                if let start = trip.route.first {
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
                if let end = trip.route.last {
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
            }
            .onAppear {
                fitRoute()
            }
        }

        
        private func fitRoute() {
            guard !trip.route.isEmpty else { return }
            
            let coordinates = trip.route
            
            let latitudes = coordinates.map { $0.latitude }
            let longitudes = coordinates.map { $0.longitude }
            
            let minLat = latitudes.min()!
            let maxLat = latitudes.max()!
            let minLon = longitudes.min()!
            let maxLon = longitudes.max()!
            
            let latitudeDelta = (maxLat - minLat) * 2.5
            let longitudeDelta = (maxLon - minLon) * 2.5
            
            // Move the center DOWN by 15% of the visible latitude
            let verticalOffset = latitudeDelta * -0.1
            
            let center = CLLocationCoordinate2D(
                latitude: ((minLat + maxLat) / 2) - verticalOffset,
                longitude: (minLon + maxLon) / 2
            )
            
            let span = MKCoordinateSpan(
                latitudeDelta: latitudeDelta,
                longitudeDelta: longitudeDelta
            )
            
            let region = MKCoordinateRegion(center: center, span: span)
            cameraPosition = .region(region)
        }
    }


    // MARK: - Header
    private var header: some View {
        VStack(alignment: .center, spacing: 6) {
            Text("\(trip.startLocationName) → \(trip.endLocationName)")
                .font(.title2.bold())

            Text("\(Int(trip.distanceKM)) km • \(trip.durationMinutes) mins • \(trip.endDate.relativeFormatted())")
                .foregroundStyle(.secondary)
        }
    }

    // MARK: - Incidents
    private var incidentsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Incidents")
                .font(.headline)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppTheme.Radius.lg) {
                    IncidentCard(title: "Hard Braking", count: trip.hardBraking, icon: "exclamationmark.triangle")
                    IncidentCard(title: "Acceleration", count: trip.hardAcceleration, icon: "speedometer")
                    IncidentCard(title: "Sharp Turns", count: trip.sharpTurns, icon: "arrow.triangle.turn.up.right.circle")
                }
            }
        }
    }

    // MARK: - Clips
    private var clipsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Clips")
                .font(.headline)

            RoundedRectangle(cornerRadius: 16)
                .fill(.black.opacity(0.4))
                .frame(height: 160)
                .overlay(Text("Drive Clips"))
        }
    }

    // MARK: - Safety
    private var safetyScoreSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Drive Score")
                .font(.headline)

            SafetyGauge(title: "Hard Braking", value: trip.hardBraking)
            SafetyGauge(title: "Acceleration", value: trip.hardAcceleration)
            SafetyGauge(title: "Sharp Turns", value: trip.sharpTurns)
        }
    }

    // MARK: - Share
    private func shareTrip() {
        let text = """
        Trip from \(trip.startLocationName) to \(trip.endLocationName)
        Distance: \(Int(trip.distanceKM)) km
        Duration: \(trip.durationMinutes) mins
        """
        let av = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
           let window = scene.windows.first(where: { $0.isKeyWindow }),
           let rootVC = window.rootViewController {
            rootVC.present(av, animated: true)
        }
    }
}


struct IncidentCard: View {
    let title: String
    let count: Int
    let icon: String

    var body: some View {
        HStack {
            Circle()
                .fill(count > 0 ? .orange : .green)
                .frame(width: 36, height: 36)
                .overlay(
                    Image(systemName: icon)
                        .fontWeight(.bold)
                )

            VStack(alignment: .leading) {
                Text(title)
                Text(count > 0 ? "\(count) detected" : "None detected")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: AppTheme.Radius.xlg))
    }
}
struct SafetyGauge: View {
    let title: String
    let value: Int

    var normalized: Double {
        min(Double(value) / 10.0, 1.0)
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.subheadline)

            Gauge(value: normalized) { }
                .gaugeStyle(.accessoryLinear)
                .tint(normalized > 0.6 ? .red : normalized > 0.3 ? .orange : .green)

            Text("\(value) incidents")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}
extension Date {
    func relativeFormatted() -> String {
        let calendar = Calendar.current
        if calendar.isDateInToday(self) { return formatted(date: .omitted, time: .shortened) }
        if calendar.isDateInYesterday(self) { return "Yesterday" }
        return formatted(.dateTime.weekday(.wide))
    }
}
