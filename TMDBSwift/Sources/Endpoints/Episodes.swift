import HTTPClient

public struct EpisodesService {
  public struct ImagesParams: Equatable {
    let showId, season, episode: Int
  }

  public let images: (ImagesParams) -> APICallPublisher<Images>

  static func from(apiClient: APIClient) -> EpisodesService {
    .init(
      images: { params in
        apiClient.get(
          .init(
            path: "tv/\(params.showId)/season/\(params.season)/episode/\(params.episode)/images"
          )
        ).decoded(as: Images.self)
      }
    )
  }
}
