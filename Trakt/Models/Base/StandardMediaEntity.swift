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

public class StandardMediaEntity: ImmutableMappable, Hashable {
  public var title: String?
  public var overview: String?
  public var rating: Double?
  public var votes: Int?
  public var updatedAt: Date?
  public var translations: [String]?

  public required init(map: Map) throws {
    self.title = try? map.value("title")
    self.overview = try? map.value("overview")
    self.rating = try? map.value("rating")
    self.votes = try? map.value("votes")
    self.translations = try? map.value("available_translations")
    self.updatedAt = try? map.value("updated_at", using: TraktDateTransformer.dateTimeTransformer)
  }

  public var hashValue: Int {
    var hash = 0

    if let titleHash = title?.hashValue {
      hash = hash ^ titleHash
    }

    if let overviewHash = overview?.hashValue {
      hash = hash ^ overviewHash
    }

    if let ratingHash = rating?.hashValue {
      hash = hash ^ ratingHash
    }

    if let votesHash = votes?.hashValue {
      hash = hash ^ votesHash
    }

    if let updatedAtHash = updatedAt?.hashValue {
      hash = hash ^ updatedAtHash
    }

    translations?.forEach { hash = hash ^ $0.hashValue }

    return hash
  }

  public static func == (lhs: StandardMediaEntity, rhs: StandardMediaEntity) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
