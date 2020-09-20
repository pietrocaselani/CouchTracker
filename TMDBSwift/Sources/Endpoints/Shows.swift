import HTTPClient

public struct ShowsService {
  public let imagesForShowId: (Int) -> APICallPublisher<Images>

  static func from(apiClient: APIClient) -> ShowsService {
    .init(
      imagesForShowId: { showId in
        apiClient
          .get(.init(path: "tv/\(showId)/images"))
          .decoded(as: Images.self)
      }
    )
  }
}
