# Release Notes

FlipKit will use semver after 1.0. 

Until then, breaking changes can happen in any minor version.



## 0.4.1

This update fixes an initial view rendering bug.

### 🐛 Bug Fixes

* `FlipView` no longer shows the wrong view initially. 



## 0.4

This update bumps the package to use Swift 6.1.

### 💡 Adjustments

* The package now uses Swift 6.1. 
* The demo app now targets iOS 26.

### 🗑️ Deprecations

* `FlipViewAnimation` has been renamed to `FlipAnimation`. 



## 0.3

This update reverts the front & back view builder parameters.



## 0.2

This update fixes clipping and lets you change the animation.

### ✨ New Features

* The `FlipViewAnimation` enum defines supported animations.
* The `.flipViewAnimation` view modifier can apply custom animations.

### 🐛 Bug Fixes

* This version fixes incorrect clipping when flipping a view. 

### 💥 Breaking Changes

* The list bug fix view modifier has been renamed. 
* The `FlipView` initializers have been consolidated into one. 



## 0.1

This is the first public release of FlipKit.

### ✨ New Features

* The `FlipDirection` enum defines supported flip directions.
* The `FlipGestureViewModifier` can apply flip-based view actions.
* The `FlipView` can be used to flip between a front and a back view.
