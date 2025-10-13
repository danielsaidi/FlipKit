//
//  FlipViewAnimation.swift
//  FlipKit
//
//  Created by Daniel Saidi on 2025-07-14.
//  Copyright © 2025 Daniel Saidi. All rights reserved.
//

import SwiftUI

@available(*, deprecated, renamed: "FlipAnimation")
public typealias FlipViewAnimation = FlipAnimation

public extension View {

    @available(*, deprecated, renamed: "flipAnimation")
    func flipViewAnimation(
        _ animation: FlipAnimation,
        duration: TimeInterval = 0.2
    ) -> some View {
        self.flipAnimation(animation)
    }
}
