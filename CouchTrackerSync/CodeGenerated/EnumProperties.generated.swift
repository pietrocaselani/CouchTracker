// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// MARK: - EnumProperties

public extension SyncError {
  var isShowIsNil: Bool {
    guard case .showIsNil = self else { return false }
    return true
  }
  var isMissingEpisodes: Bool {
    guard case .missingEpisodes = self else { return false }
    return true
  }
  var missingEpisodes: (showIds: ShowIds, baseSeason: BaseSeason, season: TraktSwift.Season)? {
    guard case let .missingEpisodes(showIds, baseSeason, season) = self else { return nil }
    return (showIds, baseSeason, season)
  }
}
