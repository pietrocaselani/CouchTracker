import ObjectMapper

public final class ImagesConfiguration: ImmutableMappable {

  public let secureBaseURL: String
  public let backdropSizes: [String]
  public let posterSizes: [String]
  public let stillSizes: [String]

  public init(map: Map) throws {
    self.secureBaseURL = (try? map.value("secure_base_url")) ?? TMDB.defaultSecureImageURL
    self.backdropSizes = (try map.value("backdrop_sizes")) ?? TMDB.defaultBackdropSizes
    self.posterSizes = (try? map.value("poster_sizes")) ?? TMDB.defaultPosterSizes
    self.stillSizes = (try? map.value("still_sizes")) ?? TMDB.defaultStillSizes
  }
}
