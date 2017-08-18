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

public class BaseEntity: ImmutableMappable {

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

}
