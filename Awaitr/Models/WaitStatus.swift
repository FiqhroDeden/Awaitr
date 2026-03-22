//
//  WaitStatus.swift
//  Awaitr
//

import SwiftUI

enum WaitStatus: String, Codable, CaseIterable, Identifiable, Sendable {
    case pending
    case active
    case finalReview
    case positive
    case negative

    var id: String { rawValue }

    // MARK: - Terminal Detection

    var isTerminal: Bool {
        self == .positive || self == .negative
    }

    var isPositive: Bool { self == .positive }
    var isNegative: Bool { self == .negative }

    // MARK: - Migration Decoder

    init(from decoder: Decoder) throws {
        let rawValue = try decoder.singleValueContainer().decode(String.self)
        switch rawValue {
        // Legacy raw values
        case "submitted": self = .pending
        case "inReview": self = .active
        case "awaiting": self = .finalReview
        case "accepted": self = .positive
        case "rejected": self = .negative
        default:
            guard let status = WaitStatus(rawValue: rawValue) else {
                throw DecodingError.dataCorruptedError(
                    in: try decoder.singleValueContainer(),
                    debugDescription: "Unknown WaitStatus raw value: \(rawValue)"
                )
            }
            self = status
        }
    }
}
