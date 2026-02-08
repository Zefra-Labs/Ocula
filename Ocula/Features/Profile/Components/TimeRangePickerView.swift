//
//  TimeRangePickerView.swift
//  Ocula
//
//  Created by Tyson Miles on 7/2/2026.
//

import SwiftUI

struct TimeRangePickerView: View {
    @Binding var selection: ProfileTimeRange

    var body: some View {
        Picker("Time Range", selection: $selection) {
            ForEach(ProfileTimeRange.allCases) { range in
                Text(range.shortLabel)
                    .tag(range)
            }
        }
        .pickerStyle(.segmented)
    }
}
