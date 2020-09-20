import HTTPClient

public struct ConfigurationService {
  public let get: () -> APICallPublisher<Configuration>

  static func from(apiClient: APIClient) -> ConfigurationService {
    .init(
      get: {
        apiClient
          .get(.init(path: "configuration"))
          .decoded(as: Configuration.self)
      }
    )
  }
}
