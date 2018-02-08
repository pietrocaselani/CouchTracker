import RxSwift
import TraktSwift

final class ShowProgressMocks {
  static let showProgressRepository = ShowProgressAPIRepositoryMock()

  private init() {}

  final class ShowProgressAPIRepositoryMock: ShowProgressRepository {
	  private let baseShow: BaseShow?
	  private let baseShowError: Error?
	  private let episode: Episode?
	  private let episodeError: Error?
    private let trakt = traktProviderMock

	  init(baseShow: BaseShow? = nil, baseShowError: Error? = nil, episode: Episode? = nil, episodeError: Error? = nil) {
		  self.baseShow = baseShow
		  self.baseShowError = baseShowError
		  self.episode = episode
		  self.episodeError = episodeError
	  }

    func fetchShowProgress(ids: ShowIds) -> Single<WatchedShowBuilder> {
      if let error = baseShowError { return Single.error(error) }

      if let error = episodeError { return Single.error(error) }

      let target = Shows.watchedProgress(showId: ids.realId, hidden: true, specials: true, countSpecials: true)
      let single = trakt.shows.rx.request(target).map(BaseShow.self)

      return single.flatMap { baseShowMock -> Single<WatchedShowBuilder> in
        let builder = WatchedShowBuilder(ids: ids)
        builder.detailShow = baseShowMock
        return self.fetchEpisodeDetails(ids, builder, baseShowMock.nextEpisode)
      }
    }

    private func fetchEpisodeDetails(_ ids: ShowIds, _ builder: WatchedShowBuilder, _ episode: Episode?) -> Single<WatchedShowBuilder> {
      guard let nextEpisode = episode else { return Single.just(builder) }

      let episodeTarget = Episodes.summary(showId: ids.realId, season: nextEpisode.season,
                                           episode: nextEpisode.number, extended: Extended.fullEpisodes)

      let single = self.trakt.episodes.rx.request(episodeTarget).map(Episode.self)
      return single.map { e -> WatchedShowBuilder in
        builder.episode = e
        return builder
      }
    }
  }
}
