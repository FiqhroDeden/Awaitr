//
//  ArchiveView.swift
//  Awaitr
//

import SwiftUI
import SwiftData

struct ArchiveView: View {
    @Query(filter: WaitItem.archivedPredicate) private var archivedItems: [WaitItem]
    @State private var viewModel: ArchiveViewModel?
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationStack {
            ScrollView {
                if archivedItems.isEmpty {
                    emptyArchive
                } else {
                    LazyVStack(spacing: Theme.Spacing.md) {
                        ForEach(archivedItems) { item in
                            archiveRow(item)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Archive")
        }
        .task {
            if viewModel == nil {
                viewModel = ArchiveViewModel(modelContext: modelContext)
            }
        }
    }

    // MARK: - Row

    private func archiveRow(_ item: WaitItem) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(Theme.Typography.cardTitle)
                    .foregroundStyle(Theme.TextColors.dark)
                StatusBadge(status: item.status)
            }
            Spacer()
            CategoryBadge(category: item.category)
        }
        .padding()
        .glassCard()
    }

    // MARK: - Empty

    private var emptyArchive: some View {
        VStack(spacing: Theme.Spacing.lg) {
            Spacer().frame(height: 80)
            Image(systemName: "archivebox")
                .font(.system(size: 48))
                .foregroundStyle(Theme.TextColors.muted)
            Text("No archived items yet")
                .font(Theme.Typography.sectionHeader)
                .foregroundStyle(Theme.TextColors.dark)
        }
        .frame(maxWidth: .infinity)
    }
}
