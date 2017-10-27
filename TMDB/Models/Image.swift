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
