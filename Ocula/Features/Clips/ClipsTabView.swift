//
//  ClipsTabView.swift
//  Ocula
//
//  Created by Tyson Miles on 26/1/2026.
//


import SwiftUI

struct ClipsView: View {
    var body: some View {
        navigationTitle("All Clips")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { print("Pressed") } label: {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
        }
    }

#Preview {
    ClipsView()
}
