/*
Copyright 2017 ArcTouch LLC.
All rights reserved.
 
This file, its contents, concepts, methods, behavior, and operation
(collectively the "Software") are protected by trade secret, patent,
and copyright laws. The use of the Software is governed by a license
agreement. Disclosure of the Software to third parties, in any form,
in whole or in part, is expressly prohibited except as authorized by
the license agreement.
*/

import TMDB_Swift
import Foundation

func entity(for images: Images, using configuration: Configuration,
            posterSize: PosterImageSize = .w342, backdropSize: BackdropImageSize = .w780) -> ImagesEntity {
  let baseURL = configuration.images.secureBaseURL as NSString

  let backdrops = images.backdrops.map { imageEntity(for: $0, with: baseURL, size: backdropSize.rawValue) }
  let posters = images.posters.map { imageEntity(for: $0, with: baseURL, size: posterSize.rawValue) }

  return ImagesEntity(identifier: images.identifier, backdrops: backdrops, posters: posters)
}

func imageEntity(for image: Image, with baseURL: NSString, size: String) -> ImageEntity {
  let link = (baseURL.appendingPathComponent(size) as NSString).appendingPathComponent(image.filePath)

  return ImageEntity(link: link,
                     width: image.width,
                     height: image.height,
                     iso6391: image.iso6391,
                     aspectRatio: image.aspectRatio,
                     voteAverage: image.voteAverage,
                     voteCount: image.voteCount)
}
