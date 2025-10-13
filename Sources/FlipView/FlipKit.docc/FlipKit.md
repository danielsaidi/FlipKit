# ``FlipKit``

FlipKit is a SwiftUI library with flip utilities that work on all major Apple platforms.


## Overview

![Library logotype](Logo.png)

FlipKit is a SwiftUI library with flip utilities that work on all major Apple platforms, like the multi-platform ``FlipView`` and the ``SwiftUICore/View/onFlipGesture(up:left:right:down:)`` view modifier.



## Installation

FlipView can be installed with the Swift Package Manager:

```
https://github.com/danielsaidi/FlipView.git
```



## Support My Work

You can [become a sponsor][Sponsors] to help me dedicate more time on my various [open-source tools][OpenSource]. Every contribution, no matter the size, makes a real difference in keeping these tools free and actively developed.



## Getting started

The ``FlipView`` can flip between a front and back view: 

```swift
import FlipKit

struct MyView: View {

    @State private var isFlipped = false

    var body: some View {
        FlipView(
            isFlipped: $isFlipped,
            front: { Card(color: .green) },
            back: { Card(color: .red) }
        )
        .flipAnimation(.linear, duration: 1.0)
        .withListRenderingBugFix()  // For now, when used in a List 
    }
}

struct Card: View {

    let color: Color

    var body: some View {
        color.cornerRadius(10)
    }
}
```

You can provide custom tap flip and swipe directions, and can also flip the view by toggling the `isFlipped` binding. You can also add the ``SwiftUICore/View/onFlipGesture(up:left:right:down:)`` modifier to any view to apply custom flip actions.



## Repository

For more information, source code, etc., visit the [project repository](https://github.com/danielsaidi/FlipKit).



## License

FlipKit is available under the MIT license.



## Topics

### Essentials

- ``FlipView``

### Models

- ``FlipAnimation``
- ``FlipDirection``
- ``FlipGestureViewModifier``



[Email]: mailto:daniel.saidi@gmail.com
[Website]: https://danielsaidi.com
[GitHub]: https://github.com/danielsaidi
[OpenSource]: https://danielsaidi.com/opensource
[Sponsors]: https://github.com/sponsors/danielsaidi
