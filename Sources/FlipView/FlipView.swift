//
//  FlipKit.swift
//  FlipKit
//
//  Created by Daniel Saidi on 2020-01-05.
//  Copyright © 2020-2025 Daniel Saidi. All rights reserved.
//

import SwiftUI

/// This view has a front and a back view that can be flipped between.
///
/// Use `tapDirection` to define in which direction the view should be flipped
/// when it's tapped, and `swipeDirections` to define which swipe directions
/// that should be applied to the view.
///
/// You can observe the `isFlipped` binding to catch when the view is flipped.
///
/// > Important: This view handles flip animations incorrectly when it's used within
/// a `List`. Apply a ``SwiftUICore/View/withFlipViewListBugFix()``
/// to the view, to fix the bug until we find a reason for it and a native fix.
public struct FlipView<Front: View, Back: View>: View {

    /// Create a flip view with content view builders.
    ///
    /// - Parameters:
    ///   - isFlipped: The flipped state.
    ///   - tapDirection: The flip direction for taps, by default `.right`.
    ///   - swipeDirections: The supported swipe directions, by default `.allCases`.
    ///   - front: The front content view.
    ///   - back: The front content view.
    public init(
        isFlipped: Binding<Bool>,
        tapDirection: FlipDirection = .right,
        swipeDirections: [FlipDirection] = .allCases,
        @ViewBuilder front: @escaping () -> Front,
        @ViewBuilder back: @escaping () -> Back,
    ) {
        self.front = front
        self.back = back
        self._isFlipped = isFlipped
        self.tapDirection = tapDirection
        self.swipeDirections = swipeDirections
        self._isContentFlipped = .init(initialValue: isFlipped.wrappedValue)
    }

    public enum Face: Codable, Equatable, Hashable, Sendable {
        case front, back
    }

    private let front: () -> Front
    private let back: () -> Back
    private let swipeDirections: [FlipDirection]
    private let tapDirection: FlipDirection

    @Binding private var isFlipped: Bool

    @Environment(\.flipAnimation) var flipAnimation

    @State private var cardRotation = 0.0
    @State private var contentRotation = 0.0
    @State private var isContentFlipped: Bool {
        didSet { isFlipped = isContentFlipped }
    }
    @State private var isFlipping = false
    @State private var lastDirection = FlipDirection.right

    private var flipAnimationFirst: Animation {
        .linear(duration: flipAnimation.duration/2)
    }

    private var flipAnimationSecond: Animation {
        flipAnimation.animation
    }

    public var body: some View {
        bodyContent
            .onChange(of: isFlipped) { _, _ in flipWithTap() }
            .withTapGesture(action: flipWithTap)
            .withSwipeGesture(action: flipWithSwipe)
            .rotationEffect(.degrees(contentRotation), direction: lastDirection)
            .rotationEffect(.degrees(cardRotation), direction: lastDirection)
            .accessibility(addTraits: .isButton)
    }

    @ViewBuilder
    private var bodyContent: some View {
        if isFlipped {
            back()
        } else {
            front()
        }
    }
}

public extension View {

    /// Apply this to a ``FlipView`` to make it perform well within a `List`.
    ///
    /// This shouldn't be needed, so if we find a way to fix it, we should.
    func withFlipViewListBugFix() -> some View {
        ZStack {
            self
        }
    }
}

private extension View {

    typealias FlipAction = (FlipDirection) -> Void

    func withTapGesture(action: @escaping () -> Void) -> some View {
        #if os(tvOS)
        Button(action: action) { self }
            .buttonStyle(.plain)
        #else
        self.onTapGesture(perform: action)
        #endif
    }

    func withSwipeGesture(action: @escaping FlipAction) -> some View {
        #if os(tvOS)
        self
        #else
        self.onFlipGesture(
            up: { action(.up) },
            left: { action(.left) },
            right: { action(.right) },
            down: { action(.down) })
        #endif
    }
}

private extension FlipView {

    func flip(_ direction: FlipDirection) {
        guard !isFlipping else { return }
        isFlipping = true
        lastDirection = direction
        cardRotation = isContentFlipped ? 180 : 0
        contentRotation = isContentFlipped ? 180 : 0
        let degrees = flipDegrees(for: direction)
        withAnimation(flipAnimationFirst) {
            cardRotation += degrees/2
        } completion: {
            contentRotation += degrees
            isContentFlipped.toggle()
            withAnimation(flipAnimationSecond) {
                cardRotation += degrees/2
            } completion: {
                isFlipping = false
            }
        }
    }

    func flipDegrees(for direction: FlipDirection) -> Double {
        switch direction {
        case .right, .up: 180
        case .left, .down: -180
        }
    }

    func flipWithTap() {
        flip(tapDirection)
    }

    func flipWithSwipe(in direction: FlipDirection) {
        guard swipeDirections.contains(direction) else { return }
        flip(direction)
    }
}

private extension View {

    @ViewBuilder
    func rotationEffect(
        _ angles: Angle,
        direction: FlipDirection
    ) -> some View {
        switch direction {
        case .left, .right: rotation3DEffect(angles, axis: (x: 0, y: 1, z: 0))
        case .up, .down: rotation3DEffect(angles, axis: (x: 1, y: 0, z: 0))
        }
    }
}

private struct PreviewContent: View {

    let isFlipped: Bool

    var body: some View {
        let text = Text("Is Flipped: \(isFlipped.description)")
        let color = isFlipped ? Color.red : Color.green
        let colorView = color.clipShape(.rect(cornerRadius: 10))
        return colorView.overlay(text)
    }
}

@MainActor
@ViewBuilder
func previewContent(isFlipped: Binding<Bool>) -> some View {
    FlipView(
        isFlipped: isFlipped,
        tapDirection: .right,
        swipeDirections: [.left, .right, .up, .down],
        front: { PreviewContent(isFlipped: isFlipped.wrappedValue) },
        back: { PreviewContent(isFlipped: isFlipped.wrappedValue) }
    )
    .flipAnimation(.bouncy, duration: 0.5)
    .withFlipViewListBugFix()  // OBS!
    .frame(minHeight: 100)

    Button("Flip") {
        withAnimation {
            isFlipped.wrappedValue.toggle()
        }
    }
}

#Preview("Stack") {

    struct Preview: View {

        @State var isFlipped = false

        var body: some View {
            previewContent(isFlipped: $isFlipped)
                .padding()
        }
    }

    return Preview()
}

#Preview("List Bugfix") {

    struct Preview: View {

        @State var isFlipped = false

        var body: some View {
            List {
                previewContent(isFlipped: $isFlipped)
            }
        }
    }

    return Preview()
}
