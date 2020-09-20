import HTTPClient

public struct MoviesService {
  let imagesForMovieId: (Int) -> APICallPublisher<Images>

  static func from(apiClient: APIClient) -> MoviesService {
    .init(
      imagesForMovieId: { movieId in
        apiClient
          .get(.init(path: "movie/\(movieId)/images"))
          .decoded(as: Images.self)
      }
    )
  }
}
