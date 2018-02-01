import RxSwift
import TraktSwift

protocol ShowProgressRepository: class {
  func fetchShowProgress(showId: String, hidden: Bool, specials: Bool, countSpecials: Bool) -> Observable<BaseShow>
  func fetchDetailsOf(episodeNumber: Int, on seasonNumber: Int,
                      of showId: String, extended: Extended) -> Observable<Episode>
}

protocol ShowProgressInteractor: class {
  func fetchShowProgress(ids: ShowIds) -> Observable<WatchedShowBuilder>
}

final class WatchedShowBuilder: Hashable {
  let ids: ShowIds
  var detailShow: BaseShow?
  var episode: Episode?

  init(ids: ShowIds, detailShow: BaseShow? = nil, episode: Episode? = nil) {
    self.ids = ids
    self.detailShow = detailShow
    self.episode = episode
  }

  func createEntity(using show: Show) -> WatchedShowEntity {
    return createEntity(using: ShowEntityMapper.entity(for: show))
  }

  func createEntity(using showEntity: ShowEntity) -> WatchedShowEntity {
    let episodeEntity = episode.map { EpisodeEntityMapper.entity(for: $0, showIds: ids) }

    let aired = detailShow?.aired ?? 0
    let completed = detailShow?.completed ?? 0
    let lastWatched = detailShow?.lastWatchedAt

    let entity = WatchedShowEntity(show: showEntity,
                                   aired: aired,
                                   completed: completed,
                                   nextEpisode: episodeEntity,
                                   lastWatched: lastWatched)
    return entity
  }

  var hashValue: Int {
    var hash = ids.hashValue

    if let show = detailShow {
      hash ^= show.hashValue
    }

    if let episode = episode {
      hash ^= episode.hashValue
    }

    return hash
  }

  static func == (lhs: WatchedShowBuilder, rhs: WatchedShowBuilder) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
