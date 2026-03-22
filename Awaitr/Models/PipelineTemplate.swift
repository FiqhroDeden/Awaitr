//
//  PipelineTemplate.swift
//  Awaitr
//

import Foundation

enum PipelineTemplate: String, Codable, CaseIterable, Identifiable, Sendable {
    // Job & Scholarship
    case jobApplication
    case scholarship

    // Products & Pre-order
    case preOrder
    case productWaitlist

    // Administration
    case document
    case permit

    // Events & Community
    case eventRegistration
    case eventWaitlist

    var id: String { rawValue }

    // MARK: - Category

    var category: WaitCategory {
        switch self {
        case .jobApplication, .scholarship: .job
        case .preOrder, .productWaitlist: .product
        case .document, .permit: .admin
        case .eventRegistration, .eventWaitlist: .event
        }
    }

    // MARK: - Display

    var label: String {
        switch self {
        case .jobApplication: "Job Application"
        case .scholarship: "Scholarship"
        case .preOrder: "Pre-order"
        case .productWaitlist: "Product Waitlist"
        case .document: "Document"
        case .permit: "Permit / License"
        case .eventRegistration: "Registration"
        case .eventWaitlist: "Event Waitlist"
        }
    }

    var icon: String {
        switch self {
        case .jobApplication: "briefcase.fill"
        case .scholarship: "graduationcap.fill"
        case .preOrder: "shippingbox.fill"
        case .productWaitlist: "clock.badge.fill"
        case .document: "doc.text.fill"
        case .permit: "person.text.rectangle.fill"
        case .eventRegistration: "ticket.fill"
        case .eventWaitlist: "person.2.fill"
        }
    }

    // MARK: - Pipeline Stages

    /// Non-terminal stages in order for this template.
    var stages: [WaitStatus] {
        switch self {
        case .jobApplication: [.pending, .active, .finalReview]
        case .scholarship: [.pending, .active]
        case .preOrder: [.pending, .active, .finalReview]
        case .productWaitlist: [.pending, .active]
        case .document: [.pending, .active]
        case .permit: [.pending, .active, .finalReview]
        case .eventRegistration: [.pending]
        case .eventWaitlist: [.pending, .active]
        }
    }

    /// All stages including terminals, in pipeline order.
    var allStagesInOrder: [WaitStatus] {
        stages + [.positive, .negative]
    }

    // MARK: - Status Labels

    func label(for status: WaitStatus) -> String {
        switch self {
        case .jobApplication:
            switch status {
            case .pending: "Applied"
            case .active: "Interviewing"
            case .finalReview: "Offer Pending"
            case .positive: "Hired"
            case .negative: "Rejected"
            }
        case .scholarship:
            switch status {
            case .pending: "Applied"
            case .active: "Under Review"
            case .finalReview: "Under Review"
            case .positive: "Awarded"
            case .negative: "Not Awarded"
            }
        case .preOrder:
            switch status {
            case .pending: "Pre-ordered"
            case .active: "Processing"
            case .finalReview: "Shipped"
            case .positive: "Delivered"
            case .negative: "Cancelled"
            }
        case .productWaitlist:
            switch status {
            case .pending: "Waitlisted"
            case .active: "Available"
            case .finalReview: "Available"
            case .positive: "Purchased"
            case .negative: "Passed"
            }
        case .document:
            switch status {
            case .pending: "Filed"
            case .active: "Processing"
            case .finalReview: "Processing"
            case .positive: "Ready"
            case .negative: "Denied"
            }
        case .permit:
            switch status {
            case .pending: "Applied"
            case .active: "Under Review"
            case .finalReview: "Inspection"
            case .positive: "Approved"
            case .negative: "Denied"
            }
        case .eventRegistration:
            switch status {
            case .pending: "Registered"
            case .active: "Registered"
            case .finalReview: "Registered"
            case .positive: "Confirmed"
            case .negative: "Full"
            }
        case .eventWaitlist:
            switch status {
            case .pending: "Waitlisted"
            case .active: "Spot Opened"
            case .finalReview: "Spot Opened"
            case .positive: "Confirmed"
            case .negative: "Expired"
            }
        }
    }

