<p>
  <img src="https://img.shields.io/badge/Swift-5.6-ff69b4.svg" />
  <img src="https://img.shields.io/badge/iOS-13+-brightgreen.svg" />
  <img src="https://img.shields.io/badge/macOS-10.15+-brightgreen.svg" />
  <a href="https://twitter.com/lukeeep_">
    <img src="https://img.shields.io/badge/Contact-@lukeeep_-lightgrey.svg?style=flat" alt="Twitter: @lukeeep_" />
  </a>
</p>

# Pexels-Swift

[Pexels.com API](https://www.pexels.com/api) client library for the Swift programming language.

![Banner](https://github.com/lukepistrol/Pexels-Swift/blob/main/Sources/PexelsSwift/Documentation.docc/Resources/Banner.png)

## Overview

This Swift Package is a wrapper for [Pexels API](https://www.pexels.com/api) to get access to the entire photo library of `Pexels` within your Swift app.

> It is mandatory to get an [API Key](https://www.pexels.com/api).

## Installation (SPM)

```swift
dependencies: [
  .package(url: "https://github.com/lukepistrol/Pexels-Swift.git", from: "0.1.0")
],
```

## Documentation

See the full documentation [here](https://lukepistrol.github.io/Pexels-Swift/documentation/pexelsswift/) or build it locally using `⇧⌃⌘D` in Xcode once you added `Pexels-Swift` to your project.

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
case .success(let photos):
    // access photos
}

// fetch images metadata using completion handlers
pexels.getCuratedPhotos() { result in
    switch result {
    case .failure(let error):
        print(error.description)
    case .success(let photos):
        // access photos
    }
}
```

## Demo Project

I've built a simple iOS app - [PexelsBrowser](https://github.com/lukepistrol/PexelsBrowser) - using this library and SwiftUI.
