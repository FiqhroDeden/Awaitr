//
//  WaitItemCard.swift
//  Awaitr
//

import SwiftUI

struct WaitItemCard: View {
    let item: WaitItem

    var body: some View {
        GlassCard(category: item.category) {
            VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                topBadgesRow
                titleText
                daysText
                MiniPipelineBar(status: item.status, category: item.category)
            }
        }
    }

    // MARK: - Top Badges Row

    private var topBadgesRow: some View {
        HStack(spacing: Theme.Spacing.sm) {
            CategoryBadge(category: item.category)
            PriorityDot(priority: item.priority)
            Spacer()
            StatusBadge(status: item.status)
        }
    }

    // MARK: - Title

    private var titleText: some View {
        Text(item.title)
            .font(Theme.Typography.cardTitle)
            .foregroundStyle(Theme.TextColors.dark)
            .lineLimit(1)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Days Text

    private var daysText: some View {
        Text(daysLabel)
            .font(Theme.Typography.caption)
            .foregroundStyle(Theme.TextColors.muted)
    }

    private var daysLabel: String {
        let days = item.daysWaiting
        switch days {
        case 0: return "Submitted today"
        case 1: return "Submitted 1 day ago"
        default: return "Submitted \(days) days ago"
        }
    }
}

// MARK: - Mini Pipeline Bar

struct MiniPipelineBar: View {
    let status: WaitStatus
    let category: WaitCategory

    private let barHeight: CGFloat = 4
    private let barSpacing: CGFloat = 4

    var body: some View {
        HStack(spacing: barSpacing) {
            ForEach(Array(WaitStatus.allInPipelineOrder.enumerated()), id: \.offset) { index, _ in
                bar(at: index)
            }
        }
    }

    private func bar(at index: Int) -> some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(barColor(at: index))
            .frame(height: barHeight)
    }

    private func barColor(at index: Int) -> Color {
        switch status {
        case .accepted:
            return Theme.CategoryColors.event // green for accepted
        case .rejected:
            return Theme.PriorityColors.high // red for rejected
        default:
            guard let currentIndex = status.pipelineIndex else {
                return Color.black.opacity(0.06)
            }
            return index <= currentIndex ? category.color : Color.black.opacity(0.06)
        }
    }
}

// MARK: - Pressable Card Style

struct PressableCardStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(Theme.Animations.springFast, value: configuration.isPressed)
    }
}

// MARK: - Previews

#Preview("Card States") {
    ScrollView {
        VStack(spacing: 16) {
            ForEach(WaitStatus.allCases) { status in
                WaitItemCard(item: {
                    let item = WaitItem(title: "Sample — \(status.label)", category: .job, priority: .high)
                    switch status {
                    case .submitted: break
                    case .inReview: item.transition(to: .inReview)
                    case .awaiting:
                        item.transition(to: .inReview)
                        item.transition(to: .awaiting)
                    case .accepted:
                        item.transition(to: .inReview)
                        item.transition(to: .awaiting)
                        item.transition(to: .accepted)
                    case .rejected:
                        item.transition(to: .rejected)
                    }
                    return item
                }())
            }
        }
        .padding()
    }
}
