import HTTPClient

public struct EpisodesService {
  public let episodeDetailsForID: (Int) -> APICallPublisher<EpisodeResponse>

  static func from(apiClient: APIClient) -> EpisodesService {
    .init(
      episodeDetailsForID: { episodeID in
        apiClient.get(
          .init(path: "episodes/\(episodeID)")
        ).decoded(as: EpisodeResponse.self)
      }
    )
  }
}
