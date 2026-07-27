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
            VStack(spacing: .zero) {
                displayView
                keyboardView
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        // Add leading button action here. 
                    } label: {
                        Image(systemName: "line.3.horizontal")
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        // Add trailing button action here.
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
    var displayView: some View {
        VStack(spacing: .zero) {
            DisplayView(type: .due)
            DisplayView(type: .tip)
            DisplayView(type: .total)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .border(Color.blue)
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
