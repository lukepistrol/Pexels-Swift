# Pexels-Swift

A Swift wrapper for the [Pexels.com API](https://www.pexels.com/api).

## Installation (SPM)

```swift
dependencies: [
  .package(url: "https://github.com/lukepistrol/Pexels-Swift.git", from: "0.1.0")
],
```

## Usage

```swift
import PexelsSwift

// access the singleton instance
let pexels = PexelsSwift.shared

// set your API key
pexels.setAPIKey("YOUR_API_KEY")

// fetch images metadata
let results = await pexels.getCuratedPhotos()
```
