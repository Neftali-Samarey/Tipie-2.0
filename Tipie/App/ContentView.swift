//
//  ContentView.swift
//  Tipie
//
//  Created by Neftali Samarey on 7/27/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack(spacing: .zero) {
                    displaySegmentView
                        .frame(height: geometry.size.height * 0.4)
                    keyboardView
                        .frame(height: geometry.size.height * 0.6)
                }
                .frame(
                    width: geometry.size.width,
                    height: geometry.size.height
                )
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                    } label: {
                        Image(systemName: "line.3.horizontal")
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}

// MARK: Display

fileprivate extension ContentView {
    var displaySegmentView: some View {
        VStack(spacing: .zero) {
            VStack(spacing: .zero) {
                DisplayView(type: .due)
                DisplayView(type: .tip)
                DisplayView(type: .total)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .layoutPriority(1)
            .border(Color.blue)

            tipPresetsView
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: Tip Presets

fileprivate extension ContentView {
    var tipPresetsView: some View {
        HStack(spacing: .zero) {
            tipPreset("15%")
            tipPreset("18%")
            tipPreset("20%")
            tipPreset("Custom")
        }
    }

    @ViewBuilder
    private func tipPreset(_ title: String) -> some View {
        Text(title)
            .frame(maxWidth: .infinity, minHeight: 56)
            .padding(.vertical, 12)
            .overlay(
                RoundedRectangle(cornerRadius: .zero)
                    .stroke(.red)
            )
    }
}

// MARK: Keyboard

fileprivate extension ContentView {
    var keyboardView: some View {
        VStack(spacing: .zero) {
            Text("Keyboard")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .border(Color.red)
    }
}

#Preview {
    ContentView()
}
