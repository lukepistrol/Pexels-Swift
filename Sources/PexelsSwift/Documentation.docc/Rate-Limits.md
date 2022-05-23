# Rate Limits

Statistics for the monthly API quota

## Overview

To see how many requests you have left in your monthly quota, successful requests from the Pexels API include three HTTP headers:

| Header                  | Meaning                                                            |
| ------------------------| ------------------------------------------------------------------ |
| `X-Ratelimit-Limit`     | Your total request limit for the monthly period                    |
| `X-Ratelimit-Remaining` | How many of these requests remain                                  |
| `X-Ratelimit-Reset`     | UNIX timestamp of when the currently monthly period will roll over |

> These response heaaders are only returned on successful (`2xx`) responses. They are not included with other responses, including `429 Too Many Requests`, which indicates you have exceeded your rate limit. Please be sure to keep track of `X-Ratelimit-Remaining` and `X-Ratelimit-Reset` in order to manage your request limit.

## Access Rate Limits

There is a `public` property ``PexelsSwift/PexelsSwift/rateLimit-swift.property`` which automatically keeps track of the above mentioned headers during a session.

> In case there is no recently made API call those values might be `nil`

```swift
let rateLimits = PexelsSwift.shared.rateLimit

print(rateLimits.limit) // Limit or nil
print(rateLimits.remaining) // Remaining calls or nil
print(rateLimits.reset) // Reset date or nil
```

## HTTPURLResponse

For easy access to these headers [`HTTPURLResponse`](https://developer.apple.com/documentation/foundation/httpurlresponse)
was extended with the following properties:

```swift
var pexelsLimit: Int? { get }
var pexelsRemaining: Int? { get }
var pexelsReset: Date? { get }
```

When evaluating the result of an API call simply call these properties to get the corresponding values:

```swift
let result = await pexels.getCuratedPhotos()

switch result {
...
case .success(let (data, paging, response)):
    ...
    let limit = response.pexelsLimit
    let remaining = response.pexelsRemaining
    let reset = response.pexelsReset
    ...
}
```
