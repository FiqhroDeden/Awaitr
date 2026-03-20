//
//  DashboardView.swift
//  Awaitr
//

import SwiftUI
import SwiftData

struct DashboardView: View {
    @Query(filter: WaitItem.activePredicate) private var activeItems: [WaitItem]
    @State private var viewModel: DashboardViewModel?
    @Environment(\.modelContext) private var modelContext

    let path: Binding<NavigationPath>
    let onAddTapped: () -> Void

    var body: some View {
        NavigationStack(path: path) {
            ScrollView {
                LazyVStack(spacing: Theme.Spacing.lg) {
                    if activeItems.isEmpty {
                        emptyState
                    } else {
                        Text("Your Waitlist")
                            .font(Theme.Typography.sectionHeader)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)

                        ForEach(viewModel?.filteredItems(from: activeItems) ?? activeItems) { item in
                            NavigationLink(value: AppDestination.itemDetail(item)) {
                                Text(item.title)
                                    .font(Theme.Typography.cardTitle)
                                    .foregroundStyle(Theme.TextColors.dark)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding()
                                    .glassCard()
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.top)
            }
            .navigationTitle("Awaitr")
            .navigationDestination(for: AppDestination.self) { destination in
                switch destination {
                case .itemDetail(let item):
                    ItemDetailView(item: item)
                case .editItem(let item):
                    AddEditItemView(item: item)
                }
            }
        }
        .task {
            if viewModel == nil {
                viewModel = DashboardViewModel(modelContext: modelContext)
            }
        }
    }

    // MARK: - Empty State

    private var emptyState: some View {
        VStack(spacing: Theme.Spacing.lg) {
            Spacer().frame(height: 60)
            Image(systemName: "tray")
                .font(.system(size: 48))
                .foregroundStyle(Theme.TextColors.muted)
            Text("Nothing to wait for!")
                .font(Theme.Typography.sectionHeader)
                .foregroundStyle(Theme.TextColors.dark)
            Text("Tap + to add your first item")
                .font(Theme.Typography.body)
                .foregroundStyle(Theme.TextColors.muted)
            Button("Add Item", action: onAddTapped)
                .buttonStyle(.borderedProminent)
                .tint(Theme.CategoryColors.job)
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}
