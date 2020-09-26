import HTTPClient

public struct UserService {
  public let settings: () -> APICallPublisher<Settings>

  static func from(apiClient: APIClient) -> UserService {
    .init(
      settings: {
        apiClient.get(
          .init(path: "users/settings")
        )
        .decoded(as: Settings.self)
      }
    )
  }
}
