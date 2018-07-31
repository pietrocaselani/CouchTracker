import TraktSwift

public final class WatchedShowBuilder: Hashable {
  public let ids: ShowIds
  public var detailShow: BaseShow?
  public var progressShow: BaseShow?
  public var episode: Episode?
  public var seasons: [WatchedSeasonEntity]

  public init(ids: ShowIds, progressShow: BaseShow? = nil,
              episode: Episode? = nil, seasons: [WatchedSeasonEntity] = [WatchedSeasonEntity]()) {
    self.ids = ids
    self.progressShow = progressShow
    self.episode = episode
    self.seasons = seasons
  }

  public func createEntity(using show: Show) -> WatchedShowEntity {
    return createEntity(using: ShowEntityMapper.entity(for: show))
  }

  public func createEntity(using showEntity: ShowEntity) -> WatchedShowEntity {
    let episodeEntity = episode.map { EpisodeEntityMapper.entity(for: $0, showIds: ids) }

    let aired = progressShow?.aired ?? 0
    let completed = progressShow?.completed ?? 0
    let lastWatched = progressShow?.lastWatchedAt

    let entity = WatchedShowEntity(show: showEntity,
                                   aired: aired,
                                   completed: completed,
                                   nextEpisode: episodeEntity,
                                   lastWatched: lastWatched,
                                   seasons: seasons)
    return entity
  }

  public var hashValue: Int {
    var hash = ids.hashValue

    if let show = progressShow {
      hash ^= show.hashValue
    }

    if let episode = episode {
      hash ^= episode.hashValue
    }

    seasons.forEach { hash ^= $0.hashValue }

    return hash
  }

  public static func == (lhs: WatchedShowBuilder, rhs: WatchedShowBuilder) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
