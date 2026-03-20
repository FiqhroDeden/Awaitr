//
//  Color+Category.swift
//  Awaitr
//

import SwiftUI

extension Color {
    init(category: WaitCategory) {
        switch category {
        case .job: self = Theme.CategoryColors.job
        case .product: self = Theme.CategoryColors.product
        case .admin: self = Theme.CategoryColors.admin
        case .event: self = Theme.CategoryColors.event
        }
    }

    init(priority: WaitPriority) {
        switch priority {
        case .high: self = Theme.PriorityColors.high
        case .medium: self = Theme.PriorityColors.medium
        case .low: self = Theme.PriorityColors.low
        }
    }

    init(status: WaitStatus) {
        switch status {
        case .submitted: self = .gray
        case .inReview: self = .blue
        case .awaiting: self = .orange
        case .accepted: self = Theme.CategoryColors.event
        case .rejected: self = Theme.PriorityColors.high
        }
    }
}
