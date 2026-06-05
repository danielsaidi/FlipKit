import FlipKit
import SwiftUI
import Testing

@MainActor
@Test func allPublicTypesCanBeCreated() async throws {
    _ = FlipDirection.down
    #if os(iOS)
    _ = FlipGestureViewModifier()
    #endif
    _ = FlipView(
        isFlipped: .constant(true),
        front: { Color.green },
        back: { Color.red }
    )
    .flipAnimation(.bouncy, duration: 1)
}
