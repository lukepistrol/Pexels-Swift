//
//  File.swift
//  
//
//  Created by Lukas Pistrol on 30.05.22.
//

import Foundation

extension PexelsSwiftTests {
    var singlePhoto: String {
"""
{
    "id": 2014422,
    "width": 3024,
    "height": 3024,
    "url": "https://www.pexels.com/photo/brown-rocks-during-golden-hour-2014422/",
    "photographer": "Joey",
    "photographer_url": "https://www.pexels.com/@joey",
    "photographer_id": 680589,
    "avg_color": "#978E82",
    "src": {
        "original": "https://images.pexels.com/photos/2014422/pexels-photo-2014422.jpeg",
        "large2x": "https://images.pexels.com/photos/2014422/pexels-photo-2014422.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
        "large": "https://images.pexels.com/photos/2014422/pexels-photo-2014422.jpeg?auto=compress&cs=tinysrgb&h=650&w=940",
        "medium": "https://images.pexels.com/photos/2014422/pexels-photo-2014422.jpeg?auto=compress&cs=tinysrgb&h=350",
        "small": "https://images.pexels.com/photos/2014422/pexels-photo-2014422.jpeg?auto=compress&cs=tinysrgb&h=130",
        "portrait": "https://images.pexels.com/photos/2014422/pexels-photo-2014422.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=1200&w=800",
        "landscape": "https://images.pexels.com/photos/2014422/pexels-photo-2014422.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=627&w=1200",
        "tiny": "https://images.pexels.com/photos/2014422/pexels-photo-2014422.jpeg?auto=compress&cs=tinysrgb&dpr=1&fit=crop&h=200&w=280"
    },
    "liked": false,
    "alt": "Brown Rocks During Golden Hour"
}
"""
    }

    var photosCollection: String {
"""
{
    "page": 1,
    "per_page": 1,
    "photos": [
        {
            "id": 12203460,
            "width": 2963,
            "height": 4032,
            "url": "https://www.pexels.com/photo/flower-in-the-style-of-cyanotype-photography-12203460/",
            "photographer": "Ekaterina",
            "photographer_url": "https://www.pexels.com/@pit0chka",
            "photographer_id": 82253980,
            "avg_color": "#6DA5C8",
            "src": {
                "original": "https://images.pexels.com/photos/12203460/pexels-photo-12203460.jpeg",
                "large2x": "https://images.pexels.com/photos/12203460/pexels-photo-12203460.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
                "large": "https://images.pexels.com/photos/12203460/pexels-photo-12203460.jpeg?auto=compress&cs=tinysrgb&h=650&w=940",
                "medium": "https://images.pexels.com/photos/12203460/pexels-photo-12203460.jpeg?auto=compress&cs=tinysrgb&h=350",
                "small": "https://images.pexels.com/photos/12203460/pexels-photo-12203460.jpeg?auto=compress&cs=tinysrgb&h=130",
                "portrait": "https://images.pexels.com/photos/12203460/pexels-photo-12203460.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=1200&w=800",
                "landscape": "https://images.pexels.com/photos/12203460/pexels-photo-12203460.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=627&w=1200",
                "tiny": "https://images.pexels.com/photos/12203460/pexels-photo-12203460.jpeg?auto=compress&cs=tinysrgb&dpr=1&fit=crop&h=200&w=280"
            },
            "liked": false,
            "alt": "Brown and Black Maple Leaf"
        }
    ],
    "total_results": 8000,
    "next_page": "https://api.pexels.com/v1/curated/?page=2&per_page=1"
}
"""
    }

    var collection: String {
"""
{
    "page": 1,
    "per_page": 1,
    "collections": [
        {
            "id": "obz4udy",
            "title": "Cozy Home",
            "description": "",
            "private": false,
            "media_count": 138,
            "photos_count": 117,
            "videos_count": 21
        }
    ],
    "total_results": 662,
    "next_page": "https://api.pexels.com/v1/collections/featured/?page=2&per_page=1"
}
"""
    }

