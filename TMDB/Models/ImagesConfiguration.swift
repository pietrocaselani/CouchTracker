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

import ObjectMapper

public final class ImagesConfiguration: ImmutableMappable {

  public let secureBaseURL: String
  public let backdropSizes: [String]
  public let posterSizes: [String]

  public init(map: Map) throws {
    self.secureBaseURL = (try? map.value("secure_base_url")) ?? TMDB.defaultSecureImageURL
    self.backdropSizes = (try map.value("backdrop_sizes")) ?? TMDB.defaultBackdropSizes
    self.posterSizes = (try? map.value("poster_sizes")) ?? TMDB.defaultPosterSizes
  }
}
