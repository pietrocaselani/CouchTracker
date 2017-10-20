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

public final class Image: ImmutableMappable {
  public let filePath: String
  public let width: Int
  public let height: Int
  public let iso6391: String?
  public let aspectRatio: Float
  public let voteAverage: Float
  public let voteCount: Int

  public init(map: Map) throws {
    self.filePath = try map.value("file_path")
    self.width = try map.value("width")
    self.height = try map.value("height")
    self.iso6391 = try? map.value("iso_639_1")
    self.aspectRatio = try map.value("aspect_ratio")
    self.voteAverage = try map.value("vote_average")
    self.voteCount = try map.value("vote_count")
  }
}
