// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// MARK: - EnumProperties

public extension SyncError {
  public var isShowIsNil: Bool {
    guard case .showIsNil = self else { return false }
    return true
  }
  public var isMissingEpisodes: Bool {
    guard case .missingEpisodes = self else { return false }
    return true
  }
  public var missingEpisodes: (showIds: ShowIds, baseSeason: BaseSeason, season: Season)? {
    guard case let .missingEpisodes(showIds, baseSeason, season) = self else { return nil }
    return (showIds, baseSeason, season)
  }
}
