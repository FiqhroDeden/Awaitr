//
//  ItemDetailView.swift
//  Awaitr
//

import SwiftUI
import SwiftData

struct ItemDetailView: View {
    let item: WaitItem
    @State private var viewModel: ItemDetailViewModel?
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var showDeleteConfirmation = false

    var body: some View {
        ScrollView {
            VStack(spacing: Theme.Spacing.lg) {
                headerSection
                infoSection
                notesSection
                actionsSection
            }
            .padding()
        }
        .navigationTitle(item.title)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            if viewModel == nil {
                viewModel = ItemDetailViewModel(item: item, modelContext: modelContext)
            }
        }
        .confirmationDialog("Delete Item?", isPresented: $showDeleteConfirmation) {
            Button("Delete", role: .destructive) {
                viewModel?.deleteItem()
                dismiss()
            }
        } message: {
            Text("This will permanently delete this item.")
        }
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(spacing: Theme.Spacing.sm) {
            HStack {
                CategoryBadge(category: item.category)
                Spacer()
                StatusBadge(status: item.status)
            }
            HStack {
                PriorityDot(priority: item.priority)
                Text(item.daysWaitingLabel)
                    .font(Theme.Typography.caption)
                    .foregroundStyle(Theme.TextColors.muted)
                Spacer()
            }
        }
        .padding()
        .glassCard()
    }

    // MARK: - Info

    private var infoSection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            infoRow("Submitted", value: item.submittedAt.shortFormatted)
            if let expected = item.expectedAt {
                infoRow("Expected", value: expected.shortFormatted)
            }
            if let followUp = item.followUpAt {
                infoRow("Follow-up", value: followUp.shortFormatted)
            }
        }
        .padding()
        .glassCard()
    }

    private func infoRow(_ label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(Theme.Typography.caption)
                .foregroundStyle(Theme.TextColors.muted)
            Spacer()
            Text(value)
                .font(Theme.Typography.body)
                .foregroundStyle(Theme.TextColors.dark)
        }
    }

    // MARK: - Notes

    private var notesSection: some View {
        Group {
            if !item.notes.isEmpty {
                VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                    Text("Notes")
                        .font(Theme.Typography.caption)
                        .foregroundStyle(Theme.TextColors.muted)
                    Text(item.notes)
                        .font(Theme.Typography.body)
                        .foregroundStyle(Theme.TextColors.dark)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .glassCard()
            }
        }
    }

    // MARK: - Actions

    private var actionsSection: some View {
        VStack(spacing: Theme.Spacing.sm) {
            if !item.status.isTerminal {
                if let next = item.status.nextStatus {
                    Button {
                        withAnimation(Theme.Animations.springMedium) {
                            viewModel?.advanceStatus()
                        }
                    } label: {
                        Label("Advance to \(next.label)", systemImage: "arrow.right.circle.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Theme.CategoryColors.job)
                }

                Button {
                    withAnimation(Theme.Animations.springMedium) {
                        viewModel?.rejectItem()
                    }
                } label: {
                    Label("Mark as Rejected", systemImage: "xmark.circle.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .tint(.red)
            }

            if !item.isArchived {
                Button {
                    viewModel?.archiveItem()
                    dismiss()
                } label: {
                    Label("Archive", systemImage: "archivebox.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }

            Button(role: .destructive) {
                showDeleteConfirmation = true
            } label: {
                Label("Delete", systemImage: "trash.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
        }
    }
}
