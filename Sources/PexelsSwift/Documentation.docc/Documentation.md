# ``PexelsSwift``

Pexels.com API client library for the Swift programming language

## Overview

![Banner](Banner.png)

This Swift Package is a wrapper for [Pexels API](https://www.pexels.com/api) to get access to the entire photo library of `Pexels` within your Swift app.

> It is mandatory to get an [API Key](https://www.pexels.com/api).

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
pexels.setup(apiKey: "YOUR_API_KEY", logLevel: .debug)

// fetch images metadata using async/await
let result = await pexels.getCuratedPhotos()

switch result {
case .failure(let error):
    print(error.description)
case .success(let (photos, metadata)):
    // access photos
}

// fetch images metadata using completion handlers
pexels.getCuratedPhotos() { result in
    switch result {
    case .failure(let error):
        print(error.description)
    case .success(let (photos, metadata)):
        // access photos
    }
}
```

## Demo Project

I've built a simple iOS app - [PexelsBrowser](https://github.com/lukepistrol/PexelsBrowser) - using this library and SwiftUI.

## Topics

### Classes

- ``PexelsSwift/PexelsSwift``

### Resources

- ``PexelsSwift/PSPhoto``
- ``PexelsSwift/PSVideo``
- ``PexelsSwift/PSCollection``
- ``PexelsSwift/PSMetaData``

### Logger

- ``PexelsSwift/PSLogger``
- ``PexelsSwift/PSLogLevel``

### Errors

- ``PexelsSwift/PSError``
