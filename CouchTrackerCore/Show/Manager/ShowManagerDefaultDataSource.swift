import Foundation

public final class ShowManagerDefaultDataSource: ShowManagerDataSource {
  private static let lastTabKey = "showManagerLastTab"

  private let show: WatchedShowEntity
  private let userDefaults: UserDefaults
  private let creator: ShowManagerModuleCreator

  public var showTitle: String?
  public var options: [ShowManagerOption]
  public var modulePages: [ModulePage] {
    return options.map {
      let view = creator.createModule(for: $0)
      let name = moduleNameFor(option: $0)
      return ModulePage(page: view, title: name)
    }
  }

  public var defaultModuleIndex: Int {
    get {
      return userDefaults.integer(forKey: ShowManagerDefaultDataSource.lastTabKey)
    }
    set {
      userDefaults.set(newValue, forKey: ShowManagerDefaultDataSource.lastTabKey)
    }
  }

  public init(show _: WatchedShowEntity, creator _: ShowManagerModuleCreator) {
    Swift.fatalError("Please, use init(show: creator: userDefaults:)")
  }

  public init(show: WatchedShowEntity, creator: ShowManagerModuleCreator, userDefaults: UserDefaults) {
    self.show = show
    self.creator = creator
    self.userDefaults = userDefaults

    let overview = ShowManagerOption.overview
    let episode = ShowManagerOption.episode
    let seasons = ShowManagerOption.seasons

    showTitle = show.show.title
    options = [overview, episode, seasons]
  }

  private func moduleNameFor(option: ShowManagerOption) -> String {
    switch option {
    case .episode:
      return CouchTrackerCoreStrings.episode()
    case .overview:
      return CouchTrackerCoreStrings.overview()
    case .seasons:
      return CouchTrackerCoreStrings.seasons()
    }
  }
}
