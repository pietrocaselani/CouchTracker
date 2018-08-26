@testable import CouchTrackerCore
import RxSwift
import TraktSwift

final class ShowsProgressMocks {
  private init() {}

  static func createWatchedShowsMock() -> [BaseShow] {
    return try! JSONDecoder().decode([BaseShow].self, from: Sync.watched(type: .shows, extended: .full).sampleData)
  }

  static func createShowMock(_ showId: String) -> BaseShow? {
    let data = Shows.watchedProgress(showId: showId, hidden: false, specials: false, countSpecials: false).sampleData
    return try? JSONDecoder().decode(BaseShow.self, from: data)
  }

  static func createEpisodeMock(_ showId: String) -> Episode {
    let data = Episodes.summary(showId: showId, season: 1, episode: 1, extended: .full).sampleData
    return try! JSONDecoder().decode(Episode.self, from: data)
  }

  static func mockWatchedShowEntity(title: String? = "The Americans") -> WatchedShowEntity {
    let dateTransformer = TraktDateTransformer.dateTimeTransformer

    let ids = ShowIds(trakt: 46263, tmdb: 46533, imdb: "tt2149175", slug: "the-americans-2013", tvdb: 261_690, tvrage: 30449)
			let seasonIds = SeasonIds(tvdb: 10, tmdb: 11, trakt: 12, tvrage: 13)

    let episode0 = mockWatchedEpisode(watched: dateTransformer.transformFromJSON("2017-09-18T02:11:57.000Z"))
    let episode1 = mockWatchedEpisode(watched: nil)

			let season0 = WatchedSeasonEntity(showIds: ids, seasonIds: seasonIds, number: 5, aired: 13, completed: 8, episodes: [episode0, episode1], overview: "Cool season", title: "Season 5")

    let show = ShowEntity(ids: ids,
                          title: title,
                          overview: "The Americans is a period drama about the complex marriage of two KGB spies posing as Americans in suburban Washington D.C. shortly after Ronald Reagan is elected President. The arranged marriage of Philip and Elizabeth Jennings, who have two children - 13-year-old Paige and 10-year-old Henry, who know nothing about their parents' true identity - grows more passionate and genuine by the day, but is constantly tested by the escalation of the Cold War and the intimate, dangerous and darkly funny relationships they must maintain with a network of spies and informants under their control.",
                          network: "FX (US)",
                          genres: [Genre](),
                          status: Status.returning,
                          firstAired: dateTransformer.transformFromJSON("2013-01-30T00:00:00.000Z"))

			let nextEpisode = mockWatchedEpisode(watched: nil)

    return WatchedShowEntity(show: show, aired: 65, completed: 60, nextEpisode: nextEpisode, lastWatched: dateTransformer.transformFromJSON("2017-09-21T12:28:21.000Z"), seasons: [season0])
  }

	static func mockWatchedEpisode(watched: Date? = nil) -> WatchedEpisodeEntity {
		return WatchedEpisodeEntity(episode: mockEpisodeEntity(), lastWatched: watched)
	}

  static func mockWatchedShowEntityWithoutNextEpisode() -> WatchedShowEntity {
    let dateTransformer = TraktDateTransformer.dateTimeTransformer

    let ids = ShowIds(trakt: 46263, tmdb: 46533, imdb: "tt2149175", slug: "the-americans-2013", tvdb: 261_690, tvrage: 30449)

			let episode0 = mockWatchedEpisode(watched: dateTransformer.transformFromJSON("2017-09-18T02:11:57.000Z"))
			let episode1 = mockWatchedEpisode(watched: nil)

			let seasonIds = SeasonIds(tvdb: 1, tmdb: 10, trakt: 12, tvrage: 23)

			let season1 = WatchedSeasonEntity(showIds: ids, seasonIds: seasonIds, number: 1, aired: 10, completed: 5,
																																										episodes: [episode0, episode1], overview: "Cool season", title: "Season 1")

    let show = ShowEntity(ids: ids,
                          title: "The Americans",
                          overview: "The Americans is a period drama about the complex marriage of two KGB spies posing as Americans in suburban Washington D.C. shortly after Ronald Reagan is elected President. The arranged marriage of Philip and Elizabeth Jennings, who have two children - 13-year-old Paige and 10-year-old Henry, who know nothing about their parents' true identity - grows more passionate and genuine by the day, but is constantly tested by the escalation of the Cold War and the intimate, dangerous and darkly funny relationships they must maintain with a network of spies and informants under their control.",
                          network: "FX (US)",
                          genres: [Genre](),
                          status: Status.returning,
                          firstAired: dateTransformer.transformFromJSON("2013-01-30T00:00:00.000Z"))
    return WatchedShowEntity(show: show, aired: 65, completed: 60, nextEpisode: nil,
                             lastWatched: dateTransformer.transformFromJSON("2017-09-21T12:28:21.000Z"),
                             seasons: [season1])
  }

