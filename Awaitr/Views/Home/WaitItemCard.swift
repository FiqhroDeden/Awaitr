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
                titleRow
                badgesRow
                metadataRow
            }
        }
    }

    // MARK: - Title Row

    private var titleRow: some View {
        Text(item.title)
            .font(Theme.Typography.cardTitle)
            .foregroundStyle(Theme.TextColors.dark)
            .lineLimit(2)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Badges Row

    private var badgesRow: some View {
        HStack(spacing: Theme.Spacing.sm) {
            CategoryBadge(category: item.category)
            StatusBadge(status: item.status)
            Spacer()
            MiniPipeline(status: item.status, category: item.category)
        }
    }

    // MARK: - Metadata Row

    private var metadataRow: some View {
        HStack(spacing: Theme.Spacing.xs) {
            PriorityDot(priority: item.priority)

            Text(item.daysWaitingLabel)
                .font(Theme.Typography.caption)
                .foregroundStyle(Theme.TextColors.muted)

            Spacer()

            if item.isOverdue {
                Text("Overdue")
                    .font(Theme.Typography.caption)
                    .foregroundStyle(Theme.PriorityColors.high)
            }
        }
    }
}

// MARK: - Mini Pipeline

struct MiniPipeline: View {
    let status: WaitStatus
    let category: WaitCategory

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<3) { stageIndex in
                pipelineDot(at: stageIndex)
            }
            outcomeIndicator
        }
    }

    private func pipelineDot(at stageIndex: Int) -> some View {
        let isTerminal = status.isTerminal
        let currentIndex = status.pipelineIndex

        return Group {
            if !isTerminal, let currentIndex, currentIndex == stageIndex {
                // Current stage: larger filled dot with ring
                Circle()
                    .fill(category.color)
                    .frame(width: 8, height: 8)
                    .overlay(
                        Circle()
                            .stroke(category.color.opacity(0.4), lineWidth: 1.5)
                            .frame(width: 12, height: 12)
                    )
            } else if isTerminal || (currentIndex != nil && currentIndex! >= stageIndex) {
                // Reached: filled dot
                Circle()
                    .fill(category.color)
                    .frame(width: 6, height: 6)
            } else {
                // Unreached: outlined gray dot
                Circle()
                    .stroke(Theme.TextColors.muted.opacity(0.4), lineWidth: 1)
                    .frame(width: 6, height: 6)
            }
        }
        .frame(width: 14, height: 14)
    }

    @ViewBuilder
    private var outcomeIndicator: some View {
        switch status {
        case .accepted:
            Image(systemName: "checkmark")
                .font(.system(size: 8, weight: .bold))
                .foregroundStyle(Theme.CategoryColors.event)
                .frame(width: 14, height: 14)
        case .rejected:
            Image(systemName: "xmark")
                .font(.system(size: 8, weight: .bold))
                .foregroundStyle(Theme.PriorityColors.high)
                .frame(width: 14, height: 14)
        default:
            Color.clear
                .frame(width: 14, height: 14)
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
