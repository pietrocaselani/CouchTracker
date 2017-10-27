import RxSwift
import Trakt

final class ShowProgressMocks {
  static let showProgressRepository = ShowProgressRepositoryMock()

  private init() {}

  final class ShowProgressRepositoryMock: ShowProgressRepository {
    func fetchShowProgress(update: Bool, showId: String, hidden: Bool, specials: Bool, countSpecials: Bool) -> Observable<BaseShow> {
      let target = Shows.watchedProgress(showId: showId, hidden: hidden, specials: specials, countSpecials: countSpecials)
      return traktProviderMock.shows.requestDataSafety(target).mapObject(BaseShow.self)
    }

    func fetchDetailsOf(update: Bool, episodeNumber: Int, on seasonNumber: Int, of showId: String, extended: Extended) -> Observable<Episode> {
      let target = Episodes.summary(showId: showId, season: seasonNumber, episode: episodeNumber, extended: extended)
      return traktProviderMock.episodes.requestDataSafety(target).mapObject(Episode.self)
    }
  }

  final class ShowProgressServiceMock: ShowProgressInteractor {
    private let repository: ShowProgressRepository

    init(repository: ShowProgressRepository) {
      self.repository = repository
    }

    func fetchShowProgress(update: Bool, ids: ShowIds) -> Observable<WatchedShowBuilder> {
      let observable = repository.fetchShowProgress(update: update, showId: ids.realId,
                                                    hidden: false, specials: false, countSpecials: false)

      return observable.map { WatchedShowBuilder(ids: ids, detailShow: $0, episode: nil) }
        .flatMap { [unowned self] builder -> Observable<WatchedShowBuilder> in
          return self.fetchNextEpisodeDetails(builder)
      }
    }

    private func fetchNextEpisodeDetails(_ builder: WatchedShowBuilder) -> Observable<WatchedShowBuilder> {
      guard let nextEpisode = builder.detailShow?.nextEpisode else { return Observable.just(builder) }

      let observable = repository.fetchDetailsOf(update: true, episodeNumber: nextEpisode.number,
                                                  on: nextEpisode.season, of: builder.ids.realId, extended: .full)

      return observable.map { episode in
        builder.episode = episode
        return builder
      }
    }
  }
}
