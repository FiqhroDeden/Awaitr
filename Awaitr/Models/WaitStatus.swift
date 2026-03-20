//
//  WaitStatus.swift
//  Awaitr
//

import SwiftUI

enum WaitStatus: String, Codable, CaseIterable, Identifiable, Sendable {
    case submitted
    case inReview
    case awaiting
    case accepted
    case rejected

    var id: String { rawValue }

    // MARK: - Display

    var label: String {
        switch self {
        case .submitted: "Submitted"
        case .inReview: "In Review"
        case .awaiting: "Awaiting"
        case .accepted: "Accepted"
        case .rejected: "Rejected"
        }
    }

    var displayLabel: LocalizedStringKey {
        switch self {
        case .submitted: "Waiting to hear back"
        case .inReview: "Being evaluated"
        case .awaiting: "Decision pending"
        case .accepted: "Positive outcome"
        case .rejected: "Negative outcome"
        }
    }

    var shortLabel: String {
        switch self {
        case .submitted: "Submitted"
        case .inReview: "Review"
        case .awaiting: "Awaiting"
        case .accepted: "Accepted"
        case .rejected: "Rejected"
        }
    }

    var systemImage: String {
        switch self {
        case .submitted: "paperplane.fill"
        case .inReview: "eye.fill"
        case .awaiting: "clock.fill"
        case .accepted: "checkmark.circle.fill"
        case .rejected: "xmark.circle.fill"
        }
    }

    var emoji: String {
        switch self {
        case .submitted: "\u{1F4E8}"  // incoming envelope
        case .inReview: "\u{1F50D}"   // magnifying glass
        case .awaiting: "\u{23F3}"    // hourglass
        case .accepted: "\u{2705}"    // check mark
        case .rejected: "\u{274C}"    // cross mark
        }
    }

    // MARK: - Pipeline

    /// Index in the 3-stage pipeline (submitted=0, inReview=1, awaiting=2).
    /// Terminal statuses return nil.
    var pipelineIndex: Int? {
        switch self {
        case .submitted: 0
        case .inReview: 1
        case .awaiting: 2
        case .accepted, .rejected: nil
        }
    }

    var isTerminal: Bool {
        self == .accepted || self == .rejected
    }

    /// The pipeline stages in order (excludes terminal statuses).
    static let pipelineStages: [WaitStatus] = [.submitted, .inReview, .awaiting]

    /// All statuses in logical pipeline order.
    static let allInPipelineOrder: [WaitStatus] = [.submitted, .inReview, .awaiting, .accepted, .rejected]

    /// The next status in the forward pipeline. Nil if terminal or at last pipeline stage.
    var nextStatus: WaitStatus? {
        switch self {
        case .submitted: .inReview
        case .inReview: .awaiting
        case .awaiting, .accepted, .rejected: nil
        }
    }

    /// All statuses this status can transition to.
    var validTransitions: [WaitStatus] {
        switch self {
        case .submitted: [.inReview, .accepted, .rejected]
        case .inReview: [.awaiting, .accepted, .rejected]
        case .awaiting: [.accepted, .rejected]
        case .accepted, .rejected: []
        }
    }
}
