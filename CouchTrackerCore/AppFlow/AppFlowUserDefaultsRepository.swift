import Foundation

public final class AppFlowUserDefaultsRepository: AppFlowRepository {
  private static let lastTabKey = "appFlowLastTab"

  private let userDefaults: UserDefaults

  public var lastSelectedTab: Int {
    get {
      userDefaults.integer(forKey: AppFlowUserDefaultsRepository.lastTabKey)
    }
    set {
      userDefaults.set(newValue, forKey: AppFlowUserDefaultsRepository.lastTabKey)
    }
  }

  public init(userDefaults: UserDefaults) {
    self.userDefaults = userDefaults
  }
}
