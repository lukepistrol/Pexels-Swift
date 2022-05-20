# Getting Started

This is a quick run through on how to use ``PexelsSwift`` and what can be done.

## Overview

Before you get started head over to the [Pexels API](https://www.pexels.com/api) site and get your own `API Token`. After you got your `API Token` please make sure to save it for later use.

### Add PexelsSwift to your Project

To add ``PexelsSwift`` to your project simply add the following line to your `Package.swift` file's dependencies:

```swift
...
dependencies: [
    .package(url: "https://github.com/lukepistrol/Pexels-Swift.git", from: "0.1.0")
],
...
```

In case you want to add it directly to your `*.xcodeproj*` just go to `File > Add Packages` and enter the URL into the search field on the top right.

### Setup PexelsSwift

Now you are ready to add some code:

```swift
import PexelsSwift

// create a reference to the PexelsSwift singleton
let pexels = PexelsSwift.shared

// call the setup method to set your API-Key and 
// optionally the debug level
pexels.setup(apiKey: "YOUR_API_KEY", logLevel: .debug)
```

> Since ``PexelsSwift`` is setup as a singleton you only have to set it up once and you can access it everywhere in your project by calling `PexelsSwift.shared`.

### Fetch Featured Photos

Now it is time to fetch some data from the API. For now we will fetch 20 photos from the featured photos endpoint using ``PexelsSwift/PexelsSwift/getCuratedPhotos(page:count:completion:)``. There are methods for `async/await` but in case you prefer completion handlers, they are available to.

```swift
// get 20 curated photos asynchronously
let result = await pexels.getCuratedPhotos(count: 20)

switch result {
// check for errors
case .failure(let error):
    print(error.description)
    // handle the error
// access the result's content
case .success(let (photos, pageInfo)):
    ...
}
```

In the code above you can see we get `photos` and `metadata` from our result in the `.success` case.

- **photos** is an array of ``PSPhoto``.
- **pageInfo** is a struct ``PSPagingInfo`` which contains some information for paging like the current page, results per page, the URL to the next/previous page and the number of total results.

### Get the Image URL

Now we want to get the URLs for the thumbnails of the fetched images.

```swift
switch result {
...
case .success(let (photos, pageInfo)):
    let urls = photos.compactMap { 
        URL(string: $0.source[PSPhoto.Size.tiny.rawValue]) 
    }
    // now you can load the image from each URL and 
    // display it in your UI
}
```
