//
//  AddEditItemView.swift
//  Awaitr
//

import SwiftUI
import SwiftData

struct AddEditItemView: View {
    @State private var viewModel: AddEditViewModel?
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let item: WaitItem?

    init(item: WaitItem? = nil) {
        self.item = item
    }

    var body: some View {
        NavigationStack {
            Group {
                if let viewModel {
                    formContent(viewModel)
                } else {
                    ProgressView()
                }
            }
            .navigationTitle(item != nil ? "Edit Item" : "New Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        Task {
                            await viewModel?.save()
                            dismiss()
                        }
                    }
                    .disabled(viewModel?.isValid != true)
                }
            }
        }
        .task {
            if viewModel == nil {
                if let item {
                    viewModel = AddEditViewModel(item: item, modelContext: modelContext)
                } else {
                    viewModel = AddEditViewModel(modelContext: modelContext)
                }
            }
        }
    }

    // MARK: - Form

    @ViewBuilder
    private func formContent(_ vm: AddEditViewModel) -> some View {
        Form {
            titleSection(vm)
            categorySection(vm)
            datesSection(vm)
            prioritySection(vm)
            notesSection(vm)
        }
    }

    private func titleSection(_ vm: AddEditViewModel) -> some View {
        Section("Title") {
            TextField("What are you waiting for?", text: Binding(
                get: { vm.title },
                set: { vm.title = $0 }
            ))
            .textInputAutocapitalization(.sentences)
            Text("\(vm.titleCharacterCount)/80")
                .font(Theme.Typography.caption)
                .foregroundStyle(vm.titleCharacterCount > 80 ? .red : Theme.TextColors.muted)
        }
    }

    private func categorySection(_ vm: AddEditViewModel) -> some View {
        Section("Category") {
            Picker("Category", selection: Binding(
                get: { vm.category },
                set: { vm.category = $0 }
            )) {
                ForEach(WaitCategory.allCases) { cat in
                    Text("\(cat.emoji) \(cat.shortLabel)").tag(cat)
                }
            }
            .pickerStyle(.segmented)
        }
    }

    private func datesSection(_ vm: AddEditViewModel) -> some View {
        Section("Dates") {
            DatePicker("Submitted", selection: Binding(
                get: { vm.submittedAt },
                set: { vm.submittedAt = $0 }
            ), displayedComponents: .date)

            Toggle("Expected date", isOn: Binding(
                get: { vm.hasExpectedDate },
                set: { vm.hasExpectedDate = $0 }
            ))
            if vm.hasExpectedDate {
                DatePicker("Expected", selection: Binding(
                    get: { vm.expectedAt ?? .now },
                    set: { vm.expectedAt = $0 }
                ), displayedComponents: .date)
            }

            Toggle("Follow-up reminder", isOn: Binding(
                get: { vm.hasFollowUpDate },
                set: { vm.hasFollowUpDate = $0 }
            ))
            if vm.hasFollowUpDate {
                DatePicker("Follow-up", selection: Binding(
                    get: { vm.followUpAt ?? .now },
                    set: { vm.followUpAt = $0 }
                ))
            }
        }
    }

    private func prioritySection(_ vm: AddEditViewModel) -> some View {
        Section("Priority") {
            Picker("Priority", selection: Binding(
                get: { vm.priority },
                set: { vm.priority = $0 }
            )) {
                ForEach(WaitPriority.allCases) { p in
                    Text(p.rawValue.capitalized).tag(p)
                }
            }
            .pickerStyle(.segmented)
        }
    }

    private func notesSection(_ vm: AddEditViewModel) -> some View {
        Section("Notes") {
            TextEditor(text: Binding(
                get: { vm.notes },
                set: { vm.notes = $0 }
            ))
            .frame(minHeight: 80)
            Text("\(vm.notesCharacterCount)/500")
                .font(Theme.Typography.caption)
                .foregroundStyle(vm.notesCharacterCount > 500 ? .red : Theme.TextColors.muted)
        }
    }
}
