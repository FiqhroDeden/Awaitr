//
//  SettingsView.swift
//  Awaitr
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @State private var viewModel: SettingsViewModel?
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationStack {
            List {
                notificationsSection
                exportSection
                dangerSection
                aboutSection
            }
            .navigationTitle("Settings")
        }
        .task {
            if viewModel == nil {
                viewModel = SettingsViewModel(modelContext: modelContext)
            }
            await viewModel?.checkNotificationStatus()
        }
    }

    // MARK: - Sections

    private var notificationsSection: some View {
        Section("Notifications") {
            HStack {
                Label("Reminders", systemImage: "bell.fill")
                Spacer()
                Text(viewModel?.notificationsEnabled == true ? "Enabled" : "Disabled")
                    .foregroundStyle(Theme.TextColors.muted)
            }
        }
    }

    private var exportSection: some View {
        Section("Data") {
            Button {
                guard let csv = viewModel?.exportCSV() else { return }
                let activityVC = UIActivityViewController(
                    activityItems: [csv],
                    applicationActivities: nil
                )
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let root = windowScene.keyWindow?.rootViewController {
                    root.present(activityVC, animated: true)
                }
            } label: {
                Label("Export to CSV", systemImage: "square.and.arrow.up")
            }
        }
    }

    private var dangerSection: some View {
        Section("Danger Zone") {
            Button(role: .destructive) {
                viewModel?.showClearConfirmation = true
            } label: {
                Label("Clear All Data", systemImage: "trash.fill")
            }
            .confirmationDialog(
                "Are you sure?",
                isPresented: Binding(
                    get: { viewModel?.showClearConfirmation ?? false },
                    set: { viewModel?.showClearConfirmation = $0 }
                ),
                titleVisibility: .visible
            ) {
                Button("Delete Everything", role: .destructive) {
                    viewModel?.clearAllData()
                }
            } message: {
                Text("This will permanently delete all items. This cannot be undone.")
            }
        }
    }

    private var aboutSection: some View {
        Section("About") {
            HStack {
                Text("Version")
                Spacer()
                Text("1.0.0")
                    .foregroundStyle(Theme.TextColors.muted)
            }
        }
    }
}
