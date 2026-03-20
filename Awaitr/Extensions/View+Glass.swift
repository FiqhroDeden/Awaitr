//
//  View+Glass.swift
//  Awaitr
//

import SwiftUI

// MARK: - Glass Card Modifier

struct GlassCardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: Theme.Radii.lg))
            .overlay(
                RoundedRectangle(cornerRadius: Theme.Radii.lg)
                    .stroke(.white.opacity(0.3), lineWidth: 0.5)
            )
    }
}

extension View {
    func glassCard() -> some View {
        modifier(GlassCardModifier())
    }
}
