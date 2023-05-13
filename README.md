<p>
  <img src="https://img.shields.io/badge/Swift-5.8-f05318.svg" />
  <img src="https://img.shields.io/badge/iOS->= 13.0-blue.svg" />
  <img src="https://img.shields.io/badge/macOS->= 10.15-blue.svg" />
  <img src="https://img.shields.io/badge/watchOS->= 6.0-blue.svg" />
  <img src="https://img.shields.io/badge/tvOS->= 13.0-blue.svg" />
</p>
<p>
  <img alt="GitHub Workflow Status" src="https://img.shields.io/github/actions/workflow/status/lukepistrol/Pexels-Swift/build-documentation.yml?label=CI">
  <img alt="GitHub" src="https://img.shields.io/github/license/lukepistrol/pexels-swift">
  <a href="https://twitter.com/lukeeep_">
    <img src="https://img.shields.io/badge/Twitter-@lukeeep_-1e9bf0.svg?style=flat" alt="Twitter: @lukeeep_" />
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
case .success(let (data, paging, response)):
    // access photos
    // data -> [PSPhoto]
    // paging -> PSPagingInfo
    // response -> HTTPURLResponse
}

// fetch images metadata using completion handlers
pexels.getCuratedPhotos() { result in
    switch result {
    case .failure(let error):
        print(error.description)
    case .success(let (data, paging, response)):
        // access photos
        // data -> [PSPhoto]
        // paging -> PSPagingInfo
        // response -> HTTPURLResponse
    }
}
```

## Demo Project

I've built a simple iOS app - [PexelsBrowser](https://github.com/lukepistrol/PexelsBrowser) - using this library and SwiftUI.

<a href="https://www.buymeacoffee.com/lukeeep" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" style="height: 60px !important;width: 217px !important;" ></a>
