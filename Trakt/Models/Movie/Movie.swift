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

public final class Movie: StandardMediaEntity {
  public let year: Int
  public let ids: MovieIds
  public let certification: String?
  public let tagline: String?
  public let released: Date?
  public let runtime: Int?
  public let trailer: String?
  public let homepage: String?
  public let language: String?
  public let genres: [String]?

  public required init(map: Map) throws {
    self.year = try map.value("year")
    self.ids = try map.value("ids")
    self.certification = try? map.value("certification")
    self.tagline = try? map.value("tagline")
    self.released = try? map.value("released", using: TraktDateTransformer.dateTransformer)
    self.runtime = try? map.value("runtime")
    self.trailer = try? map.value("trailer")
    self.homepage = try? map.value("homepage")
    self.language = try? map.value("language")
    self.genres = try? map.value("genres")

    try super.init(map: map)
  }

  public override var hashValue: Int {
    var hash = super.hashValue ^ year.hashValue ^ ids.hashValue

    if let certificationHash = certification?.hashValue {
      hash = hash ^ certificationHash
    }

    if let taglineHash = tagline?.hashValue {
      hash = hash ^ taglineHash
    }

    if let releasedHash = released?.hashValue {
      hash = hash ^ releasedHash
    }

    if let runtimeHash = runtime?.hashValue {
      hash = hash ^ runtimeHash
    }

    if let trailerHash = trailer?.hashValue {
      hash = hash ^ trailerHash
    }

    if let homepageHash = homepage?.hashValue {
      hash = hash ^ homepageHash
    }

    if let languageHash = language?.hashValue {
      hash = hash ^ languageHash
    }

    genres?.forEach { hash = hash ^ $0.hashValue }

    return hash
  }
}
