import Foundation

public struct AppStateViewModel: Hashable {
  public let title: String
  public let configurations: [AppConfigurationViewModel]
}

public struct AppConfigurationViewModel: Hashable {
  public let title: String
  public let subtitle: String?
  public let value: AppConfigurationViewModelValue

  init(title: String, subtitle: String? = nil, value: AppConfigurationViewModelValue) {
    self.title = title
    self.subtitle = subtitle
    self.value = value
  }
}

public enum AppConfigurationViewModelValue: Hashable {
  case none
  case traktLogin(wantsToLogin: Bool)
  case externalURL(url: URL)
  case hideSpecials(wantsToHideSpecials: Bool)
}
