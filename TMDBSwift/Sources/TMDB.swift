import HTTPClient

// swiftlint:disable force_unwrapping
private let baseURL = URL(string: "https://\(apiHost)/\(apiVersion)")!
// swiftlint:enable force_unwrapping
private let apiHost = "api.themoviedb.org"
private let apiVersion = "3"

private let defaultSecureImageURL = "https://image.tmdb.org/t/p/"
private let defaultBackdropSizes = ["w300", "w780", "w1280", "original"]
private let defaultPosterSizes = ["w92", "w154", "w185", "w342", "w500", "w780", "original"]
private let defaultStillSizes = ["w92", "w185", "w300", "original"]

public struct TMDB {
  public let configuration: ConfigurationService
  public let movies: MoviesService
  public let shows: ShowsService
  public let episodes: EpisodesService

  public init(apiKey: String, client: HTTPClient) throws {
    let tmdbMiddleware = TMDBMiddleware(apiKey: apiKey)
    let apiClient = try APIClient(
      client: client.appending(middlewares: [tmdbMiddleware]),
      baseURL: baseURL
    )

    configuration = .from(apiClient: apiClient)
    movies = .from(apiClient: apiClient)
    shows = .from(apiClient: apiClient)
    episodes = .from(apiClient: apiClient)
  }
}

private struct TMDBMiddleware: HTTPMiddleware {
  private let apiKey: String

  init(apiKey: String) {
    self.apiKey = apiKey
  }

  func respond(to request: HTTPRequest, andCallNext responder: HTTPResponding) -> HTTPCallPublisher {
    var request = request
    request.query += [.init(name: "api_key", value: self.apiKey)]

    return responder.respond(to: request)
  }
}
