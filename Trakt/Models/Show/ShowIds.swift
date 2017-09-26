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

public final class ShowIds: BaseIds {
  public let slug: String
  public let tvdb: Int
  public let tvrage: Int?

  public init(trakt: Int, tmdb: Int?, imdb: String?, slug: String, tvdb: Int, tvrage: Int?) {
    self.slug = slug
    self.tvdb = tvdb
    self.tvrage = tvrage
    super.init(trakt: trakt, tmdb: tmdb, imdb: imdb)
  }
  
  public required init(map: Map) throws {
    self.slug = try map.value("slug")
    self.tvdb = try map.value("tvdb")
    self.tvrage = try? map.value("tvrage")
    try super.init(map: map)
  }
  
  public override func mapping(map: Map) {
    self.slug >>> map["slug"]
    self.tvdb >>> map["tvdb"]
    self.tvrage >>> map["tvrage"]
  }
  
  public override var hashValue: Int {
    var hash = super.hashValue ^ slug.hashValue ^ tvdb.hashValue
    if let tvrageHash = tvrage?.hashValue {
      hash = hash ^ tvrageHash
    }
    return hash
  }

  public override var description: String {
    return "\(super.description), slug: \(slug), tvdb: \(tvdb), tvrage: \(String(describing: tvrage))"
  }
}