	static func mockShowEntity() -> ShowEntity {
		let dateTransformer = TraktDateTransformer.dateTimeTransformer
		let ids = ShowIds(trakt: 46263, tmdb: 46533, imdb: "tt2149175", slug: "the-americans-2013", tvdb: 261_690, tvrage: 30449)
		return ShowEntity(ids: ids,
																				title: "The Americans",
																				overview: "The Americans is a period drama about...",
																				network: "FX (US)",
																				genres: [Genre](),
																				status: Status.returning,
																				firstAired: dateTransformer.transformFromJSON("2013-01-30T00:00:00.000Z"))
	}

	static func mockEpisodeEntity() -> EpisodeEntity {
		let ids = ShowIds(trakt: 46263, tmdb: 46533, imdb: "tt2149175", slug: "the-americans-2013", tvdb: 261_690, tvrage: 30449)
		let episodeIds = EpisodeIds(trakt: 73640, tmdb: 63056, imdb: "tt1480055", tvdb: 3_254_641, tvrage: 1_065_008_299)
		return EpisodeEntity(ids: episodeIds,
																							showIds: ids,
																							title: "Winter Is Coming",
																							overview: "Ned Stark, Lord of Winterfell learns that his mentor, Jon Arryn, has died and that King Robert is on his way north to offer Ned Arryn’s position as the King’s Hand. Across the Narrow Sea in Pentos, Viserys Targaryen plans to wed his sister Daenerys to the nomadic Dothraki warrior leader, Khal Drogo to forge an alliance to take the throne.",
																							number: 1,
																							season: 1,
																							firstAired: nil)
	}

  static func mockWatchedShowEntityWithoutNextEpisodeDate() -> WatchedShowEntity {
    let dateTransformer = TraktDateTransformer.dateTimeTransformer

    let seasons = [WatchedSeasonEntity]()

    let show = mockShowEntity()
			let episode = mockEpisodeEntity()
			let nextEpisode = WatchedEpisodeEntity(episode: episode, lastWatched: nil)

    return WatchedShowEntity(show: show, aired: 65, completed: 60, nextEpisode: nextEpisode, lastWatched: dateTransformer.transformFromJSON("2017-09-21T12:28:21.000Z"), seasons: seasons)
  }

	final class ShowsProgressRepositoryMock: ShowsProgressRepository {
		  private let trakt: TraktProvider
    private let subject: BehaviorSubject<[WatchedShowEntity]>

    init(trakt: TraktProvider, value: [WatchedShowEntity] = [ShowsProgressMocks.mockWatchedShowEntity()]) {
      self.trakt = trakt
      subject = BehaviorSubject(value: value)
    }

		func fetchWatchedShowsProgress(extended: Extended, hiddingSpecials: Bool) -> Observable<[WatchedShowEntity]> {
			return subject.asObservable()
		}

		func reload(extended: Extended, hiddingSpecials: Bool) -> Completable {
			return Completable.empty()
		}

    func emitsAgain(_ value: [WatchedShowEntity]) {
      subject.onNext(value)
    }
  }

  final class ShowsProgressViewMock: ShowsProgressView {
    var presenter: ShowsProgressPresenter!
    var reloadListInvoked = false
    var showOptionsInvoked = false
    var showViewModelsInvoked = false
    var showErrorInvoked = false
    var showLoadingInvoked = false
    var showEmptyViewInvoked = false
    var showViewModelsParameters: [WatchedShowViewModel]?
    var showErrorParameters: String?
    var showOptionsParameters: (sorting: [String], filtering: [String], currentSort: Int, currentFilter: Int)?

