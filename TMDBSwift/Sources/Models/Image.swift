public struct Image: Codable {
  public let filePath: String
  public let width: Int
  public let height: Int
  public let iso6391: String?
  public let aspectRatio: Float
  public let voteAverage: Float
  public let voteCount: Int

  enum CodingKeys: String, CodingKey {
    case width, height
    case filePath = "file_path"
    case iso6391 = "iso_639_1"
    case aspectRatio = "aspect_ratio"
    case voteAverage = "vote_average"
    case voteCount = "vote_count"
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    filePath = try container.decode(String.self, forKey: .filePath)
    width = try container.decode(Int.self, forKey: .width)
    height = try container.decode(Int.self, forKey: .height)
    iso6391 = try container.decodeIfPresent(String.self, forKey: .iso6391)
    aspectRatio = try container.decode(Float.self, forKey: .aspectRatio)
    voteAverage = try container.decode(Float.self, forKey: .voteAverage)
    voteCount = try container.decode(Int.self, forKey: .voteCount)
  }
}
