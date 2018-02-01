import RxSwift
import TraktSwift

final class ShowProgressMocks {
  static let showProgressRepository = ShowProgressRepositoryMock()

  private init() {}

  final class ShowProgressRepositoryMock: ShowProgressRepository {
    func fetchShowProgress(showId: String, hidden: Bool, specials: Bool, countSpecials: Bool) -> Observable<BaseShow> {
      let target = Shows.watchedProgress(showId: showId, hidden: hidden, specials: specials, countSpecials: countSpecials)
      return traktProviderMock.shows.rx.request(target).map(BaseShow.self).asObservable()
    }

    func fetchDetailsOf(episodeNumber: Int, on seasonNumber: Int, of showId: String, extended: Extended) -> Observable<Episode> {
      let target = Episodes.summary(showId: showId, season: seasonNumber, episode: episodeNumber, extended: extended)
      return traktProviderMock.episodes.rx.request(target).map(Episode.self).asObservable()
    }
  }

  final class ShowProgressServiceMock: ShowProgressInteractor {
    private let repository: ShowProgressRepository

    init(repository: ShowProgressRepository) {
      self.repository = repository
    }

    func fetchShowProgress(ids: ShowIds) -> Observable<WatchedShowBuilder> {
      let observable = repository.fetchShowProgress(showId: ids.realId,
                                                    hidden: false, specials: false, countSpecials: false)

      return observable.map { WatchedShowBuilder(ids: ids, detailShow: $0, episode: nil) }
        .flatMap { [unowned self] builder -> Observable<WatchedShowBuilder> in
          return self.fetchNextEpisodeDetails(builder)
      }
    }

    private func fetchNextEpisodeDetails(_ builder: WatchedShowBuilder) -> Observable<WatchedShowBuilder> {
      guard let nextEpisode = builder.detailShow?.nextEpisode else { return Observable.just(builder) }

      let observable = repository.fetchDetailsOf(episodeNumber: nextEpisode.number,
                                                  on: nextEpisode.season, of: builder.ids.realId, extended: .full)

      return observable.map { episode in
        builder.episode = episode
        return builder
      }
    }
  }

  final class ShowProgressAPIRepositoryMock: ShowProgressRepository {
	  private let baseShow: BaseShow?
	  private let baseShowError: Error?
	  private let episode: Episode?
	  private let episodeError: Error?

	  init(baseShow: BaseShow? = nil, baseShowError: Error? = nil, episode: Episode? = nil, episodeError: Error? = nil) {
		  self.baseShow = baseShow
		  self.baseShowError = baseShowError
		  self.episode = episode
		  self.episodeError = episodeError
	  }

	  func fetchShowProgress(showId: String, hidden: Bool, specials: Bool, countSpecials: Bool) -> Observable<BaseShow> {
		  if let show = baseShow {
			  return Observable.just(show)
		  }

		  if let showError = baseShowError {
			  return Observable.error(showError)
		  }

		  return Observable.empty()
	  }

	  func fetchDetailsOf(episodeNumber: Int, on seasonNumber: Int, of showId: String, extended: Extended) -> Observable<Episode> {
		  if let episode = episode {
			  return Observable.just(episode)
		  }

		  if let episodeError = episodeError {
			  return Observable.error(episodeError)
		  }

		  return Observable.empty()
	  }
  }
}
