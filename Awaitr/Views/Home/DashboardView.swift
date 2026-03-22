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
    @State private var showSearch = false

    let path: Binding<NavigationPath>
    let onAddTapped: () -> Void

    // MARK: - Safe Bindings

    private var selectedCategoryBinding: Binding<WaitCategory?> {
        Binding(
            get: { viewModel?.selectedCategory },
            set: { viewModel?.selectedCategory = $0 }
        )
    }

    private var searchTextBinding: Binding<String> {
        Binding(
            get: { viewModel?.searchText ?? "" },
            set: { viewModel?.searchText = $0 }
        )
    }

    private var displayedItems: [WaitItem] {
        viewModel?.filteredItems(from: activeItems) ?? activeItems
    }

    private var activeItemCount: Int {
        activeItems.count
    }

    // MARK: - Greeting

    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: .now)
        switch hour {
        case 5..<12: return "Good morning"
        case 12..<17: return "Good afternoon"
        case 17..<21: return "Good evening"
        default: return "Good night"
        }
    }

    // MARK: - Body

    var body: some View {
        NavigationStack(path: path) {
            ScrollView {
                LazyVStack(spacing: Theme.Spacing.lg) {
                    headerSection
                    if activeItems.isEmpty {
                        emptyContent
                    } else {
                        statsSection
                        filterSection
                        itemListSection
                    }
                }
                .padding(.top)
            }
            .background {
                LinearGradient(
                    colors: [
                        Color(hex: "F7F6FF"),
                        Color(hex: "EFF3FF"),
                        Color(hex: "F0FFF6")
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .navigationBar)
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

    // MARK: - Header

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(greeting)
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundStyle(Theme.TextColors.muted)
                    Text("My Waitlist")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(Theme.TextColors.dark)
                }
                Spacer()
                searchButton
            }

            if showSearch {
                searchField
                    .transition(.opacity.combined(with: .move(edge: .trailing)))
            }
        }
        .padding(.horizontal)
        .animation(Theme.Animations.springFast, value: showSearch)
    }

    private var searchButton: some View {
        Button {
            showSearch.toggle()
            if !showSearch {
                viewModel?.searchText = ""
            }
        } label: {
            Image(systemName: showSearch ? "xmark" : "magnifyingglass")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Theme.TextColors.muted)
                .frame(width: 40, height: 40)
                .background(Color.black.opacity(0.04))
                .clipShape(Circle())
        }
    }

    private var searchField: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 14))
                .foregroundStyle(Theme.TextColors.muted)
            TextField("Search items...", text: searchTextBinding)
                .font(.system(size: 15))
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(Color.black.opacity(0.04))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.top, 8)
    }

    // MARK: - Sections

    private var statsSection: some View {
        SummaryStatsView(
            items: activeItems,
            selectedCategory: selectedCategoryBinding
        )
    }

    private var filterSection: some View {
        CategoryFilterBar(
            selectedCategory: selectedCategoryBinding,
            totalCount: activeItemCount
        )
    }

    @ViewBuilder
    private var itemListSection: some View {
        if displayedItems.isEmpty {
            EmptyStateView(
                icon: "magnifyingglass",
                heading: "No matches",
                subheading: "Try a different search or filter"
            )
        } else {
            ForEach(displayedItems) { item in
                NavigationLink(value: AppDestination.itemDetail(item)) {
                    WaitItemCard(item: item)
                }
                .buttonStyle(PressableCardStyle())
                .padding(.horizontal)
            }
        }
    }

    private var emptyContent: some View {
        EmptyStateView(
            icon: "tray",
            heading: "Nothing to wait for!",
            subheading: "Tap + to add your first item",
            actionLabel: "Add Item",
            action: onAddTapped
        )
    }
}
