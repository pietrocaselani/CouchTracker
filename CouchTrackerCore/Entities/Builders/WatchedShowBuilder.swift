import TraktSwift

public final class WatchedShowBuilder: Hashable {
  public let ids: ShowIds
  public let detailShow: BaseShow?
  public let progressShow: BaseShow?
  public let episode: WatchedEpisodeEntity?
  public let seasons: [WatchedSeasonEntity]
  public let genres: [Genre]?

  public init(ids: ShowIds, detailShow: BaseShow? = nil,
              progressShow: BaseShow? = nil, episode: WatchedEpisodeEntity? = nil,
              seasons: [WatchedSeasonEntity] = [WatchedSeasonEntity](), genres: [Genre]? = nil) {
    self.ids = ids
    self.detailShow = detailShow
    self.progressShow = progressShow
    self.episode = episode
    self.seasons = seasons
    self.genres = genres
  }

  @discardableResult
  public func set(episode: WatchedEpisodeEntity?) -> WatchedShowBuilder {
    return WatchedShowBuilder(ids: ids,
                              detailShow: detailShow,
                              progressShow: progressShow,
                              episode: episode,
                              seasons: seasons,
                              genres: genres)
  }

  @discardableResult
  public func set(progressShow: BaseShow?) -> WatchedShowBuilder {
    return WatchedShowBuilder(ids: ids,
                              detailShow: detailShow,
                              progressShow: progressShow,
                              episode: episode,
                              seasons: seasons,
                              genres: genres)
  }

  @discardableResult
  public func set(detailShow: BaseShow?) -> WatchedShowBuilder {
    return WatchedShowBuilder(ids: ids,
                              detailShow: detailShow,
                              progressShow: progressShow,
                              episode: episode,
                              seasons: seasons,
                              genres: genres)
  }

  @discardableResult
  public func set(seasons: [WatchedSeasonEntity]) -> WatchedShowBuilder {
    return WatchedShowBuilder(ids: ids,
                              detailShow: detailShow,
                              progressShow: progressShow,
                              episode: episode,
                              seasons: seasons,
                              genres: genres)
  }

  @discardableResult
  public func set(genres: [Genre]) -> WatchedShowBuilder {
    return WatchedShowBuilder(ids: ids,
                              detailShow: detailShow,
                              progressShow: progressShow,
                              episode: episode,
                              seasons: seasons,
                              genres: genres)
  }

  public func createEntity(using showEntity: ShowEntity) -> WatchedShowEntity {
    return WatchedShowEntity(show: showEntity,
                             aired: progressShow?.aired,
                             completed: progressShow?.completed,
                             nextEpisode: episode,
                             lastWatched: progressShow?.lastWatchedAt,
                             seasons: seasons)
  }

  public func createEntity() -> WatchedShowEntity {
    let showEntity = createShowEntity(using: detailShow?.show)
    return createEntity(using: showEntity)
  }

  private func createShowEntity(using show: Show?) -> ShowEntity {
    let showGenres = genres(for: detailShow?.show)

    return ShowEntity(ids: ids,
                      title: show?.title,
                      overview: show?.overview,
                      network: show?.network,
                      genres: showGenres,
                      status: show?.status,
                      firstAired: show?.firstAired)
  }

  private func genres(for show: Show?) -> [Genre] {
    guard let allGenres = genres else { return [Genre]() }

    return show?.genres(for: allGenres) ?? [Genre]()
  }

  public var hashValue: Int {
    var hash = ids.hashValue
    progressShow.run { hash ^= $0.hashValue }
    detailShow.run { hash ^= $0.hashValue }
    episode.run { hash ^= $0.hashValue }
    seasons.forEach { hash ^= $0.hashValue }
    return hash
  }

  public static func == (lhs: WatchedShowBuilder, rhs: WatchedShowBuilder) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
