// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// MARK: - EnumClosures

public extension SyncError {
  func onShowIsNil(_ action: () -> Void) {
    guard case .showIsNil = self else { return }
    action()
  }
  func onMissingEpisodes(_ action: (ShowIds, BaseSeason, Season) -> Void) {
    guard case let .missingEpisodes(showIds, baseSeason, season) = self else { return }
    action(showIds, baseSeason, season)
  }
}
