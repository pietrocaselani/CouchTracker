import Foundation

public struct AppConfigurationsViewModel: Hashable {
  public let title: String
  public let configurations: [AppConfigurationViewModel]

  public var hashValue: Int {
    var hash = title.hashValue

    configurations.forEach { hash ^= $0.hashValue }

    return hash
  }

  public static func == (lhs: AppConfigurationsViewModel, rhs: AppConfigurationsViewModel) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
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

  public var hashValue: Int {
    var hash = title.hashValue

    if let subtitleHash = subtitle?.hashValue {
      hash ^= subtitleHash
    }

    return hash
  }

  public static func == (lhs: AppConfigurationViewModel, rhs: AppConfigurationViewModel) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}

public enum AppConfigurationViewModelValue {
  case none
  case traktLogin(wantsToLogin: Bool)
  case externalURL(url: URL)
  case hideSpecials(wantsToHideSpecials: Bool)
}
