//
//  BreakdownInsightsSheet.swift
//  Ocula
//
//  Created by Tyson Miles on 7/2/2026.
//

import SwiftUI

struct BreakdownInsightsSheet: View {
    let metric: DrivingMetric

    @State private var timeframe: InsightTimeframe = .last7Days
    @State private var showInfo = false

    var body: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            HStack {
                Text("Insights")
                    .title2Style()
                    .foregroundColor(AppTheme.Colors.secondary)

                Spacer()

                Button {
                    showInfo = true
                } label: {
                    Image(systemName: "info.circle")
                        .foregroundColor(AppTheme.Colors.secondary)
                        .font(.title3)
                }
            }

            VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                Text(metric.title)
                    .headlineBoldStyle()

                Text(metric.insight)
                    .captionStyle()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        .padding(AppTheme.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.Radius.xlg)
                .fill(AppTheme.Colors.primary.opacity(0.08))
        )

            VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                Text("Trend")
                    .headlineStyle()

                InsightDotGraph(values: trendValues(for: timeframe))
                    .frame(height: 70)

                Picker("Timeframe", selection: $timeframe) {
                    ForEach(InsightTimeframe.allCases) { range in
                        Text(range.label).tag(range)
                    }
                }
                .pickerStyle(.segmented)
            }

            Spacer(minLength: 0)
        }
        .padding(.horizontal, AppTheme.Spacing.md)
        .padding(.top, AppTheme.Spacing.md)
        .alert("Insights", isPresented: $showInfo) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Insights compare your driving patterns over time to highlight the biggest changes and opportunities.")
        }
    }
}

private enum InsightTimeframe: String, CaseIterable, Identifiable {
    case last7Days
    case last30Days
    case last90Days

    var id: String { rawValue }

    var label: String {
        switch self {
        case .last7Days: return "7D"
        case .last30Days: return "30D"
        case .last90Days: return "90D"
        }
    }
}

private extension BreakdownInsightsSheet {
    func trendValues(for timeframe: InsightTimeframe) -> [CGFloat] {
        switch timeframe {
        case .last7Days:
            return [0.2, 0.45, 0.4, 0.7, 0.65, 0.8, 0.6]
        case .last30Days:
            return [0.3, 0.35, 0.55, 0.5, 0.7, 0.6, 0.75, 0.8, 0.65, 0.7]
        case .last90Days:
            return [0.2, 0.3, 0.25, 0.4, 0.5, 0.6, 0.55, 0.7, 0.8, 0.75, 0.9, 0.85]
        }
    }
}

private struct InsightDotGraph: View {
    let values: [CGFloat]

    var body: some View {
        GeometryReader { proxy in
            let height = proxy.size.height
            let width = proxy.size.width
            let step = values.count > 1 ? width / CGFloat(values.count - 1) : 0

            ZStack(alignment: .bottomLeading) {
                Capsule()
                    .fill(AppTheme.Colors.surfaceDark.opacity(0.4))
                    .frame(height: 2)
                    .padding(.top, height / 2)

                Path { path in
                    for index in values.indices {
                        let x = CGFloat(index) * step
                        let y = height - (values[index] * (height - 12)) - 6
                        if index == 0 {
                            path.move(to: CGPoint(x: x, y: y))
                        } else {
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                    }
                }
                .stroke(AppTheme.Colors.primary.opacity(0.4), lineWidth: 2)

                ForEach(values.indices, id: \.self) { index in
                    let x = CGFloat(index) * step
                    let y = height - (values[index] * (height - 12)) - 6
                    Circle()
                        .fill(AppTheme.Colors.primary)
                        .frame(width: 8, height: 8)
                        .position(x: x, y: y)
                }
            }
        }
    }
}
