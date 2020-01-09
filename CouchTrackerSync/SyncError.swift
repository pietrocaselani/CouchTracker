public enum SyncError: Error, EnumPoetry {
  case showIsNil
  case missingEpisodes(showIds: ShowIds, baseSeason: BaseSeason, season: Season)
}