    func show(viewModels: [WatchedShowViewModel]) {
      showViewModelsInvoked = true
      showViewModelsParameters = viewModels
    }

    func showError(message: String) {
      showErrorInvoked = true
      showErrorParameters = message
    }

    func showLoading() {
      showLoadingInvoked = true
    }

    func showEmptyView() {
      showEmptyViewInvoked = true
    }

    func reloadList() {
      reloadListInvoked = true
    }

    func showOptions(for sorting: [String], for filtering: [String], currentSort: Int, currentFilter: Int) {
      showOptionsInvoked = true
      showOptionsParameters = (sorting, filtering, currentSort, currentFilter)
    }
  }

  final class EmptyShowsProgressInteractorMock: ShowsProgressInteractor {
    var listState: ShowProgressListState = ShowProgressListState.initialState

    init(repository _: ShowsProgressRepository,
         listStateDataSource _: ShowsProgressListStateDataSource,
         schedulers _: Schedulers) {}

    func fetchWatchedShowsProgress() -> Observable<[WatchedShowEntity]> {
      return Observable.empty()
    }
  }

  final class ShowsProgressInteractorMock: ShowsProgressInteractor {
    var listState: ShowProgressListState = ShowProgressListState.initialState
    var error: Error?
    var empty = false
    var entities = [WatchedShowEntity]()

    init(repository _: ShowsProgressRepository,
         listStateDataSource _: ShowsProgressListStateDataSource,
         schedulers _: Schedulers) {}

    func fetchWatchedShowsProgress() -> Observable<[WatchedShowEntity]> {
      if let error = error {
        return Observable.error(error)
      }

      if !empty && entities.count == 0 {
        entities.append(ShowsProgressMocks.mockWatchedShowEntity())
        entities.append(ShowsProgressMocks.mockWatchedShowEntityWithoutNextEpisode())
        entities.append(ShowsProgressMocks.mockWatchedShowEntityWithoutNextEpisodeDate())
      }

      return Observable.just(entities)
    }

    func updateListState(newState _: ShowProgressListState) {
    }
  }

  final class ShowsProgressRouterMock: ShowsProgressRouter {
    var showTVShowInvoked = false
    var showTVShowParameter: WatchedShowEntity?

    func show(tvShow entity: WatchedShowEntity) {
      showTVShowInvoked = true
      showTVShowParameter = entity
    }
  }

  final class ShowsProgressDataSourceMock: ShowsProgressDataSource {
    let originalEntities: [WatchedShowEntity]
    var addedEntities = [WatchedShowEntity]()
    var fetchWatchedShowsInvoked = false
    var addWatchedShowInvoked = false
    private let watchedShowsSubject: BehaviorSubject<[WatchedShowEntity]>

    init(entities: [WatchedShowEntity] = []) {
      originalEntities = entities
      watchedShowsSubject = BehaviorSubject<[WatchedShowEntity]>(value: entities)
    }

    func fetchWatchedShows() -> Observable<[WatchedShowEntity]> {
      fetchWatchedShowsInvoked = true
      return watchedShowsSubject.asObservable()
    }

    func addWatched(shows: [WatchedShowEntity]) throws {
      addWatchedShowInvoked = true
      addedEntities.append(contentsOf: shows)

      var newEntities = originalEntities
      newEntities.append(contentsOf: shows)

      watchedShowsSubject.onNext(newEntities)
    }
  }

  final class ShowProgressViewDataSourceMock: ShowsProgressViewDataSource {
    var viewModels = [WatchedShowViewModel]() {
      didSet {
        setViewModelInvoked = true
      }
    }

    var updateInvoked = false
    var setViewModelInvoked = false

    func update() {
      updateInvoked = true
    }
  }

  final class ListStateDataSource: ShowsProgressListStateDataSource {
    var currentStateInvokedCount = 0

    var currentState: ShowProgressListState = ShowProgressListState.initialState {
      didSet {
        currentStateInvokedCount += 1
      }
    }
  }
}