    var singleVideo: String {
"""
{
    "id": 6466763,
    "width": 1920,
    "height": 1080,
    "duration": 31,
    "full_res": null,
    "tags": [],
    "url": "https://www.pexels.com/video/the-silhouette-of-the-sea-during-the-golden-hour-6466763/",
    "image": "https://images.pexels.com/videos/6466763/4k-video-asia-beautiful-nature-beautiful-sky-6466763.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=630&w=1200",
    "avg_color": null,
    "user": {
        "id": 7164276,
        "name": "arvin  latifi",
        "url": "https://www.pexels.com/@arvin-latifi-7164276"
    },
    "video_files": [
        {
            "id": 2197302,
            "quality": "hd",
            "file_type": "video/mp4",
            "width": 1280,
            "height": 720,
            "link": "https://player.vimeo.com/external/499168140.hd.mp4?s=3a9874cb7feb376183b387fe7fec0a7fb4abf661&profile_id=174&oauth2_token_id=57447761"
        },
        {
            "id": 2197303,
            "quality": "sd",
            "file_type": "video/mp4",
            "width": 426,
            "height": 240,
            "link": "https://player.vimeo.com/external/499168140.sd.mp4?s=2e3f10847456da44de35b62ce6abf67820db7825&profile_id=139&oauth2_token_id=57447761"
        },
        {
            "id": 2197304,
            "quality": "sd",
            "file_type": "video/mp4",
            "width": 960,
            "height": 540,
            "link": "https://player.vimeo.com/external/499168140.sd.mp4?s=2e3f10847456da44de35b62ce6abf67820db7825&profile_id=165&oauth2_token_id=57447761"
        },
        {
            "id": 2197305,
            "quality": "hd",
            "file_type": "video/mp4",
            "width": 1920,
            "height": 1080,
            "link": "https://player.vimeo.com/external/499168140.hd.mp4?s=3a9874cb7feb376183b387fe7fec0a7fb4abf661&profile_id=169&oauth2_token_id=57447761"
        },
        {
            "id": 2197306,
            "quality": "sd",
            "file_type": "video/mp4",
            "width": 640,
            "height": 360,
            "link": "https://player.vimeo.com/external/499168140.sd.mp4?s=2e3f10847456da44de35b62ce6abf67820db7825&profile_id=164&oauth2_token_id=57447761"
        },
        {
            "id": 2197307,
            "quality": "hd",
            "file_type": "video/mp4",
            "width": 1920,
            "height": 1080,
            "link": "https://player.vimeo.com/external/499168140.hd.mp4?s=3a9874cb7feb376183b387fe7fec0a7fb4abf661&profile_id=175&oauth2_token_id=57447761"
        }
    ],
    "video_pictures": [
        {
            "id": 4484989,
            "nr": 0,
            "picture": "https://images.pexels.com/videos/6466763/pictures/preview-0.jpg"
        },
        {
            "id": 4484990,
            "nr": 1,
            "picture": "https://images.pexels.com/videos/6466763/pictures/preview-1.jpg"
        },
        {
            "id": 4484991,
            "nr": 2,
            "picture": "https://images.pexels.com/videos/6466763/pictures/preview-2.jpg"
        },
        {
            "id": 4484992,
            "nr": 3,
            "picture": "https://images.pexels.com/videos/6466763/pictures/preview-3.jpg"
        },
        {
            "id": 4484993,
            "nr": 4,
            "picture": "https://images.pexels.com/videos/6466763/pictures/preview-4.jpg"
        },
        {
            "id": 4484994,
            "nr": 5,
            "picture": "https://images.pexels.com/videos/6466763/pictures/preview-5.jpg"
        },
        {
            "id": 4484995,
            "nr": 6,
            "picture": "https://images.pexels.com/videos/6466763/pictures/preview-6.jpg"
        },
        {
            "id": 4484996,
            "nr": 7,
            "picture": "https://images.pexels.com/videos/6466763/pictures/preview-7.jpg"
        },
        {
            "id": 4484997,
            "nr": 8,
            "picture": "https://images.pexels.com/videos/6466763/pictures/preview-8.jpg"
        },
        {
            "id": 4484999,
            "nr": 9,
            "picture": "https://images.pexels.com/videos/6466763/pictures/preview-9.jpg"
        },
        {
            "id": 4485000,
            "nr": 10,
            "picture": "https://images.pexels.com/videos/6466763/pictures/preview-10.jpg"
        },
        {
            "id": 4485005,
            "nr": 11,
            "picture": "https://images.pexels.com/videos/6466763/pictures/preview-11.jpg"
        },
        {
            "id": 4485006,
            "nr": 12,
            "picture": "https://images.pexels.com/videos/6466763/pictures/preview-12.jpg"
        },
        {
            "id": 4485007,
            "nr": 13,
            "picture": "https://images.pexels.com/videos/6466763/pictures/preview-13.jpg"
        },
        {
            "id": 4485009,
            "nr": 14,
            "picture": "https://images.pexels.com/videos/6466763/pictures/preview-14.jpg"
        }
    ]
}
"""
    }

