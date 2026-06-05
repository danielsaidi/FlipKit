//
//  FlipAnimation.swift
//  FlipKit
//
//  Created by Daniel Saidi on 2025-07-14.
//  Copyright © 2025-2026 Daniel Saidi. All rights reserved.
//

import SwiftUI

/// This enum defines supported flip animation types.
///
/// You can set a custom ``FlipAnimation`` value by applying
/// the ``SwiftUICore/View/flipAnimation(_:duration:)`` view
/// modifier to the view hierarchy.
public enum FlipAnimation: String, Codable, Hashable, Sendable {

    /// A bouncy animation.
    case bouncy

    /// An ease out animation.
    case easeOut

    /// A linear animation.
    case linear

    /// A smooth animation.
    case smooth

    /// A snappy animation.
    case snappy

    /// A spring animation.
    case spring
}

/// This internal type defines an animation and a duration.
struct FlipAnimationValue {

    let animationType: FlipAnimation
    let duration: TimeInterval

    var animation: Animation {
        switch animationType {
        case .bouncy: .bouncy(duration: duration)
        case .easeOut: .easeOut(duration: duration)
        case .linear: .linear(duration: duration)
        case .smooth: .smooth(duration: duration)
        case .snappy: .snappy(duration: duration)
        case .spring: .spring(duration: duration)
        }
    }
}

extension EnvironmentValues {

    @Entry var flipAnimation = FlipAnimationValue(animationType: .linear, duration: 0.2)
}

public extension View {

    /// Apply a custom ``FlipAnimation`` type.
    ///
    /// - Parameters:
    ///   - animation: The animation to use.
    ///   - duration: The animation duration, by default `0.2`.
    func flipAnimation(
        _ animation: FlipAnimation,
        duration: TimeInterval = 0.2
    ) -> some View {
        self.environment(\.flipAnimation, .init(animationType: animation, duration: duration))
    }
}
