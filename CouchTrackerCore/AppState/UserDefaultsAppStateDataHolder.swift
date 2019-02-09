import Foundation

public final class UserDefaultsAppStateDataHolder: AppStateDataHolder {
  private static let appConfigsStateKey = "AppConfigsState"
  private let userDefaults: UserDefaults

  public init(userDefaults: UserDefaults = UserDefaults.standard) {
    self.userDefaults = userDefaults
  }

  public func save(appState: AppState) throws {
    let data = try JSONEncoder().encode(appState)

    userDefaults.set(data, forKey: UserDefaultsAppStateDataHolder.appConfigsStateKey)
  }

  public func currentAppState() throws -> AppState {
    return UserDefaultsAppStateDataHolder.currentAppConfig(userDefaults)
  }

  public static func currentAppConfig(_ userDefaults: UserDefaults) -> AppState {
    guard let data = userDefaults.data(forKey: UserDefaultsAppStateDataHolder.appConfigsStateKey) else {
      return AppState.initialState()
    }

    let configs = try? JSONDecoder().decode(AppState.self, from: data)

    return configs ?? AppState.initialState()
  }
}
