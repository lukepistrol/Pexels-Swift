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

> For more information see the <doc:Getting-Started> guide.

## Topics

### Accessor

- ``shared``

### Setup

- ``setup(apiKey:logLevel:)``

### Categories (async/await)

- ``getCollections(page:count:)``
- ``CollectionResult``

### Categories

- ``getCollections(page:count:completion:)``

### Photos (async/await)

- ``getPhoto(by:)``
- ``getPhotos(for:page:count:)``
- ``getCuratedPhotos(page:count:)``
- ``searchPhotos(_:orientation:size:color:locale:page:count:)``
- ``PhotosResult``
- ``PhotoResult``

### Photos

- ``getPhoto(by:completion:)``
- ``getPhotos(for:page:count:completion:)``
- ``getCuratedPhotos(page:count:completion:)``
- ``searchPhotos(_:orientation:size:color:locale:page:count:completion:)``

### Videos (async/await)

- ``getVideo(by:)``
- ``getVideos(for:page:count:)``
- ``getPopularVideos(minimumWidth:minimumHeight:minimumDuration:maximumDuration:page:count:)``
- ``searchVideos(_:orientation:size:locale:page:count:)``
- ``VideosResult``
- ``VideoResult``

### Videos

- ``getVideo(by:completion:)``
- ``getVideos(for:page:count:completion:)``
- ``getPopularVideos(minimumWidth:minimumHeight:minimumDuration:maximumDuration:page:count:completion:)``
- ``searchVideos(_:orientation:size:locale:page:count:completion:)``