    func shortLabel(for status: WaitStatus) -> String {
        switch self {
        case .jobApplication:
            switch status {
            case .pending: "Applied"
            case .active: "Interview"
            case .finalReview: "Offer"
            case .positive: "Hired"
            case .negative: "Rejected"
            }
        case .scholarship:
            switch status {
            case .pending: "Applied"
            case .active: "Review"
            case .finalReview: "Review"
            case .positive: "Awarded"
            case .negative: "Not Awarded"
            }
        case .preOrder:
            switch status {
            case .pending: "Ordered"
            case .active: "Processing"
            case .finalReview: "Shipped"
            case .positive: "Delivered"
            case .negative: "Cancelled"
            }
        case .productWaitlist:
            switch status {
            case .pending: "Waitlisted"
            case .active: "Available"
            case .finalReview: "Available"
            case .positive: "Purchased"
            case .negative: "Passed"
            }
        case .document:
            switch status {
            case .pending: "Filed"
            case .active: "Processing"
            case .finalReview: "Processing"
            case .positive: "Ready"
            case .negative: "Denied"
            }
        case .permit:
            switch status {
            case .pending: "Applied"
            case .active: "Review"
            case .finalReview: "Inspection"
            case .positive: "Approved"
            case .negative: "Denied"
            }
        case .eventRegistration:
            switch status {
            case .pending: "Registered"
            case .active: "Registered"
            case .finalReview: "Registered"
            case .positive: "Confirmed"
            case .negative: "Full"
            }
        case .eventWaitlist:
            switch status {
            case .pending: "Waitlisted"
            case .active: "Opened"
            case .finalReview: "Opened"
            case .positive: "Confirmed"
            case .negative: "Expired"
            }
        }
    }

    func systemImage(for status: WaitStatus) -> String {
        switch status {
        case .pending: "paperplane.fill"
        case .active: "eye.fill"
        case .finalReview: "clock.fill"
        case .positive: "checkmark.circle.fill"
        case .negative: "xmark.circle.fill"
        }
    }

    func emoji(for status: WaitStatus) -> String {
        switch status {
        case .pending: "\u{1F4E8}"
        case .active: "\u{1F50D}"
        case .finalReview: "\u{23F3}"
        case .positive: "\u{2705}"
        case .negative: "\u{274C}"
        }
    }

    // MARK: - Transition Logic

    /// Next status in this template's pipeline. Nil at last non-terminal stage.
    func nextStatus(after status: WaitStatus) -> WaitStatus? {
        guard let index = stages.firstIndex(of: status),
              index + 1 < stages.count else {
            return nil
        }
        return stages[index + 1]
    }

    /// Valid transitions from the given status in this template.
    func validTransitions(from status: WaitStatus) -> [WaitStatus] {
        guard !status.isTerminal else { return [] }
        var transitions: [WaitStatus] = []
        if let next = nextStatus(after: status) {
            transitions.append(next)
        }
        transitions.append(contentsOf: [.positive, .negative])
        return transitions
    }

    /// Pipeline index of the given status (0-based). Nil for terminal statuses.
    func pipelineIndex(of status: WaitStatus) -> Int? {
        stages.firstIndex(of: status)
    }

    // MARK: - Factory

    static func templates(for category: WaitCategory) -> [PipelineTemplate] {
        switch category {
        case .job: [.jobApplication, .scholarship]
        case .product: [.preOrder, .productWaitlist]
        case .admin: [.document, .permit]
        case .event: [.eventRegistration, .eventWaitlist]
        }
    }

    static func defaultTemplate(for category: WaitCategory) -> PipelineTemplate {
        templates(for: category).first!
    }
}