    var videosCollection: String {
"""
{
    "page": 1,
    "per_page": 1,
    "videos": [
        {
            "id": 1526909,
            "width": 1920,
            "height": 1080,
            "duration": 10,
            "full_res": null,
            "tags": [],
            "url": "https://www.pexels.com/video/seal-on-the-beach-1526909/",
            "image": "https://images.pexels.com/videos/1526909/free-video-1526909.jpg?auto=compress&cs=tinysrgb&fit=crop&h=630&w=1200",
            "avg_color": null,
            "user": {
                "id": 574687,
                "name": "Ruvim Miksanskiy",
                "url": "https://www.pexels.com/@digitech"
            },
            "video_files": [
                {
                    "id": 61368,
                    "quality": "hd",
                    "file_type": "video/mp4",
                    "width": 1920,
                    "height": 1080,
                    "link": "https://player.vimeo.com/external/296210754.hd.mp4?s=08c03c14c04f15d65901f25b542eb2305090a3d7&profile_id=175&oauth2_token_id=57447761"
                },
                {
                    "id": 61369,
                    "quality": "sd",
                    "file_type": "video/mp4",
                    "width": 960,
                    "height": 540,
                    "link": "https://player.vimeo.com/external/296210754.sd.mp4?s=9db41d71fa61a2cc19757f656fc5c5c5ef9f69ec&profile_id=165&oauth2_token_id=57447761"
                },
                {
                    "id": 61370,
                    "quality": "hd",
                    "file_type": "video/mp4",
                    "width": 1280,
                    "height": 720,
                    "link": "https://player.vimeo.com/external/296210754.hd.mp4?s=08c03c14c04f15d65901f25b542eb2305090a3d7&profile_id=174&oauth2_token_id=57447761"
                },
                {
                    "id": 61371,
                    "quality": "sd",
                    "file_type": "video/mp4",
                    "width": 640,
                    "height": 360,
                    "link": "https://player.vimeo.com/external/296210754.sd.mp4?s=9db41d71fa61a2cc19757f656fc5c5c5ef9f69ec&profile_id=164&oauth2_token_id=57447761"
                },
                {
                    "id": 61372,
                    "quality": "hls",
                    "file_type": "video/mp4",
                    "width": null,
                    "height": null,
                    "link": "https://player.vimeo.com/external/296210754.m3u8?s=e28800dd24f0ec70ada7d09201dc0fa728bd468b&oauth2_token_id=57447761"
                }
            ],
            "video_pictures": [
                {
                    "id": 141547,
                    "nr": 0,
                    "picture": "https://images.pexels.com/videos/1526909/pictures/preview-0.jpg"
                },
                {
                    "id": 141548,
                    "nr": 1,
                    "picture": "https://images.pexels.com/videos/1526909/pictures/preview-1.jpg"
                },
                {
                    "id": 141549,
                    "nr": 2,
                    "picture": "https://images.pexels.com/videos/1526909/pictures/preview-2.jpg"
                },
                {
                    "id": 141550,
                    "nr": 3,
                    "picture": "https://images.pexels.com/videos/1526909/pictures/preview-3.jpg"
                },
                {
                    "id": 141551,
                    "nr": 4,
                    "picture": "https://images.pexels.com/videos/1526909/pictures/preview-4.jpg"
                },
                {
                    "id": 141552,
                    "nr": 5,
                    "picture": "https://images.pexels.com/videos/1526909/pictures/preview-5.jpg"
                },
                {
                    "id": 141553,
                    "nr": 6,
                    "picture": "https://images.pexels.com/videos/1526909/pictures/preview-6.jpg"
                },
                {
                    "id": 141554,
                    "nr": 7,
                    "picture": "https://images.pexels.com/videos/1526909/pictures/preview-7.jpg"
                },
                {
                    "id": 141555,
                    "nr": 8,
                    "picture": "https://images.pexels.com/videos/1526909/pictures/preview-8.jpg"
                },
                {
                    "id": 141556,
                    "nr": 9,
                    "picture": "https://images.pexels.com/videos/1526909/pictures/preview-9.jpg"
                },
                {
                    "id": 141557,
                    "nr": 10,
                    "picture": "https://images.pexels.com/videos/1526909/pictures/preview-10.jpg"
                },
                {
                    "id": 141558,
                    "nr": 11,
                    "picture": "https://images.pexels.com/videos/1526909/pictures/preview-11.jpg"
                },
                {
                    "id": 141559,
                    "nr": 12,
                    "picture": "https://images.pexels.com/videos/1526909/pictures/preview-12.jpg"
                },
                {
                    "id": 141560,
                    "nr": 13,
                    "picture": "https://images.pexels.com/videos/1526909/pictures/preview-13.jpg"
                },
                {
                    "id": 141561,
                    "nr": 14,
                    "picture": "https://images.pexels.com/videos/1526909/pictures/preview-14.jpg"
                }
            ]
        }
    ],
    "total_results": 353504,
    "next_page": "https://api.pexels.com/v1/videos/popular/?page=2&per_page=1",
    "url": "https://api-server.pexels.com/videos/"
}
"""
    }
}

var noContent: String {
"""
{
    "page": 1,
    "per_page": 1,
    "total_results": 0,
    "next_page": "https://api.pexels.com/v1/curated/?page=2&per_page=1"
}
"""
    }
