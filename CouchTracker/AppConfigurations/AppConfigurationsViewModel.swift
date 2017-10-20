struct AppConfigurationsViewModel: Hashable {
  let title: String
  let configurations: [AppConfigurationViewModel]

  var hashValue: Int {
    var hash = title.hashValue

    configurations.forEach { hash ^= $0.hashValue }

    return hash
  }

  static func == (lhs: AppConfigurationsViewModel, rhs: AppConfigurationsViewModel) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}

struct AppConfigurationViewModel: Hashable {
  let title: String
  let subtitle: String?

  var hashValue: Int {
    var hash = title.hashValue

    if let subtitleHash = subtitle?.hashValue {
      hash ^= subtitleHash
    }

    return hash
  }

  static func == (lhs: AppConfigurationViewModel, rhs: AppConfigurationViewModel) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
