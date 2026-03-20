//
//  PreviewSampleData.swift
//  Awaitr
//

import SwiftData
import Foundation

// MARK: - Preview Container

@MainActor
func previewContainer() -> ModelContainer {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: WaitItem.self, configurations: config)

    for item in PreviewSampleData.items {
        container.mainContext.insert(item)
    }

    return container
}

// MARK: - Sample Data

enum PreviewSampleData {
    @MainActor
    static let items: [WaitItem] = [
        // Jobs
        makeItem("Apple — iOS Engineer", .job, .inReview, .high, daysAgo: 14, expected: 30),
        makeItem("Google — SWE III", .job, .submitted, .high, daysAgo: 7, expected: 45),
        makeItem("Stripe — Mobile Developer", .job, .awaiting, .medium, daysAgo: 21, expected: 10),
        makeItem("Netflix — Senior iOS", .job, .accepted, .high, daysAgo: 30, archived: true),
        makeItem("Meta — Software Engineer", .job, .rejected, .medium, daysAgo: 25, archived: true),

        // Products
        makeItem("iPhone 18 Pro Max", .product, .submitted, .low, daysAgo: 3, expected: 60),
        makeItem("AirPods Pro 4", .product, .inReview, .medium, daysAgo: 10),
        makeItem("Steam Deck 2", .product, .submitted, .low, daysAgo: 45, expected: 90),

        // Admin
        makeItem("Passport Renewal", .admin, .inReview, .high, daysAgo: 28, expected: 14),
        makeItem("Tax Refund 2025", .admin, .awaiting, .medium, daysAgo: 60, expected: 5),
        makeItem("Driver's License", .admin, .accepted, .low, daysAgo: 90, archived: true),

        // Events
        makeItem("WWDC 2026 Scholarship", .event, .submitted, .high, daysAgo: 5, expected: 30),
        makeItem("Local Meetup Speaker", .event, .accepted, .medium, daysAgo: 15, archived: true),
        makeItem("Conference Early Bird", .event, .submitted, .low, daysAgo: 2, expected: 14),
    ]

    @MainActor
    private static func makeItem(
        _ title: String,
        _ category: WaitCategory,
        _ status: WaitStatus,
        _ priority: WaitPriority,
        daysAgo: Int,
        expected: Int? = nil,
        archived: Bool = false
    ) -> WaitItem {
        let submitted = Calendar.current.date(byAdding: .day, value: -daysAgo, to: .now) ?? .now
        let expectedDate = expected.flatMap {
            Calendar.current.date(byAdding: .day, value: $0, to: submitted)
        }

        let item = WaitItem(
            title: title,
            category: category,
            submittedAt: submitted,
            priority: priority,
            expectedAt: expectedDate
        )

        // Transition to target status
        switch status {
        case .submitted: break
        case .inReview:
            item.transition(to: .inReview)
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

        if archived && !item.isArchived {
            item.archive()
        }

        return item
    }
}
