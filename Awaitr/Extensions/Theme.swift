//
//  Theme.swift
//  Awaitr
//

import SwiftUI

// MARK: - Color(hex:) Extension

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: Double
        switch hex.count {
        case 6:
            r = Double((int >> 16) & 0xFF) / 255
            g = Double((int >> 8) & 0xFF) / 255
            b = Double(int & 0xFF) / 255
        default:
            r = 1; g = 1; b = 1
        }
        self.init(red: r, green: g, blue: b)
    }
}

// MARK: - Design Tokens

enum Theme {

    // MARK: Category Colors

    enum CategoryColors {
        static let job     = Color(hex: "6C63FF")
        static let product = Color(hex: "E24B4A")
        static let admin   = Color(hex: "BA7517")
        static let event   = Color(hex: "3B6D11")
    }

    // MARK: Priority Colors

    enum PriorityColors {
        static let high   = Color(hex: "E24B4A")
        static let medium = Color(hex: "EF9F27")
        static let low    = Color(hex: "97C459")
    }

    // MARK: Text Colors

    enum TextColors {
        static let dark  = Color(hex: "1A1A2E")
        static let muted = Color(hex: "666680")
    }

    // MARK: Typography

    enum Typography {
        static let pageTitle      = Font.system(.largeTitle, design: .rounded).weight(.bold)
        static let sectionHeader  = Font.system(.title2, design: .rounded).weight(.semibold)
        static let cardTitle      = Font.system(.body, design: .rounded).weight(.medium)
        static let body           = Font.system(.body)
        static let caption        = Font.system(.footnote).weight(.medium)
        static let numericCounter = Font.system(.title, design: .rounded).weight(.bold)
    }

    // MARK: Animations

    enum Animations {
        static let springFast   = Animation.spring(response: 0.3, dampingFraction: 0.7)
        static let springMedium = Animation.spring(response: 0.4, dampingFraction: 0.8)
        static let springGentle = Animation.spring(response: 0.5, dampingFraction: 0.85)
        static let fabBounce    = Animation.spring(response: 0.4, dampingFraction: 0.6)
    }

    // MARK: Spacing

    enum Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 24
        static let xxl: CGFloat = 32
    }

    // MARK: Radii

    enum Radii {
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 24
    }
}
