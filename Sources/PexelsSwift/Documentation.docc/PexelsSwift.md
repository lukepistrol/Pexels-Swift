# ``PexelsSwift/PexelsSwift``

## Overview

Use this class for making API calls. It is accessible through a singleton instance ``shared``.

```swift
let pexels = PexelsSwift.shared
```

Make sure to also set your API key using ``setAPIKey(_:)``.

```swift
pexels.setAPIKey("YOUR_SECRET_API_KEY")
```

## Topics

### Accessor

- ``shared``

### Setup

- ``setAPIKey(_:)``

### Categories

- ``getCategories(page:count:)``

### Photos

- ``getPhoto(by:)``
- ``getPhotos(search:page:count:)``
- ``getPhotos(for:page:count:)``
- ``getCuratedPhotos(page:count:)``
