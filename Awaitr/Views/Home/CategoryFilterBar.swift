//
//  CategoryFilterBar.swift
//  Awaitr
//

import SwiftUI

struct CategoryFilterBar: View {
    @Binding var selectedCategory: WaitCategory?
    let totalCount: Int
    @Namespace private var pillNamespace

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Theme.Spacing.sm) {
                filterPill(label: "All (\(totalCount))", category: nil)

                ForEach(WaitCategory.allCases) { category in
                    filterPill(
                        label: "\(category.emoji) \(category.shortLabel)",
                        category: category
                    )
                }
            }
            .padding(.horizontal)
        }
    }

    // MARK: - Filter Pill

    private func filterPill(label: String, category: WaitCategory?) -> some View {
        let isSelected = selectedCategory == category
        let tintColor = category?.color ?? Theme.CategoryColors.job

        return Text(label)
            .font(Theme.Typography.caption)
            .foregroundStyle(isSelected ? tintColor : Theme.TextColors.muted)
            .padding(.horizontal, Theme.Spacing.md)
            .padding(.vertical, Theme.Spacing.sm)
            .background {
                if isSelected {
                    Capsule()
                        .fill(tintColor.opacity(0.12))
                        .matchedGeometryEffect(id: "pill", in: pillNamespace)
                } else {
                    Capsule()
                        .fill(.white.opacity(0.7))
                        .overlay(
                            Capsule()
                                .stroke(Color.black.opacity(0.06), lineWidth: 1)
                        )
                }
            }
            .onTapGesture {
                withAnimation(Theme.Animations.springFast) {
                    selectedCategory = category
                }
            }
    }
}

#Preview {
    @Previewable @State var selected: WaitCategory?

    VStack {
        CategoryFilterBar(selectedCategory: $selected, totalCount: 10)
        Text("Selected: \(selected?.shortLabel ?? "All")")
    }
    .padding(.vertical)
}
