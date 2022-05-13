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
- ``getPhotos(for:page:count:)``
- ``getCuratedPhotos(page:count:)``
- ``searchPhotos(_:orientation:size:color:page:count:)``

### Videos

- ``getVideo(by:)``
- ``getVideos(for:page:count:)``
- ``getPopularVideos(minimumWidth:minimumHeight:minimumDuration:maximumDuration:page:count:)``
- ``searchVideos(_:orientation:size:page:results:)``
