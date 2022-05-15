# ``PexelsSwift/PexelsSwift``

## Overview

Use this class for making API calls. It is accessible through a singleton instance ``shared``.

```swift
let pexels = PexelsSwift.shared
```

Make sure to also set your API key using ``setup(apiKey:logLevel:)``.

```swift
pexels.setAPIKey("YOUR_SECRET_API_KEY")
```

## Topics

### Accessor

- ``shared``

### Setup

- ``setup(apiKey:logLevel:)``

### Categories

- ``getCollections(page:count:)``
- ``CollectionResult``

### Photos

- ``getPhoto(by:)``
- ``getPhotos(for:page:count:)``
- ``getCuratedPhotos(page:count:)``
- ``searchPhotos(_:orientation:size:color:page:count:)``
- ``PhotosResult``
- ``PhotoResult``

### Videos

- ``getVideo(by:)``
- ``getVideos(for:page:count:)``
- ``getPopularVideos(minimumWidth:minimumHeight:minimumDuration:maximumDuration:page:count:)``
- ``searchVideos(_:orientation:size:page:results:)``
- ``VideosResult``
- ``VideoResult``



