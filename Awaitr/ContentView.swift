//
//  ContentView.swift
//  Awaitr
//
//  Created by ZoldyckD on 20/03/26.
//

import SwiftUI

// MARK: - Tab Definition

enum AppTab: String, CaseIterable, Identifiable {
    case home
    case archive
    case settings

    var id: String { rawValue }

    var label: LocalizedStringKey {
        switch self {
        case .home: "Home"
        case .archive: "Archive"
        case .settings: "Settings"
        }
    }

    var systemImage: String {
        switch self {
        case .home: "house.fill"
        case .archive: "archivebox.fill"
        case .settings: "gearshape.fill"
        }
    }
}

// MARK: - Content View

struct ContentView: View {
    @State private var selectedTab: AppTab = .home
    @State private var navigationPath = NavigationPath()
    @State private var showAddSheet = false

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            TabView(selection: $selectedTab) {
                Tab(value: .home) {
                    DashboardView(path: $navigationPath, onAddTapped: { showAddSheet = true })
                } label: {
                    Label(AppTab.home.label, systemImage: AppTab.home.systemImage)
                }

                Tab(value: .archive) {
                    ArchiveView()
                } label: {
                    Label(AppTab.archive.label, systemImage: AppTab.archive.systemImage)
                }

                Tab(value: .settings) {
                    SettingsView()
                } label: {
                    Label(AppTab.settings.label, systemImage: AppTab.settings.systemImage)
                }
            }
            .tabViewStyle(.automatic)

            if selectedTab == .home {
                FABButton { showAddSheet = true }
                    .padding(.trailing, Theme.Spacing.xl)
                    .padding(.bottom, 80)
            }
        }
        .sheet(isPresented: $showAddSheet) {
            AddEditItemView()
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: WaitItem.self, inMemory: true)
}
