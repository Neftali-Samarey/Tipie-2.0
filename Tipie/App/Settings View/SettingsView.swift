//
//  SettingsView.swift
//  Tipie
//
//  Created by Neftali Samarey on 8/4/26.
//

import StoreKit
import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.requestReview) private var requestReview

    var body: some View {
        NavigationStack {
            List {
                Section(StringLegend.general.value) {
                    NavigationLink {
                        AboutView()
                    } label: {
                        Label(StringLegend.about.value, systemImage: Icons.about.value)
                    }

                    Button {
                        HapticFeedbackService.vibrate(.selection)
                        requestReview()
                    } label: {
                        Label(StringLegend.rateApp.value, systemImage: Icons.rate.value)
                    }
                    .foregroundStyle(.primary)
                }
            }
            .navigationTitle(StringLegend.settings.value)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(StringLegend.done.value) {
                        HapticFeedbackService.vibrate(.selection)
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
}

// MARK: - About

private struct AboutView: View {
    private var appName: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
            ?? Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String
            ?? "Tipie"
    }

    private var version: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "—"
    }

    private var build: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "—"
    }

    var body: some View {
        List {
            Section {
                VStack(spacing: 12) {
                    Image("TipieIcon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 72, height: 72)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

                    Text(appName)
                        .font(.title2.weight(.semibold))

                    Text(StringLegend.aboutTagline.value)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .listRowBackground(Color.clear)
            }

            Section {
                LabeledContent(StringLegend.version.value, value: version)
                LabeledContent(StringLegend.build.value, value: build)
            }
        }
        .navigationTitle(StringLegend.about.value)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    SettingsView()
}
